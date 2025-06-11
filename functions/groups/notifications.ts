import {onCall} from "firebase-functions/v2/https";
import {getDatabase} from "firebase-admin/database";
import {getFirestore} from "firebase-admin/firestore";
import {getMessaging} from "firebase-admin/messaging";
import {logger} from "firebase-functions";

const LIVE_MINUTES: number = 15 * 60 * 1000;
const ONE_MINUTES: number = 60 * 1000;

export const sendAlertToGroup = onCall(async (request) => {
  const groupId = request.data.groupId;
  const who = request.auth?.uid;
  const whoName = request.data.name;
  const alertTag = request.data.alertTag;

  if (who === undefined) return "failed";

  const snapshot = await getDatabase().ref(`/groups/${groupId}`).get();

  const val = snapshot.val();

  const users = val === null ? [] : Object.keys(val);

  const liveUsers: string[] = [];

  const currentTime = new Date().getTime();

  users.forEach((userId) => {
    const userData = val[userId];

    if (
      typeof userData === "object" &&
      userData["date"] !== null &&
      typeof userData["date"] === "number"
    ) {
      if (currentTime - userData["date"] <= LIVE_MINUTES) {
        liveUsers.push(userId);
      }
    }
  });

  if (liveUsers.length === 0) {
    return "Don't have any user to send sign.";
  }

  const tokenSnap = await getFirestore()
    .collection("notification_tokens")
    .where("user_id", "in", liveUsers)
    .get();

  const tokens = tokenSnap.docs.map((doc) => doc.id);

  let body: string = "Unknown sign..";

  if (alertTag === "police") {
    body = "Watch out for the police!";
  }
  if (alertTag === "emergency") {
    body = "I have to make an emergency stop!";
  }
  if (alertTag === "gas_station") {
    body = "I need to refuel";
  }
  if (alertTag === "stop") {
    body = "I need to stop for a little rest";
  }
  if (alertTag === "traffic") {
    body = "I'm behind because I stopped at the traffic lights";
  }
  if (alertTag === "follow_me") {
    body = "Follow me";
  }

  const expiration = Math.round(new Date().getTime() / 1000) + 120;

  const promises = tokens.map(async (registrationToken) => {
    const message = {
      data: {
        type: "alert",
        who: who,
        whoName: whoName,
        alertTag: alertTag,
      },
      notification: {
        title: `${whoName} sent a sign`,
        body: body,
      },
      token: registrationToken,
      apns: {
        headers: {
          "apns-expiration": `${expiration}`,
        },
      },
      android: {
        ttl: ONE_MINUTES,
      },
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

  await Promise.all(promises);

  logger.log(
    `${who} 
    sent sign: ${alertTag} 
    to group: ${groupId}, 
    live users: ${liveUsers}`,
  );
  return "success";
});
