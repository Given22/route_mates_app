import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/data/notifications.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/src/components/alert_box.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/utils/phone_database.dart';

class MessageService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  init() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      listenForegroundMessage();

      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    }
  }

  StreamSubscription listenAlertMessage(BuildContext context) {
    return FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.data["who"] == Auth().currentUser?.uid) return;
      if (message.data["type"] == "alert" &&
          message.data.containsKey("alertTag")) {
        openDialog(context, message);
      }
    });
  }

  void openDialog(BuildContext context, RemoteMessage message) async {
    Timer timer =
        Timer(Duration(seconds: HOW_LONG_ALERT_SHOULD_BE_VISIBLE_IN_SEC), () {
      context.pop();
    });
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) => AlertBox(
        notification: Message.fromRemoteMessage(message),
      ),
    ).then((value) {
      timer.cancel();
    });
  }

  Future<String?> getToken() async {
    return messaging.getToken();
  }

  listenForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.data["who"] == Auth().currentUser?.uid ||
          message.data["type"] == "alert") return;

      if (message.data["type"] == "friend" || message.data["type"] == "group") {
        PhoneDatabase().increaseNumber("main", "notifications_amount");
      }
    });
  }

  RemoteMessage get testMessage => const RemoteMessage(
        data: {"alertTag": "police", "whoName": "test"},
        notification: RemoteNotification(
          title: "test",
          body: "test",
        ),
      );
}

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data["who"] == Auth().currentUser?.uid ||
      message.data["type"] == "alert") return;

  if (message.data["type"] == "friend" || message.data["type"] == "group") {
    PhoneDatabase().increaseNumber("main", "notifications_amount");
  }
}
