import functions = require("firebase-functions/v1");
import {getFirestore} from "firebase-admin/firestore";
import {getMessaging} from "firebase-admin/messaging";
import admin = require("firebase-admin");
import {
  onDocumentDeleted,
  onDocumentCreated,
} from "firebase-functions/v2/firestore";

export const removeUserFromFirestore = functions.auth
  .user()
  .onDelete(async (user) => {
    const bulkWriter = admin.firestore().bulkWriter();
    const MAX_RETRY_ATTEMPTS: number = 3;

    bulkWriter.onWriteError((error) => {
      if (error.failedAttempts < MAX_RETRY_ATTEMPTS) {
        return true;
      } else {
        console.log("Failed write at document: ", error.documentRef.path);
        return false;
      }
    });

    await admin
      .storage()
      .bucket()
      .file(`profile pictures/${user.uid}.jpg`)
      .delete()
      .catch(() => {});

    await getFirestore()
      .collection("notification_tokens")
      .where("user_id", "==", user.uid)
      .get()
      .then((querySnapshot) => {
        querySnapshot.docs.forEach((doc) => {
          doc.ref.delete();
        });
      });

    const ref = admin.firestore().collection("users").doc(user.uid);
    return await admin.firestore().recursiveDelete(ref, bulkWriter);
  });

export const removeVehiclePhotoOnDelete = onDocumentDeleted(
  "users/{userId}/garage/{vehicleId}",
  async (event) => {
    return await admin
      .storage()
      .bucket()
      .file(`vehicles/${event.params.vehicleId}.jpg`)
      .delete();
  },
);

export const notifyUserOnInvitation = onDocumentCreated(
  "users/{userId}/got requests/{requestId}",
  async (event) => {
    const snapshot = await getFirestore()
      .collection("notification_tokens")
      .where("user_id", "==", event.params.userId)
      .get();

    const tokens = snapshot.docs.map((doc) => doc.id);

    const requestData = event.data?.data();

    if (requestData === undefined) return;

    const type: string = requestData["type"];
    const who: string = requestData["user"]["name"];

    let body: string = `${who} has sent you a request`;

    if (type === "group") {
      body = `${who} sent you an invitation to join the group`;
    } else if (type === "friend") {
      body = `${who} sent you a friend request`;
    }

    const promises = tokens.map(async (registrationToken) => {
      const message = {
        data: {
          type: type,
          who: who,
        },
        notification: {
          title: "You have got new invitation!",
          body: body,
        },
        token: registrationToken,
      };

      try {
        const response = await getMessaging().send(message);
        console.log(
          "Successfully sent message to: ",
          registrationToken,
          " with response: ",
          response,
        );
      } catch (error) {
        // jeśli nie mogliśmy dostarczyć wiadomości
        // ( token był nie prawidłowy to znaczy że można go usunąć z bazy )
        console.log("Error sending message:", error);
      }
    });

    return await Promise.all(promises);
  },
);
