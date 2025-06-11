import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Marker {
  Marker({
    required this.id,
    required this.point,
  });

  String id;
  PointAnnotation point;
}
