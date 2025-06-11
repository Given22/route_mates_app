import 'dart:io';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:route_mates/data/user.dart';

extension PuckPosition on StyleManager {
  Future<MyPosition?> getPuckPosition() async {
    Layer? layer;
    if (Platform.isAndroid) {
      layer = await getLayer("mapbox-location-indicator-layer");
    } else {
      layer = await getLayer("puck");
    }
    final location = (layer as LocationIndicatorLayer).location;
    return Future.value(location != null
        ? MyPosition(
            bearing: layer.bearing, lng: location[1]!, lat: location[0]!)
        : null);
  }
}
