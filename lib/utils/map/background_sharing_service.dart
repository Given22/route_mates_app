import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:background_location/background_location.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:route_mates/fire/firestore.dart';
import 'dart:async';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:route_mates/firebase_options.dart';
import 'package:route_mates/src/const.dart';
import 'package:permission_handler/permission_handler.dart';

class BackgroundSharingService extends ChangeNotifier {
  BackgroundSharingService() {
    init();
  }

  final FlutterBackgroundService service = FlutterBackgroundService();

  bool isRunning = false;
  bool isSharing = false;

  final notificationChannelId = 'my_foreground';
  final notificationId = 888;

  init() async {
    isRunning = await service.isRunning();
    isSharing = isRunning;
    notifyListeners();
  }

  Future<bool> get isServiceAlreadyRunning async {
    isRunning = await service.isRunning();
    notifyListeners();
    return isRunning;
  }

  removeLocation() async {
    // if background service not properly removed location, remove it on app startup
    final user = await Store().user;
    if (user != null && user.group.uid.isNotEmpty) {
      String pathToReference = "groups/${user.group.uid}/${user.uid}";
      DatabaseReference ref = FirebaseDatabase.instance.ref(pathToReference);

      ref.get().then((value) async {
        if (value.value != null) {
          try {
            await value.ref.remove();
          } catch (e) {
            throw 'failed to remove';
          }
        }
      });
    }
  }

  _listenServiceCallbacks() {
    service.on('running').listen((event) {
      if (event == null) return;
      if (event['state'] is bool) {
        isRunning = event['state'];
        notifyListeners();
      }
    });
    service.on('sharing').listen((event) {
      if (event == null) return;
      if (event['state'] is bool) {
        isSharing = event['state'];
        notifyListeners();
      }
    });
  }

  stop() {
    service.invoke('stopService');
    isRunning = false;
    isSharing = false;
    notifyListeners();
  }

  Future<void> runSharingService() async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId,
      'SharingService',
      description:
          'This channel is used for notification about sharing location service. Only for information purposes, you can disable it.',
      importance: Importance.none,
      showBadge: false,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        autoStartOnBoot: false,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId,
        initialNotificationTitle: 'Sharing engine',
        initialNotificationContent: 'Running..',
        foregroundServiceNotificationId: notificationId,
      ),
    );
    isRunning = true;
    notifyListeners();
    _listenServiceCallbacks();
  }

  @pragma('vm:entry-point')
  static FutureOr<bool> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    bool isRunning = false;
    bool isSharing = false;

    try {
      showToast(String msg) {
        Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: grey,
          textColor: darkBg,
          fontSize: 14.0,
        );
      }

      update({bool? sharing, bool? running}) {
        if (sharing != null) isSharing = sharing;
        if (running != null) isRunning = running;

        service.invoke('sharing', {
          'state': isSharing,
        });

        service.invoke('running', {
          'state': isRunning,
        });
      }

      Future removeUserLocationFromDB(String? groupID) async {
        final user = await Store().user;

        if (user != null && (groupID != null || user.group.uid.isNotEmpty)) {
          String pathToReference =
              "groups/${groupID ?? user.group.uid}/${user.uid}";
          DatabaseReference ref =
              FirebaseDatabase.instance.ref(pathToReference);

          try {
            await ref.remove();
          } catch (e) {
            throw 'failed to remove';
          }
        }
      }

      Future stopService() async {
        update(sharing: false, running: false);
        try {
          await BackgroundLocation.stopLocationService();
          // ignore: empty_catches
        } on MissingPluginException {}

        try {
          await removeUserLocationFromDB(null);
        } catch (e) {
          Fluttertoast.showToast(
            msg: "We had problem with removing your location, please try again",
          );
        }

        await service.stopSelf();
      }

      Future<bool> checkPermissions() async {
        ServiceStatus servicePermission;
        PermissionStatus permission;

        servicePermission = await Permission.locationWhenInUse.serviceStatus;
        if (servicePermission.isDisabled || servicePermission.isNotApplicable) {
          showToast("Location service not available");
          return false;
        }

        permission = await Permission.locationWhenInUse.status;
        if (permission == PermissionStatus.denied) {
          showToast("Location permission is danied");
          return false;
        }

        if (permission == PermissionStatus.permanentlyDenied) {
          showToast("Location permission is danied permanently");
          return false;
        }

        return true;
      }

      startListeningServiceCallbacks() {
        service.on('stopService').listen((event) async {
          await stopService();
        });
      }

      if (!await checkPermissions()) {
        update(sharing: false, running: false);
        service.stopSelf();
        return true;
      }

      // init firebase in isolate
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      startListenLocationChanges(String path) async {
        DatabaseReference ref = FirebaseDatabase.instance.ref(path);

        BackgroundLocation.setAndroidNotification(
          title: "Live",
          message: "You are sharing your location with group",
          icon: "@mipmap/ic_launcher",
        );

        BackgroundLocation.setAndroidConfiguration(1000);

        BackgroundLocation.getLocationUpdates((position) async {
          try {
            await ref.set({
              "la": position.latitude,
              "lo": position.longitude,
              "date": DateTime.now().millisecondsSinceEpoch,
            });
          } catch (e) {
            update(sharing: false);
          }
        });

        await BackgroundLocation.startLocationService(distanceFilter: 10);
        update(sharing: true);
      }

      Future<void> shareLocation() async {
        final user = await Store().user;

        if (user == null) {
          showToast("We cannot find your profile");
          stopService();
          return;
        }

        String userId = user.uid;
        String groupId = user.group.uid;

        if (user.group.uid.isEmpty) {
          Fluttertoast.showToast(
              msg: "You are not into any group",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: grey2,
              textColor: darkBg,
              fontSize: 14.0);
          await stopService();
          return;
        }

        if (userId.isNotEmpty && groupId.isNotEmpty) {
          String pathToReference = "groups/$groupId/$userId";

          startListenLocationChanges(pathToReference);
        }

        Store().userStream.listen(
          (user) async {
            if (user.hasData && user.data != null) {
              if (user.data!.group.uid.isNotEmpty) {
                if (groupId != user.data!.group.uid) {
                  await BackgroundLocation.stopLocationService();

                  if (user.data != null) {
                    groupId = user.data!.group.uid;
                    String pathToReference = "groups/$groupId/$userId";
                    startListenLocationChanges(pathToReference);
                  }
                }
              } else {
                await removeUserLocationFromDB(groupId);
                await stopService();
              }
            }
          },
        );
      }

      startListeningServiceCallbacks();

      shareLocation();
    } catch (e) {
      await service.stopSelf();
    }

    return true;
  }
}
