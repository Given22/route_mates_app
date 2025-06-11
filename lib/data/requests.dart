import 'package:cloud_firestore/cloud_firestore.dart';

class GotRequest {
  GotRequest({
    required this.date,
    required this.userName,
    required this.userUid,
    required this.type,
    this.groupName,
    this.groupUid,
  });

  final Timestamp date;
  final String userName;
  final String userUid;
  final String type;
  final String? groupName;
  final String? groupUid;

  factory GotRequest.fromFirestore(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    var group = data['group'] as Map<String, dynamic>?;
    var user = data['user'] as Map<String, dynamic>?;
    if (data['type'] == 'group') {
      return GotRequest(
        date: data['date'],
        type: data['type'],
        groupUid: group != null ? group['uid'] ?? '' : '',
        groupName: group != null ? group['name'] ?? '' : '',
        userUid: user != null ? user['uid'] ?? '' : '',
        userName: user != null ? user['name'] ?? '' : '',
      );
    }
    return GotRequest(
      date: data['date'],
      userUid: user != null ? user['uid'] ?? '' : '',
      userName: user != null ? user['name'] ?? '' : '',
      type: data['type'],
    );
  }

  factory GotRequest.fromFirestoreFriendship(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    var uid = doc.id;
    return GotRequest(
      date: data['date'],
      userName: data['name'],
      userUid: uid,
      type: 'friendship',
    );
  }
  factory GotRequest.fromFirestoreGroup(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    var uid = doc.id;
    return GotRequest(
      date: data['date'],
      type: 'group',
      groupUid: uid,
      groupName: data['groupName'],
      userName: data['name'],
      userUid: data['userUid'],
    );
  }
}

class SendRequest {
  SendRequest({
    required this.send,
    required this.uid,
  });

  final bool send;
  final String uid;

  factory SendRequest.fromFirestore(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    var uid = doc.id;
    return SendRequest(send: data['send'], uid: uid);
  }
}

class SendGroupInvitation {
  SendGroupInvitation({
    required this.send,
    required this.uid,
  });

  final bool send;
  final String uid;

  factory SendGroupInvitation.fromFirestore(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    var uid = doc.id;
    return SendGroupInvitation(send: data['send'], uid: uid);
  }
}

class FriendshipsRequests {
  FriendshipsRequests({
    required this.send,
    required this.got,
  });

  final Map<String, dynamic> send;
  final Map<String, dynamic> got;

  factory FriendshipsRequests.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return FriendshipsRequests(
      send: data['send'] ?? {},
      got: data['got'] ?? {},
    );
  }
}
