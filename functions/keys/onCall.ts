import {onCall, HttpsError} from "firebase-functions/v2/https";
import {makeid, increaseKey} from "../src/keys";
import {getFirestore} from "firebase-admin/firestore";

export const createNewKeys = onCall(async (request) => {
  const keyAmount = request.data.keyAmount;
  const newKeys = [];
  for (let i = 0; i < keyAmount; i++) {
    let code = makeid(5);
    let unicue = false;

    while (!unicue) {
      const info = await getFirestore()
        .collection("alphaKeys")
        .where("key", "==", code)
        .count()
        .get();

      if (info.data().count == 0) {
        unicue = true;
      } else {
        code = increaseKey(code);
      }
    }

    newKeys.push(code);

    await getFirestore().collection("alphaKeys").doc(code).create({key: code});
  }

  return newKeys;
});

export const getAllKeys = onCall(async () => {
  const keys: string[] = [];
  await getFirestore()
    .collection("alphaKeys")
    .get()
    .then((output) => {
      output.docs.forEach((doc) => {
        keys.push(doc.data().key as string);
      });
    })
    .catch((error) => {
      throw new HttpsError(error.code, error.message);
    });

  return {keys: keys, amount: keys.length};
});

export const checkKey = onCall(async (request) => {
  const key: string = request.data.key;
  let valid = false;
  await getFirestore()
    .collection("alphaKeys")
    .where("key", "==", key)
    .get()
    .then((output) => {
      output.docs.forEach((doc) => {
        if (doc.data().key == key) {
          valid = true;
          doc.ref.delete();
        }
      });
    });
  return valid;
});
