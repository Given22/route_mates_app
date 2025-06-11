import {getFirestore} from "firebase-admin/firestore";
import {onCall} from "firebase-functions/v2/https";

export const addNewVehicle = onCall((request) => {
  const name = request.data.name;
  const shortDescription = request.data.short_description;
  const description = request.data.description;
  const uid = request.data.uid;

  try {
    if (request.auth === undefined) throw new Error();

    getFirestore()
      .collection("users")
      .doc(request.auth.uid)
      .collection("garage")
      .doc(uid)
      .create({
        name: name,
        description: description ?? "",
        shortDescription: shortDescription ?? "",
      });

    return "added";
  } catch {
    return "fail";
  }
});

export const editVehicle = onCall((request) => {
  const name = request.data.name;
  const shortDescription = request.data.short_description;
  const description = request.data.description;
  const uid = request.data.uid;

  try {
    if (request.auth === undefined) throw new Error();

    getFirestore()
      .collection("users")
      .doc(request.auth.uid)
      .collection("garage")
      .doc(uid)
      .update({
        name: name,
        description: description ?? "",
        shortDescription: shortDescription ?? "",
      });

    return "edited";
  } catch {
    return "fail";
  }
});

export const removeVehicle = onCall((request) => {
  const uid = request.data.uid;

  try {
    if (request.auth === undefined) throw new Error();

    getFirestore()
      .collection("users")
      .doc(request.auth.uid)
      .collection("garage")
      .doc(uid)
      .delete();

    getFirestore()
      .collection("users")
      .doc(request.auth.uid)
      .get()
      .then((value) => {
        if (request.auth === undefined) throw new Error();
        if (value.data() === undefined) throw new Error();

        if ((value.data()!["activeVehicle"] as string) === uid) {
          getFirestore()
            .collection("users")
            .doc(request.auth.uid)
            .update({activeVehicle: ""});
        }
      });

    return "removed";
  } catch {
    return "fail";
  }
});
