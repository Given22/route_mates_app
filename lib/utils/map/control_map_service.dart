import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/functions/geolocation.dart';
import 'package:route_mates/lib_extensions/mapbox.dart';
import 'package:route_mates/utils/view.dart';
import 'package:geolocator/geolocator.dart' as geo;

class ControlMapService extends ChangeNotifier {
  final darkmodeMapUrl = Config().getString("darkmode_map_url");
  final lightmodeMapUrl = Config().getString("lightmode_map_url");

  Timer? followLocation;
  MapboxMap? map;

  bool darkMode = true;
  bool north = true;
  bool birdMode = true;

  bool follow = false;
  bool driveMode = false;

  set setMap(MapboxMap newMap) => map = newMap;
  set setDriveMode(bool mode) {
    driveMode = mode;
    notifyListeners();
  }

  Future<CameraState>? get cameraState => map?.getCameraState();

  FlutterView view = PlatformDispatcher.instance.views.first;

  stopFollowUser() {
    followLocation?.cancel();
    followLocation = null;
  }

  Future initDefaultSettings(MapboxMap newMap) async {
    map = newMap;
    notifyListeners();

    try {
      await map?.location.updateSettings(LocationComponentSettings(
        enabled: true,
      ));

      await map?.compass.updateSettings(CompassSettings(enabled: false));
      await map?.attribution.updateSettings(AttributionSettings(
          iconColor: 30, position: OrnamentPosition.TOP_LEFT));
      await map?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
      await map?.logo
          .updateSettings(LogoSettings(position: OrnamentPosition.TOP_LEFT));

      await map?.setCamera(CameraOptions(zoom: 15));

      await map?.setBounds(CameraBoundsOptions(
        minZoom: 5,
        maxZoom: 18,
        maxPitch: 50,
      ));

      // ignore: empty_catches
    } on PlatformException {}
  }

  @override
  dispose() {
    stopFollowUser();
    super.dispose();
  }

  setPulsitng(bool pulsing) async {
    try {
      await map?.location.updateSettings(LocationComponentSettings(
        pulsingEnabled: pulsing,
      ));
      // ignore: empty_catches
    } on PlatformException {}
  }

  changeCompassMode(bool? mode) async {
    north = mode ?? !north;
    notifyListeners();

    try {
      await map?.flyTo(
        CameraOptions(
          bearing: north ? 0 : null,
        ),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
      // ignore: empty_catches
    } on PlatformException {}
  }

  changeFollowingMode(bool? mode) {
    follow = mode ?? !follow;
    notifyListeners();

    if (follow) {
      followUserLocation();
      goToUserLocation(null, null);
    } else {
      stopFollowUser();
    }
  }

  changeBirdMode(bool? mode) async {
    birdMode = mode ?? !birdMode;
    notifyListeners();

    double screenHeight = view.physicalSize.height / view.devicePixelRatio;

    try {
      await map?.flyTo(
        CameraOptions(
          padding: MbxEdgeInsets(
            top: birdMode ? 0 : (screenHeight / 2.5),
            left: 0,
            bottom: 0,
            right: 0,
          ),
          zoom: birdMode ? 15.0 : 16.0,
          pitch: birdMode ? 0 : 45,
        ),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );

      // ignore: empty_catches
    } on PlatformException {}
  }

  changeMapStyle(bool? mode) async {
    darkMode = mode ?? !darkMode;
    notifyListeners();

    try {
      await map?.loadStyleURI(
        darkMode ? darkmodeMapUrl : lightmodeMapUrl,
      );
      await map?.reduceMemoryUse();
      // ignore: empty_catches
    } on PlatformException {}
  }

  followUserLocation() async {
    double screenHeight = view.physicalSize.height / view.devicePixelRatio;

    if (followLocation != null) {
      stopFollowUser();
    }

    followLocation =
        Timer.periodic(const Duration(milliseconds: 900), (Timer timer) async {
      if (map == null) {
        return;
      }
      try {
        final position = await map!.style.getPuckPosition();
        if (position == null) {
          return;
        }

        await map?.flyTo(
          CameraOptions(
            center: Point(
              coordinates: Position(
                position.lng,
                position.lat,
              ),
            ).toJson(),
            padding: MbxEdgeInsets(
              top: birdMode ? 0 : (screenHeight / 2.5),
              left: 0,
              bottom: 0,
              right: 0,
            ),
            pitch: birdMode ? 0 : 45,
            zoom: birdMode ? null : 15.5,
            bearing: !birdMode
                ? position.bearing
                : north
                    ? 0
                    : null,
          ),
          MapAnimationOptions(duration: 900, startDelay: 0),
        );
        // ignore: empty_catches
      } on PlatformException {}
    });
  }

  Future<void> goToUserLocation(
      Position? position, BuildContext? context) async {
    if (position != null) {
      changeFollowingMode(false);
      stopFollowUser();

      try {
        await map?.flyTo(
          CameraOptions(
            center: Point(
              coordinates: Position(
                position.lng,
                position.lat,
              ),
            ).toJson(),
            padding: MbxEdgeInsets(
              top: ViewOrientation().getTopPadding(context!),
              right: 0,
              bottom: 0,
              left: ViewOrientation().getLeftPadding(context),
            ),
          ),
          MapAnimationOptions(duration: 2000, startDelay: 0),
        );
        // ignore: empty_catches
      } on PlatformException {}
      return;
    }
    try {
      final position = await map!.style.getPuckPosition();
      if (position == null) {
        await locationPermision().then((granted) async {
          if (granted) {
            geo.Position position =
                await geo.Geolocator.getLastKnownPosition() ??
                    await geo.Geolocator.getCurrentPosition();
            await map?.flyTo(
              CameraOptions(
                center: Point(
                  coordinates: Position(
                    position.longitude,
                    position.latitude,
                  ),
                ).toJson(),
              ),
              MapAnimationOptions(duration: 2000, startDelay: 0),
            );
          }
        });
        return;
      }
      await map?.flyTo(
        CameraOptions(
          center: Point(
            coordinates: Position(
              position.lng,
              position.lat,
            ),
          ).toJson(),
        ),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
      // ignore: empty_catches
    } on PlatformException {}
  }
}
