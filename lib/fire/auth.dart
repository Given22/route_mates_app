import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:route_mates/utils/confirm_action_service.dart';
import 'package:route_mates/utils/phone_database.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<AsyncSnapshot<User?>> get authChanges =>
      _firebaseAuth.userChanges().map(
            (user) => AsyncSnapshot.withData(ConnectionState.active, user),
          );

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      var errorMessage = 'Server error';
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage = 'Account already exists with different credential';
      }
      Fluttertoast.showToast(
          msg: errorMessage, toastLength: Toast.LENGTH_SHORT);
    } on PlatformException {
      Fluttertoast.showToast(
          msg: "User has cancelled or no internet!",
          toastLength: Toast.LENGTH_SHORT);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Server error', toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> updateProfile({
    String? email,
    String? displayName,
    String? photoUrl,
    String? password,
  }) async {
    if (email != null) await currentUser!.updateEmail(email);
    if (displayName != null) await currentUser!.updateDisplayName(displayName);
    if (photoUrl != null) await currentUser!.updatePhotoURL(photoUrl);
    if (password != null) await currentUser!.updatePassword(password);
  }

  Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> removeAccount(BuildContext context) async {
    bool reauthenticated = false;
    bool deleted = false;
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return;
      }
      await FirebaseAuth.instance.currentUser!.delete().then(
            (value) => deleted = true,
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        final provider =
            FirebaseAuth.instance.currentUser?.providerData[0].providerId;

        switch (provider) {
          case 'password':
            {
              if (context.mounted) {
                final userSecurity =
                    await ConfirmAction().reloginWithPassword(context);

                final credential = EmailAuthProvider.credential(
                    email: userSecurity.email, password: userSecurity.password);

                try {
                  await FirebaseAuth.instance.currentUser
                      ?.reauthenticateWithCredential(credential)
                      .then((value) => reauthenticated = true);
                } on FirebaseAuthException {
                  Fluttertoast.showToast(
                      msg: "Passed credential was incorrect",
                      toastLength: Toast.LENGTH_SHORT);
                }
              }
            }
          case 'google':
            {
              final GoogleSignInAccount? googleUser =
                  await GoogleSignIn().signIn();

              if (googleUser == null) return;

              final GoogleSignInAuthentication googleAuth =
                  await googleUser.authentication;

              final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );

              try {
                await FirebaseAuth.instance.currentUser
                    ?.reauthenticateWithCredential(credential)
                    .then((value) => reauthenticated = true);
              } on FirebaseAuthException {
                Fluttertoast.showToast(
                    msg: "Passed credential was incorrect",
                    toastLength: Toast.LENGTH_SHORT);
              }
            }
          // TODO: dodać i przetestować
          case 'apple':
            {}
        }
      }
    } finally {
      if (reauthenticated || deleted) {
        if (reauthenticated) {
          await FirebaseAuth.instance.currentUser!.delete();
        }
        await PhoneDatabase().deleteFromDisk();
        if (context.mounted) {
          context.go('/');
        }
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
