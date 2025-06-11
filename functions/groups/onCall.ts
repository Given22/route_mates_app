import {logger} from "firebase-functions";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {getFirestore, Timestamp} from "firebase-admin/firestore";
import {getDatabase} from "firebase-admin/database";
import {getAuth} from "firebase-admin/auth";

export const createNewGroup = onCall(async (request) => {
  try {
    if (request.auth === undefined) throw new Error();

    const user = request.auth.uid;

    const name = request.data.name as string;
    const location = request.data.location;
    const publicGroup = request.data.public;

    const docRef = getFirestore().collection("groups").doc();

    await docRef.create({
      name: name,
      location: location,
      public: publicGroup,
      master: user,
    });

    const groupUid = docRef.id;

    const userData = await getAuth().getUser(user);

    await docRef
      .collection("members")
      .doc(user)
      .create({name: userData.displayName});

    await getFirestore()
      .collection("users")
      .doc(user)
      .update({group: {name: name, uid: groupUid}});

    return groupUid;
  } catch {
    return new Error("Fail");
  }
});

export const joinViaKey = onCall(async (request) => {
  try {
    if (request.auth === undefined) throw new Error();
    const key = request.data.key;
    const user = request.auth.uid;

    const docRef = getFirestore()
      .collection("groups")
      .where("key", "==", key)
      .limit(1);

    const docs = await docRef.get();
    if (docs.empty) throw new HttpsError("not-found", "group not found");

    const doc = docs.docs[0];

    const groupUid = doc.id;
    const userData = await getAuth().getUser(user);

    await getFirestore()
      .collection("groups")
      .doc(groupUid)
      .collection("members")
      .doc(user)
      .set({
        name: userData.displayName,
      });

    await getFirestore()
      .collection("users")
      .doc(user)
      .update({group: {name: doc.data().name, uid: groupUid}});

    return "success";
  } catch {
    return "fail";
  }
});

export const joinGroup = onCall(async (request) => {
  try {
    if (request.auth === undefined) throw new Error();
    const user = request.auth.uid;
    const groupUid = request.data.groupId;
    const groupName = request.data.groupName;
    const userData = await getAuth().getUser(user);

    await getFirestore()
      .collection("groups")
      .doc(groupUid)
      .collection("members")
      .doc(user)
      .create({
        name: userData.displayName,
      });

    await getFirestore()
      .collection("users")
      .doc(user)
      .update({group: {name: groupName, uid: groupUid}});

    return "success";
  } catch (e) {
    logger.error(e);
    return "fail";
  }
});

export const leaveGroup = onCall(async (request) => {
  try {
    if (request.auth === undefined) throw new Error();
    const user = request.auth.uid;
    await getFirestore()
      .collection("users")
      .doc(user)
      .get()
      .then(async (doc) => {
        const data = doc.data();
        if (data === undefined) throw new Error();

        await getFirestore()
          .collection("groups")
          .doc(data.group.uid)
          .collection("members")
          .doc(user)
          .delete();

        await getDatabase().ref(`/groups/${data.group.uid}/${user}`).remove();

        doc.ref.update({group: {}});
      });

    return "success";
  } catch {
    return "fail";
  }
});

export const inviteToGroup = onCall(async (request) => {
  try {
    if (request.auth === undefined) throw new Error();

    const groupId = request.data.groupId;
    const name = request.data.groupName;
    const to = request.data.to;

    logger.info(`Inviting ${to} to group ${groupId}`);
    const us = await getAuth().getUser(request.auth.uid);

    await getFirestore()
      .collection("groups")
      .doc(groupId)
      .collection("send requests")
      .doc(to)
      .set({send: true});

    await getFirestore()
      .collection("users")
      .doc(to)
      .collection("got requests")
      .doc(groupId)
      .set({
        date: Timestamp.now(),
        user: {uid: request.auth.uid, name: us.displayName},
        group: {uid: groupId, name: name},
        type: "group",
      });

    return "invited";
  } catch (e) {
    logger.error(e);
    return "fail";
  }
});

/** Close group
 * groupId is the closen group id
 * @param {string} groupId
 * @return {string} "removed" on success, otherwise "fail"
 *  */
async function closeGroup(groupId: string): Promise<string> {
  const bulkWriter = getFirestore().bulkWriter();
  const MAX_RETRY_ATTEMPTS = 3;
  bulkWriter.onWriteError((error) => {
    if (error.failedAttempts < MAX_RETRY_ATTEMPTS) {
      return true;
    } else {
      console.log("Failed write at document: ", error.documentRef.path);
      return false;
    }
  });

  try {
    const ref = getFirestore().collection("groups").doc(groupId);

    ref.get().then(async (doc) => {
      if (doc.data() === undefined) throw new Error();

      await getFirestore()
        .collection("groupKeys")
        .where("key", "==", doc.data()!.key)
        .get()
        .then((snap) => {
          snap.docs.forEach((doc) => {
            doc.ref.delete();
          });
        });
    });

    ref
      .collection("members")
      .get()
      .then(async (querySnapshot) => {
        querySnapshot.forEach(async (doc) => {
          await getFirestore()
            .collection("users")
            .doc(doc.id)
            .update({group: {}});
        });
      });

    await getFirestore().recursiveDelete(ref, bulkWriter);

    await getDatabase().ref(`/groups/${groupId}`).remove();

    return "closed";
  } catch (e) {
    logger.error(e);
    return "fail";
  }
}

export const acceptGroupInvitation = onCall(async (request) => {
  try {
    if (request.auth === undefined) throw new Error();
    const user = request.auth.uid;
    const groupId = request.data.groupId;
    const groupName = request.data.groupName;
    const userData = await getAuth().getUser(user);

    await getFirestore()
      .collection("users")
      .doc(user)
      .get()
      .then(async (doc) => {
        const data = doc.data();
        await Promise.all([
          getFirestore()
            .collection("groups")
            .doc(groupId)
            .collection("send requests")
            .doc(user)
            .delete(),

          getFirestore()
            .collection("users")
            .doc(user)
            .collection("got requests")
            .doc(groupId)
            .delete(),

          getFirestore()
            .collection("users")
            .doc(user)
            .update({group: {name: groupName, uid: groupId}}),

          getFirestore()
            .collection("groups")
            .doc(groupId)
            .collection("members")
            .doc(user)
            .create({
              name: userData.displayName,
            }),
        ]);

        if (!(data === undefined || data === null || data.group.isEmpty)) {
          logger.log(`Remove ${user} from ${data.group.uid}`);
          Promise.all([
            getFirestore()
              .collection("groups")
              .doc(data.group.uid)
              .collection("members")
              .doc(user)
              .delete(),

            getDatabase().ref(`/groups/${data.group.uid}/${user}`).remove(),

            getFirestore()
              .collection("groups")
              .doc(data.group.uid)
              .get()
              .then(async (group) => {
                const groupData = group.data();
                if (groupData === undefined) throw new Error();
                logger.log(
                  `Close ${data.group.uid} by master ${user} if: ${
                    groupData.master === user
                  }`,
                );
                if (groupData.master === user) {
                  await closeGroup(data.group.uid);
                  logger.log(
                    `Close ${data.group.uid} by master ${user} successfully`,
                  );
                }
              }),
          ]);

          logger.log(`Remove ${user} from ${data.group.uid} successfully`);
        }
      });

    return "accepted";
  } catch (e) {
    logger.error(e);
    return "fail";
  }
});

export const declineGroupInvitation = onCall(async (request) => {
  try {
    if (request.auth === undefined) throw new Error();
    const groupId = request.data.groupId;
    const who = request.auth.uid;
    Promise.race([
      getFirestore()
        .collection("groups")
        .doc(groupId)
        .collection("send requests")
        .doc(who)
        .delete(),

      getFirestore()
        .collection("users")
        .doc(who)
        .collection("got requests")
        .doc(groupId)
        .delete(),
    ]);

    return "declined";
  } catch (e) {
    logger.error(e);
    return "fail";
  }
});

export const removeGroupMember = onCall(async (request) => {
  const groupId = request.data.groupId;
  const who = request.data.userId;

  try {
    Promise.race([
      getFirestore()
        .collection("groups")
        .doc(groupId)
        .collection("members")
        .doc(who)
        .delete(),

      getFirestore().collection("users").doc(who).update({group: {}}),
    ]);

    return "removed";
  } catch (e) {
    logger.error(e);
    return "fail";
  }
});

export const removeGroup = onCall(async (request) => {
  const groupId = request.data.groupId;

  return await closeGroup(groupId);
});
