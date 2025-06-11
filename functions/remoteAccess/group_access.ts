import {logger} from "firebase-functions";
import {onCall} from "firebase-functions/v2/https";
import {getFirestore} from "firebase-admin/firestore";
import {getDatabase} from "firebase-admin/database";

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

    return "removed";
  } catch (e) {
    logger.error(e);
    return "fail";
  }
}

export const adminRemoveGroup = onCall(async (request) => {
  const groupUid: string = request.data.groupUid;

  if (groupUid.length === 0) {
    return "failed";
  }

  return await closeGroup(groupUid);
});
