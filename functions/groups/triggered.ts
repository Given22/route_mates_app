import {
  onDocumentCreated,
  onDocumentDeleted,
} from "firebase-functions/v2/firestore";
import {getDatabase} from "firebase-admin/database";
import {makeid, increaseKey} from "../src/keys";
import {getFirestore} from "firebase-admin/firestore";
import admin = require("firebase-admin");

export const generateGroupCode = onDocumentCreated(
  "groups/{groupId}",
  async (event) => {
    let code = makeid(5);
    let unicue = false;

    while (!unicue) {
      const info = await getFirestore()
        .collection("groupKeys")
        .where("key", "==", code)
        .count()
        .get();

      if (info.data().count == 0) {
        unicue = true;
      } else {
        code = increaseKey(code);
      }
    }

    if (event.data == undefined) return;

    await event.data.ref.update({key: code});

    return getFirestore().collection("groupKeys").add({key: code});
  },
);

export const removeGroupPhotoOnDelete = onDocumentDeleted(
  "groups/{groupId}",
  async (event) => {
    await getDatabase().ref(`groups/${event.params.groupId}`).remove();

    return await admin
      .storage()
      .bucket()
      .file(`groups/${event.params.groupId}.jpg`)
      .delete();
  },
);
