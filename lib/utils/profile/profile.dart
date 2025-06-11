import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:route_mates/data/exception.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/utils/confirm_action_service.dart';

class Profile {
  final profileUid = Auth().currentUser?.uid;
  final profileName = Auth().currentUser?.displayName;

  Future removePhoto() async {
    try {
      if (profileUid == null) {
        throw Exception("profile not found");
      }

      await DB().deletePhoto(folder: DB().profileFolder, uid: profileUid!);
    } on FirebaseException catch (e) {
      if (e.code == "object-not-found") {
        return;
      }
      Fluttertoast.showToast(msg: e.message ?? "Error deleting profile photo");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future setPhoto(File file) async {
    if (profileUid == null) {
      throw MyException("profile not found");
    }

    await DB().uploadPhoto(
      file: file,
      folder: DB().profileFolder,
      uid: profileUid!,
    );
  }

  Future setName(String name) async {
    if (name == profileName) {
      return;
    }

    if (await Store().nameAlreadyExists(name)) {
      throw MyException("name already exists");
    }

    await Auth().updateProfile(displayName: name);
    await Store().updateUserName(displayName: name);
  }

  Future setNewName(String name) async {
    if (await Store().nameAlreadyExists(name)) {
      throw MyException("Name already exists");
    }

    await Auth().updateProfile(displayName: name);
    await Store().createNewUserRecord(displayName: name);
  }

  Future setNewPassword(String password, BuildContext context) async {
    final userSecurity = await ConfirmAction().reloginWithPassword(context);

    final credential = EmailAuthProvider.credential(
        email: userSecurity.email, password: userSecurity.password);

    await Auth().currentUser!.reauthenticateWithCredential(credential);

    if (password.isNotEmpty) {
      await Auth().currentUser!.updatePassword(password);
    }
  }
}
