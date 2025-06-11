import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  Group({
    this.key,
    this.location,
    required this.master,
    required this.name,
    required this.public,
    required this.uid,
  });

  final String? key;
  final String? location;
  final String master;
  final String name;
  final bool public;
  final String uid;

  factory Group.fromFirebase(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Group(
      key: data['key'],
      location: data['location'],
      master: data['master'] ?? '',
      name: data['name'] ?? '',
      public: data['public'] ?? '',
      uid: doc.id,
    );
  }
}

class Member {
  Member({
    required this.name,
    required this.uid,
  });

  final String name;
  final String uid;

  factory Member.fromFirestore(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return Member(name: data['name'], uid: doc.id);
  }
}
