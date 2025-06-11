import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationToken {
  NotificationToken({
    required this.timestamp,
    required this.token,
    required this.userId,
  });

  final String token;
  final int timestamp;
  final String userId;

  factory NotificationToken.fromQueryFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return NotificationToken(
      token: data["token"] ?? "",
      timestamp: data["timestamp"] ?? 0,
      userId: data["user_id"] ?? "",
    );
  }

  factory NotificationToken.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return NotificationToken(
      token: data["token"] ?? "",
      timestamp: data["timestamp"] ?? 0,
      userId: data["user_id"] ?? "",
    );
  }
}

class MessageData {
  MessageData({
    required this.type,
    required this.who,
    this.whoName,
    this.alertTag,
  });
  final String type;
  final String who;
  final String? whoName;
  final String? alertTag;
}

class MessageNotification {
  MessageNotification({
    required this.title,
    required this.body,
  });
  final String title;
  final String body;
}

class Message {
  Message({
    required this.data,
    required this.message,
  });
  final MessageData data;
  final MessageNotification? message;

  factory Message.fromRemoteMessage(RemoteMessage remoteMessage) {
    return Message(
      data: MessageData(
        type: remoteMessage.data["type"] ?? "",
        who: remoteMessage.data["who"] ?? "",
        alertTag: remoteMessage.data["alertTag"],
        whoName: remoteMessage.data["whoName"],
      ),
      message: remoteMessage.notification != null
          ? MessageNotification(
              title: remoteMessage.notification?.title ?? "",
              body: remoteMessage.notification?.body ?? "",
            )
          : null,
    );
  }
  factory Message.fake() {
    return Message(
      data: MessageData(
        type: "alert",
        who: "qwegrug12bj2315",
        alertTag: "police",
        whoName: "Test_Name",
      ),
      message: MessageNotification(
        title: "test title",
        body: "test long body with message about alert",
      ),
    );
  }
}
