import {logger} from "firebase-functions";
import {onCall} from "firebase-functions/v2/https";
import {getFirestore, Timestamp} from "firebase-admin/firestore";
import {getAuth} from "firebase-admin/auth";

export const invitePerson = onCall(async (request) => {
  try {
    if (request.auth === undefined) throw new Error();
    const from = request.auth.uid;
    const to = request.data.to;

    if (from === to) {
      throw new Error("You can't invite yourself");
    }

    const us = await getAuth().getUser(from);

    Promise.all([
      getFirestore()
        .collection("users")
        .doc(from)
        .collection("send requests")
        .doc(to)
        .create({send: true}),
      getFirestore()
        .collection("users")
        .doc(to)
        .collection("got requests")
        .doc(from)
        .create({
          date: Timestamp.now(),
          user: {uid: request.auth.uid, name: us.displayName},
          type: "friend",
        }),
    ]);
    logger.log(`New friendship request, from: ${from} to: ${to}`);

    return "invited";
  } catch {
    return "fail";
  }
});

export const acceptFriendship = onCall(async (request) => {
  try {
    if (request.auth === undefined) throw new Error();
    const userOne = request.auth.uid;
    const userTwo = request.data.withWho;

    const userOneAuth = await getAuth().getUser(userOne);
    const userTwoAuth = await getAuth().getUser(userTwo);
    Promise.all([
      //  Add friend to userOne
      getFirestore()
        .collection("users")
        .doc(userOne)
        .collection("friends")
        .doc(userTwo)
        .create({name: userTwoAuth.displayName}),
      //  Add friend to userTwo
      getFirestore()
        .collection("users")
        .doc(userTwo)
        .collection("friends")
        .doc(userOne)
        .create({name: userOneAuth.displayName}),
      //   Remove request from userOne
      getFirestore()
        .collection("users")
        .doc(userOne)
        .collection("got requests")
        .doc(userTwo)
        .delete(),
      //   Remove request from userTwo
      getFirestore()
        .collection("users")
        .doc(userTwo)
        .collection("send requests")
        .doc(userOne)
        .delete(),
    ]);

    logger.log(`New friendship, between: ${userOne} and: ${userTwo}`);
    return "accepted";
  } catch {
    return "fail";
  }
});

export const declineFriendship = onCall(async (request) => {
  try {
    if (request.auth === undefined) throw new Error();
    const userOne = request.auth.uid;
    const userTwo = request.data.withWho;

    Promise.all([
      //   Remove request from userOne
      getFirestore()
        .collection("users")
        .doc(userOne)
        .collection("got requests")
        .doc(userTwo)
        .delete(),
      //   Remove request from userTwo
      getFirestore()
        .collection("users")
        .doc(userTwo)
        .collection("send requests")
        .doc(userOne)
        .delete(),
    ]);

    logger.log(`Declined friendship request, from: ${userOne} to: ${userTwo}`);
    return "declined";
  } catch {
    return "fail";
  }
});

export const removeFriendship = onCall(async (request) => {
  try {
    if (request.auth === undefined) throw new Error();
    const userOne = request.auth.uid;
    const userTwo = request.data.withWho;

    Promise.all([
      //  Remove friend from userOne
      getFirestore()
        .collection("users")
        .doc(userOne)
        .collection("friends")
        .doc(userTwo)
        .delete(),
      //  Remove friend from userTwo
      getFirestore()
        .collection("users")
        .doc(userTwo)
        .collection("friends")
        .doc(userOne)
        .delete(),
    ]);

    logger.log(`Friendship removed, between: ${userOne} and: ${userTwo}`);
    return "removed";
  } catch {
    return "fail";
  }
});
