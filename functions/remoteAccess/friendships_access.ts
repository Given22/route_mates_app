import {getFirestore} from "firebase-admin/firestore";
import {onCall} from "firebase-functions/v2/https";
import {logger} from "firebase-functions";

export const adminRemoveFriendship = onCall(async (request) => {
  try {
    const userOne: string = request.data.userOne;
    const userTwo: string = request.data.userTwo;

    if (userOne.length === 0 && userTwo.length === 0) {
      return "failed to remove, incorrect data: " + userOne + " and " + userTwo;
    }

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
