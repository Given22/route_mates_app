import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/functions/geolocation.dart';
import 'package:route_mates/src/components/map/alert_panel/alert_button.dart';
import 'package:route_mates/utils/map/background_sharing_service.dart';
import 'package:route_mates/utils/map/control_map_service.dart';
import 'package:route_mates/utils/map/draw_markers_service.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/screens/loading_page.dart';
import 'package:route_mates/utils/get_active_members.dart';
import 'package:route_mates/utils/env_config.dart';

class FullMap extends StatefulWidget {
  const FullMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> with WidgetsBindingObserver {
  final service = FlutterBackgroundService();

  late ControlMapService mapService;

  DrawMarkersService? drawMarkersServices;

  StreamSubscription? onAddSub;
  StreamSubscription? onChangeSub;
  StreamSubscription? onRemoveSub;

  bool isScrolling = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    onAddSub?.cancel();
    onChangeSub?.cancel();
    onRemoveSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      mapService.map?.triggerRepaint();
      setState(() {});
    }
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    await mapService.initDefaultSettings(mapboxMap);

    try {
      final manager =
          await mapService.map!.annotations.createPointAnnotationManager();

      await manager.setIconAllowOverlap(false);
      await manager.setIconIgnorePlacement(false);
      await manager.setTextOptional(false);
      await manager.setTextAllowOverlap(false);
      await manager.setTextIgnorePlacement(false);

      if (mounted) {
        drawMarkersServices = DrawMarkersService(
          manager: manager,
          context: context,
          mapService: mapService,
        );

        if (drawMarkersServices != null) {
          final user = await Store().user;

          if (user != null) {
            String groupId = user.group.uid;
            if (groupId.isNotEmpty) {
              _listenMembers(groupId);
            }
          }
        }
      }

      await locationPermision().then((granted) {
        if (granted) mapService.goToUserLocation(null, null);
      });

      _listenSharingChanges();
      // ignore: empty_catches
    } on MissingPluginException {
      // ignore: empty_catches
    } on PlatformException {}
  }

  _onMapScroll(ScreenCoordinate position) async {
    if (mapService.north) {
      CameraState camera = await mapService.cameraState!;

      if (camera.bearing != 0.0) {
        _changeCompassMode(false);
      }
    }

    if (isScrolling) {
      _changeFollowingMode(false);

      mapService.stopFollowUser();

      isScrolling = false;
      Timer(const Duration(seconds: 3), () {
        isScrolling = true;
      });
    }
  }

  _listenSharingChanges() async {
    if (mounted) {
      var bgService =
          Provider.of<BackgroundSharingService>(context, listen: false);

      bool sharing = bgService.isSharing;
      if (sharing) {
        mapService.setPulsitng(true);
      }
      mapService.setPulsitng(false);

      service.on('sharing').listen((event) {
        if (event == null) return;
        if (event['state'] is bool) {
          mapService.setPulsitng(event['state']);
        }
      });
    }
  }

  _listenMembers(String groupId) {
    onAddSub = GetActiveMembers().added(groupId).listen((user) async {
      drawMarkersServices?.drawNewMarker(
        user.id,
        Position(
          user.lng,
          user.lat,
        ),
      );
      return;
    });

    onChangeSub = GetActiveMembers().changed(groupId).listen(
      (user) async {
        drawMarkersServices?.updateMarker(
          user.id,
          Position(
            user.lng,
            user.lat,
          ),
        );
        return;
      },
    );

    onRemoveSub = GetActiveMembers().removed(groupId).listen((uid) async {
      drawMarkersServices?.removeMarker(
        uid,
      );
      return;
    });
  }

  _changeCompassMode(bool? mode) {
    mapService.changeCompassMode(mode);
  }

  _changeFollowingMode(bool? mode) {
    mapService.changeFollowingMode(mode);
  }

  _changeBirdMode(bool? mode) {
    mapService.changeBirdMode(mode);
  }

  _changeMapStyle(bool? mode) {
    mapService.changeMapStyle(mode);
    drawMarkersServices?.setDarkMode(mapService.darkMode);
  }

  @override
  Widget build(BuildContext context) {
    mapService = context.watch<ControlMapService>();

    String? accessToken = EnvConfig.mapboxAccessToken;

    if (accessToken == null) {
      return const LoadingPage();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        MapWidget(
          resourceOptions: ResourceOptions(accessToken: accessToken),
          onMapCreated: _onMapCreated,
          textureView: true,
          styleUri: Config().getString("darkmode_map_url"),
          cameraOptions: CameraOptions(),
          onScrollListener: _onMapScroll,
          onTapListener: (ScreenCoordinate coordinate) async {
            // if (mapService.map == null) return;

            // final ScreenCoordinate conv =
            //     await mapService.map!.pixelForCoordinate(
            //   Point(
            //     coordinates: Position(
            //       coordinate.y,
            //       coordinate.x,
            //     ),
            //   ).toJson(),
            // );

            // final List<QueriedFeature?> features =
            //     await mapService.map!.queryRenderedFeatures(
            //   RenderedQueryGeometry(
            //     value: jsonEncode(conv.encode()),
            //     type: Type.SCREEN_COORDINATE,
            //   ),
            //   RenderedQueryOptions(
            //     layerIds: [
            //       'poi-label-main',
            //       'poi-label-alt',
            //       'speed-cameras',
            //       'poi-label copy 4'
            //     ],
            //   ),
            // );

            // for (var feature in features) {
            //   print(feature?.encode());
            // }
          },
        ),
        const Positioned(
          left: 16,
          bottom: 48,
          child: AlertGroupButton(),
        ),
        Positioned(
          right: 16,
          bottom: 48,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if ((mapService.driveMode &&
                      !mapService.follow &&
                      !mapService.north) ||
                  (!mapService.driveMode && !mapService.north)) ...[
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: darkGrey3,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: IconButton(
                    color: grey,
                    onPressed: () => _changeCompassMode(null),
                    icon: mapService.north
                        ? const Icon(
                            Icons.explore_rounded,
                          )
                        : const Icon(
                            Icons.explore_off_rounded,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
              if (!mapService.follow) ...[
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: darkGrey3,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: IconButton(
                    color: grey,
                    onPressed: () => _changeFollowingMode(null),
                    icon: mapService.follow
                        ? const Icon(
                            Icons.gps_fixed_outlined,
                          )
                        : const Icon(
                            Icons.location_searching_outlined,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                )
              ],
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: darkGrey3,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: IconButton(
                  color: grey,
                  iconSize: 28,
                  splashRadius: 24,
                  onPressed: () => _changeMapStyle(null),
                  icon: const Icon(
                    Icons.layers_rounded,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: darkGrey3,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                height: 55,
                width: 55,
                child: IconButton(
                  color: grey,
                  iconSize: 28,
                  splashRadius: 24,
                  onPressed: () {
                    if (mapService.driveMode) {
                      _changeBirdMode(true);
                      _changeFollowingMode(mapService.follow);
                    } else {
                      _changeBirdMode(false);
                      _changeFollowingMode(true);
                    }
                    mapService.setDriveMode = !mapService.driveMode;
                  },
                  icon: Icon(
                    mapService.driveMode
                        ? Icons.navigation_rounded
                        : Icons.public_rounded,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
