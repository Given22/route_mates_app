import {getFirestore} from "firebase-admin/firestore";
import {onCall} from "firebase-functions/v2/https";

export const adminRemoveVehicle = onCall(async (request) => {
  const user: string = request.data.user;
  const vehicle: string = request.data.vehicle;

  if (user.length === 0 && vehicle.length === 0) {
    return "failed to remove, incorrect data: " + user + " and " + vehicle;
  }

  try {
    await getFirestore()
      .collection("users")
      .doc(user)
      .collection("garage")
      .doc(vehicle)
      .delete();

    await getFirestore()
      .collection("users")
      .doc(user)
      .get()
      .then((value) => {
        if (value.data() === undefined) throw new Error();

        if ((value.data()!["activeVehicle"] as string) === vehicle) {
          getFirestore()
            .collection("users")
            .doc(user)
            .update({activeVehicle: ""});
        }
      });

    return "removed";
  } catch {
    return "fail";
  }
});
