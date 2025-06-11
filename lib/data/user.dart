import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  Vehicle({
    this.description,
    this.shortDescription,
    required this.name,
    required this.uid,
  });

  final String name;
  final String uid;
  final String? shortDescription;
  final String? description;

  factory Vehicle.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Vehicle(
      uid: doc.id,
      name: data['name'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      description: data['description'] ?? '',
    );
  }

  factory Vehicle.fromQueryFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Vehicle(
      uid: doc.id,
      name: data['name'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      description: data['description'] ?? '',
    );
  }
}

class UserGroup {
  UserGroup({
    required this.name,
    required this.uid,
  });

  final String name;
  final String uid;

  factory UserGroup.fromMap(Map data) {
    return UserGroup(name: data['name'] ?? '', uid: data['uid'] ?? '');
  }
}

class UserStore {
  UserStore({
    required this.displayName,
    required this.group,
    required this.notificationToken,
    required this.uid,
    required this.activeVehicle,
  });

  final String displayName;
  final UserGroup group;
  final String notificationToken;
  final String uid;
  final String activeVehicle;

  factory UserStore.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserStore(
      displayName: data['displayName'] ?? '',
      group: UserGroup.fromMap(data['group'] ?? {}),
      notificationToken: data['notificationToken'] ?? '',
      uid: doc.id,
      activeVehicle: data['activeVehicle'] ?? '',
    );
  }

  factory UserStore.fromQueryFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserStore(
      displayName: data['displayName'] ?? '',
      group: UserGroup.fromMap(data['group'] ?? {}),
      notificationToken: data['notificationToken'] ?? '',
      uid: doc.id,
      activeVehicle: data['activeVehicle'] ?? '',
    );
  }
}

class UserLocation {
  UserLocation({
    required this.lat,
    required this.lng,
    required this.id,
    required this.lastUpdate,
  });

  final double lat;
  final double lng;
  final String id;
  final int lastUpdate;
}

class UserSecurity {
  UserSecurity({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class MyPosition {
  MyPosition({
    this.bearing,
    required this.lng,
    required this.lat,
  });

  final double? bearing;
  final double lng;
  final double lat;
}
