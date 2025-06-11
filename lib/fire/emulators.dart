import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseEmulators {
  Future<void> init() async {
    if (_shouldUseEmulator()) {
      await _connectToFirebaseEmulators();
    }
  }

  bool _shouldUseEmulator() {
    bool useEmulator = false;

    assert(() {
      useEmulator = const bool.fromEnvironment('emulators');
      return true;
    }());

    return useEmulator;
  }

  Future _connectToFirebaseEmulators() async {
    final localHostString = Platform.isAndroid ? '127.0.0.1' : 'localhost';

    await FirebaseAuth.instance.useAuthEmulator(localHostString, 9099);
    await FirebaseStorage.instance.useStorageEmulator(localHostString, 9199);
    FirebaseFirestore.instance.useFirestoreEmulator(localHostString, 8087);
    FirebaseFunctions.instance.useFunctionsEmulator(localHostString, 5001);
    FirebaseDatabase.instance.useDatabaseEmulator(localHostString, 9003);
  }
}
