import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:route_mates/data/exception.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/firestore.dart';

class GroupSettings {
  GroupSettings({
    required this.group,
  }) {
    groupUid = group.uid;
  }

  final Group group;
  late String groupUid;

  Future removePhoto() async {
    try {
      await DB().deletePhoto(folder: DB().groupFolder, uid: groupUid);
    } on FirebaseException catch (e) {
      if (e.code == "object-not-found") {
        return;
      }
      Fluttertoast.showToast(msg: e.message ?? "Error deleting group photo");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future setPhoto(File file) async {
    try {
      await DB().uploadPhoto(
        file: file,
        folder: DB().groupFolder,
        uid: groupUid,
      );
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Error uploading profile photo");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future setName(String name) async {
    if (name == group.name) {
      return;
    }

    if (await Store().groupNameAlreadyExists(name)) {
      throw MyException("Group name already exists");
    }

    await Store().updateGroupName(
      name: name,
      groupId: groupUid,
    );
  }

  Future setLocation(String location) async {
    try {
      if (location == group.location) {
        return;
      }

      await Store().updateGroupLocation(
        location: location,
        groupId: groupUid,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
