import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class DB {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

  get profileFolder => 'profile pictures';
  get groupFolder => 'groups';
  get vehicleFolder => 'vehicles';

  get profileAsset => 'assets/pngs/person.png';
  get groupAsset => 'assets/pngs/group.png';

  Future<void> uploadPhoto(
      {required File file, required String folder, required String uid}) async {
    final groupsPicturesRef = storageRef.child(folder);

    final profilePicture = groupsPicturesRef.child('$uid.jpg');
    await profilePicture.putFile(file);
  }

  Future<void> deletePhoto(
      {required String folder, required String uid}) async {
    final profilePicturesRef = storageRef.child(folder);

    final profilePicture = profilePicturesRef.child('$uid.jpg');
    await profilePicture.delete();
  }

  Future<String> getPhotoUrl(
      {required String folder, required String uid}) async {
    try {
      final storage = DB().storage;
      final ref = storage.ref().child('$folder/$uid.jpg');
      final imageUrl = await ref.getDownloadURL();

      return imageUrl;
    } on PlatformException {
      return '';
    } catch (e) {
      return '';
    }
  }

  Future<Uint8List?> getPhotoUint8List(
      {required String folder, required String uid}) async {
    try {
      final storage = DB().storage;
      final ref = storage.ref().child('$folder/$uid.jpg');
      final imageUrl = await ref.getData();

      return imageUrl;
    } catch (e) {
      return null;
    }
  }
}
