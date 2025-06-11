import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:route_mates/data/marker.dart';
import 'package:route_mates/utils/map/control_map_service.dart';
import 'package:route_mates/utils/pictures_service.dart';
import 'package:route_mates/utils/profile/someone_profile_preview.dart';

class AnnotationClickListener extends OnPointAnnotationClickListener {
  AnnotationClickListener({
    required this.context,
    this.mapService,
  });

  final BuildContext context;
  ControlMapService? mapService;

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    final coordinates =
        jsonDecode(annotation.geometry!['coordinates'].toString()) as List;

    final lng = coordinates[0];
    final lat = coordinates[1];
    mapService?.goToUserLocation(Position(lng, lat), context);
    SomeoneProfile().showDialogPreview(annotation.textField!, context);
  }
}

class DrawMarkersService {
  DrawMarkersService({
    required this.manager,
    required this.context,
    required this.mapService,
  }) {
    manager.addOnPointAnnotationClickListener(
        AnnotationClickListener(context: context, mapService: mapService));
  }

  Map<String, int> markerSize = {
    "width": 150,
    "height": 165,
  };

  List<Marker> markers = [];
  PointAnnotationManager manager;
  ControlMapService mapService;
  BuildContext context;

  bool _darkMode = true;

  final double scale = 0.5;

  Future<void> setDarkMode(bool darkMode) async {
    _darkMode = darkMode;

    for (Marker marker in markers) {
      marker.point.image = await Pictures().getMarkerIntList(
        marker.id,
        _darkMode,
        markerSize["width"]!,
        markerSize["height"]!,
      );
      try {
        await manager.update(marker.point);
        // ignore: empty_catches
      } on PlatformException {}
    }
  }

  drawNewMarker(String id, Position position) async {
    final m = markers.where((element) => element.id == id);
    if (m.isNotEmpty) {
      return;
    }

    final Uint8List list = await Pictures().getMarkerIntList(
      id,
      _darkMode,
      markerSize["width"]!,
      markerSize["height"]!,
    );

    try {
      final point = await manager.create(PointAnnotationOptions(
        geometry: Point(coordinates: position).toJson(),
        textField: id,
        textColor: 0x00, // transparent text, placeholder for onClick fun
        iconAnchor: IconAnchor.BOTTOM,
        image: list,
      ));
      markers = [
        ...markers.where((element) => element.id != id),
        Marker(id: id, point: point)
      ];
    } on PlatformException {
      return;
    }

    return;
  }

  updateMarker(String id, Position position) async {
    int index = markers.indexWhere((element) => element.id == id);
    if (index == -1) {
      // drawNewMarker(id, position);
      return;
    }

    markers[index].point.geometry = Point(coordinates: position).toJson();

    await manager.update(markers[index].point);
  }

  removeMarker(String id) async {
    List<Marker> m = markers.where((element) => element.id == id).toList();

    if (m.isEmpty) return;

    final marker = m.first;

    await manager.delete(marker.point);
    markers = markers.where((element) => element.id != id).toList();
  }

  void clear() async {
    for (Marker marker in markers) {
      await manager.delete(marker.point);
    }
    markers.clear();
  }
}
