import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:route_mates/data/friendships.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/data/requests.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/auth.dart';

class Store {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserStore?> get user async {
    if (Auth().currentUser == null) return null;
    try {
      final res = await firestore
          .collection('users')
          .doc(Auth().currentUser!.uid)
          .get();

      if (res.data() == null) return null;

      return UserStore.fromFirestore(res);
    } catch (e) {
      return null;
    }
  }

  Future<UserStore?> getUser(String userId) async {
    final res = await firestore.collection('users').doc(userId).get();

    if (res.data() == null) return null;

    return UserStore.fromFirestore(res);
  }

  Future<Vehicle> getVehicle(String userId, String vehicleId) async {
    final res = await firestore
        .collection('users')
        .doc(userId)
        .collection('garage')
        .doc(vehicleId)
        .get();

    return Vehicle.fromFirestore(res);
  }

  /// Stream data about our user
  Stream<AsyncSnapshot<UserStore?>> get userStream {
    if (Auth().currentUser == null) {
      return const Stream.empty();
    }
    return firestore
        .collection('users')
        .doc(Auth().currentUser!.uid)
        .snapshots()
        .map(
          (DocumentSnapshot event) => AsyncSnapshot.withData(
            ConnectionState.active,
            UserStore.fromFirestore(event),
          ),
        );
  }

  /// Stream data about our group
  Stream<AsyncSnapshot<Group?>> groupStream(String groupId) =>
      firestore.collection('groups').doc(groupId).snapshots().map(
            (DocumentSnapshot event) => AsyncSnapshot.withData(
              ConnectionState.active,
              Group.fromFirebase(event),
            ),
          );

  /// Stream data about our group
  Stream<Group?> groupDataStream(String groupId) => firestore
      .collection('groups')
      .doc(groupId)
      .snapshots()
      .map((DocumentSnapshot event) => Group.fromFirebase(event));

  /// Stream data about got friendship requests
  Stream<List<GotRequest>> get gotFriendshipsRequestsStream {
    if (Auth().currentUser == null) {
      return const Stream.empty();
    }
    return firestore
        .collection('users')
        .doc(Auth().currentUser!.uid)
        .collection('got requests')
        .snapshots()
        .map((event) {
      return event.docs.map((doc) => GotRequest.fromFirestore(doc)).toList();
    });
  }

  /// Stream data about send friendship requests
  Stream<List<SendRequest>> get sendFriendshipsRequestsStream {
    if (Auth().currentUser == null) {
      return const Stream.empty();
    }
    return firestore
        .collection('users')
        .doc(Auth().currentUser!.uid)
        .collection('send requests')
        .snapshots()
        .map((event) {
      return event.docs.map((doc) => SendRequest.fromFirestore(doc)).toList();
    });
  }

  /// Stream data about user garage
  Stream<List<Vehicle>> get garageStream {
    if (Auth().currentUser == null) {
      return const Stream.empty();
    }
    return firestore
        .collection('users')
        .doc(Auth().currentUser!.uid)
        .collection('garage')
        .snapshots()
        .map((event) {
      return event.docs.map((doc) => Vehicle.fromQueryFirestore(doc)).toList();
    });
  }

  /// Future data about user garage
  Future<List<Vehicle>> userGarageFuture(String userId) async {
    if (Auth().currentUser == null) {
      return Future.value([]);
    }
    var future = await firestore
        .collection('users')
        .doc(userId)
        .collection('garage')
        .get();
    return future.docs.map((doc) => Vehicle.fromQueryFirestore(doc)).toList();
  }

  /// Stream data about user friends
  Stream<List<Friend>> get friendsStream {
    if (Auth().currentUser == null) {
      return const Stream.empty();
    }
    return firestore
        .collection('users')
        .doc(Auth().currentUser!.uid)
        .collection('friends')
        .snapshots()
        .map((event) {
      return event.docs.map((doc) => Friend.fromFirestore(doc)).toList();
    });
  }

  /// Future data about users friends
  Future<List<Friend>> userFriendsFuture(String userId) async {
    if (Auth().currentUser == null) {
      return Future.value([]);
    }
    var future = await firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .get();
    return future.docs.map((doc) => Friend.fromFirestore(doc)).toList();
  }

  /// Stream data about group members
  Stream<List<Member>> groupMembersStream(String groupId) => firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .snapshots()
          .map((event) {
        return event.docs.map((doc) => Member.fromFirestore(doc)).toList();
      });

  /// Stream data about send friendship requests
  Stream<List<SendGroupInvitation>> groupSendInvitationsStream(
          String groupId) =>
      firestore
          .collection('groups')
          .doc(groupId)
          .collection('send requests')
          .snapshots()
          .map((event) {
        return event.docs
            .map((doc) => SendGroupInvitation.fromFirestore(doc))
            .toList();
      });

  Future<bool> groupNameAlreadyExists(String name) async {
    AggregateQuerySnapshot snap = await firestore
        .collection("groups")
        .where("name", isEqualTo: name)
        .count()
        .get();
    return (snap.count ?? 0) > 0;
  }

  Future<bool> nameAlreadyExists(String name) async {
    AggregateQuerySnapshot snap = await firestore
        .collection("users")
        .where("displayName", isEqualTo: name)
        .count()
        .get();
    return (snap.count ?? 0) > 0;
  }

  Future<void> createNewUserRecord({
    required String displayName,
  }) async {
    await firestore.collection('users').doc(Auth().currentUser!.uid).set({
      'displayName': displayName,
      'group': {},
      'activeVehicle': "",
    });
  }

  Future<void> updateUserName({
    required String displayName,
  }) async {
    await firestore.collection('users').doc(Auth().currentUser!.uid).update({
      'displayName': displayName,
    });
  }

  Future<void> updateActiveVehicle({
    required String vehicleId,
  }) async {
    await firestore.collection('users').doc(Auth().currentUser!.uid).update({
      'activeVehicle': vehicleId,
    });
  }

  Future<void> updateGroupName({
    required String name,
    required String groupId,
  }) async {
    await firestore.collection('groups').doc(groupId).update({
      'name': name,
    });
  }

  Future<void> updateGroupLocation({
    required String location,
    required String groupId,
  }) async {
    await firestore.collection('groups').doc(groupId).update({
      'location': location,
    });
  }

  Future<void> updateGroupPublic({
    required bool newPublic,
    required String groupId,
  }) async {
    await firestore.collection('groups').doc(groupId).update({
      'public': newPublic,
    });
  }

  Future<void> updateNotificationToken({
    required String uid,
    required String notificationToken,
  }) async {
    await firestore.collection('users').doc(uid).update({
      'notificationToken': notificationToken,
    });
  }
}
