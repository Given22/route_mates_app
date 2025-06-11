import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/messaging.dart';

class NotificationTokenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future checkToken() async {
    if (Auth().currentUser == null) return;
    final phoneToken = await _getTokenFromPhone();
    final notificationToken = await MessageService().getToken();

    if (notificationToken == null) return;

    if (phoneToken != notificationToken) {
      if (phoneToken != null) {
        await _removeTokenFromServer(phoneToken);
      }
      await _saveTokenOnServer(notificationToken);
      await _saveTokenOnPhone(notificationToken);
    } else {
      await _updateTimeStampOnServer(notificationToken);
    }
  }

  Future _updateTimeStampOnServer(String token) async {
    DateTime now = DateTime.now();
    int timestampInMilliseconds = now.millisecondsSinceEpoch;

    try {
      await _firestore.collection("notification_tokens").doc(token).update({
        "timestamp": timestampInMilliseconds,
      });
    } on FirebaseException catch (e) {
      if (e.code == "not-found") {
        await _saveTokenOnServer(token);
      }
    }
  }

  Future removeTokenData() async {
    final phoneToken = await _getTokenFromPhone();
    if (phoneToken == null) return;

    await _removeTokenFromServer(phoneToken);
    await _removeTokenFromPhone();
  }

  Future _saveTokenOnServer(String token) async {
    DateTime now = DateTime.now();
    int timestampInMilliseconds = now.millisecondsSinceEpoch;

    await _firestore.collection("notification_tokens").doc(token).set({
      "user_id": Auth().currentUser!.uid,
      "timestamp": timestampInMilliseconds,
      "token": token,
    });
  }

  Future _removeTokenFromServer(String token) async {
    await _firestore.collection("notification_tokens").doc(token).delete();
  }

  Future<bool> _saveTokenOnPhone(String token) async {
    final box = Hive.box('tokens');
    await box.put('notificationToken', token);

    return await box.get('notificationToken') == token;
  }

  Future<bool> _removeTokenFromPhone() async {
    final box = Hive.box('tokens');
    await box.delete("notificationToken");

    return await box.get('notificationToken') == null;
  }

  Future<String?> _getTokenFromPhone() async {
    final box = await Hive.openBox('tokens');
    String? notificationToken = box.get('notificationToken');

    return notificationToken;
  }
}
