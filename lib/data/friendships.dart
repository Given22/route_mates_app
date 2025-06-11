import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  Friend({
    required this.name,
    required this.uid,
  });

  final String name;
  final String uid;

  factory Friend.fromFirestore(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return Friend(name: data['name'], uid: doc.id);
  }
}
