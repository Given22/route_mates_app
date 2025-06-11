import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/src/const.dart';

class GetActiveMembers {
  Future<List<UserLocation>> activeMembersList(String groupId) async {
    String pathToReference = "groups/$groupId";
    DatabaseReference ref = FirebaseDatabase.instance.ref(pathToReference);

    DataSnapshot value = await ref.get();

    final data = value.value as Map?;
    if (data == null) return [];
    List<UserLocation> activeMembers = [];
    data.forEach((key, value) {
      if (key == Auth().currentUser?.uid) return;
      if (value['lo'] == null || value['la'] == null || value['date'] == null) {
        return;
      }
      if (DateTime.fromMillisecondsSinceEpoch(value['date']).isBefore(
        DateTime.now().subtract(
          Duration(minutes: USERS_ARE_NOT_ACTIVE_AFTER_THIS_MINUTES),
        ),
      )) return;
      activeMembers.add(UserLocation(
          lat: value['la'],
          lng: value['lo'],
          id: key,
          lastUpdate: value['date']));
    });
    return activeMembers;
  }

  Stream<List<UserLocation>> activeMembersListStream(String groupId) {
    late StreamController<List<UserLocation>> controller;
    StreamSubscription? addStream;
    StreamSubscription? removeStream;

    List<UserLocation> activeMembers = [];

    void start() {
      addStream = added(groupId).listen((event) {
        activeMembers.add(event);
        controller.add(activeMembers);
      });
      removeStream = removed(groupId).listen((id) {
        activeMembers.removeWhere((element) => element.id == id);
        controller.add(activeMembers);
      });
    }

    void stop() {
      addStream?.cancel();
      addStream = null;
      removeStream?.cancel();
      removeStream = null;
    }

    controller = StreamController<List<UserLocation>>(
      onListen: start,
      onPause: stop,
      onResume: start,
      onCancel: stop,
    );

    return controller.stream;
  }

  Stream<UserLocation> added(String groupId) {
    late StreamController<UserLocation> controller;
    StreamSubscription? stream;

    String pathToReference = "groups/$groupId";
    DatabaseReference ref = FirebaseDatabase.instance.ref(pathToReference);

    void start() {
      stream = ref.onChildAdded.listen((event) {
        final data = event.snapshot.value as Map?;
        final key = event.snapshot.key;

        if (data == null || key == null) return;

        if (key == Auth().currentUser?.uid) return;

        if (data['lo'] == null || data['la'] == null || data['date'] == null) {
          return;
        }

        if (DateTime.fromMillisecondsSinceEpoch(data['date']).isBefore(
          DateTime.now().subtract(
            Duration(minutes: USERS_ARE_NOT_ACTIVE_AFTER_THIS_MINUTES),
          ),
        )) return;

        controller.add(UserLocation(
            lat: data['la'],
            lng: data['lo'],
            id: key,
            lastUpdate: data['date']));
      });
    }

    void stop() {
      stream?.cancel();
      stream = null;
    }

    controller = StreamController<UserLocation>(
      onListen: start,
      onPause: stop,
      onResume: start,
      onCancel: stop,
    );

    return controller.stream;
  }

  Stream<UserLocation> changed(String groupId) {
    late StreamController<UserLocation> controller;
    StreamSubscription? stream;

    String pathToReference = "groups/$groupId";
    DatabaseReference ref = FirebaseDatabase.instance.ref(pathToReference);

    void start() {
      stream = ref.onChildChanged.listen((event) {
        final data = event.snapshot.value as Map?;
        final key = event.snapshot.key;

        if (data == null || key == null) return;

        if (key == Auth().currentUser?.uid) return;

        if (data['lo'] == null && data['la'] == null && data['date'] == null) {
          return;
        }

        if (DateTime.fromMillisecondsSinceEpoch(data['date']).isBefore(
          DateTime.now().subtract(
            Duration(minutes: USERS_ARE_NOT_ACTIVE_AFTER_THIS_MINUTES),
          ),
        )) return;

        controller.add(UserLocation(
            lat: data['la'],
            lng: data['lo'],
            id: key,
            lastUpdate: data['date']));
      });
    }

    void stop() {
      stream?.cancel();
      stream = null;
    }

    controller = StreamController<UserLocation>(
      onListen: start,
      onPause: stop,
      onResume: start,
      onCancel: stop,
    );

    return controller.stream;
  }

  Stream<String> removed(String groupId) {
    late StreamController<String> controller;
    StreamSubscription? stream;

    String pathToReference = "groups/$groupId";
    DatabaseReference ref = FirebaseDatabase.instance.ref(pathToReference);

    void start() {
      stream = ref.onChildRemoved.listen((event) {
        final data = event.snapshot.value as Map?;
        final key = event.snapshot.key;

        if (data == null || key == null) return;

        if (key == Auth().currentUser?.uid) return;

        controller.add(key);
      });
    }

    void stop() {
      stream?.cancel();
      stream = null;
    }

    controller = StreamController<String>(
      onListen: start,
      onPause: stop,
      onResume: start,
      onCancel: stop,
    );

    return controller.stream;
  }
}
