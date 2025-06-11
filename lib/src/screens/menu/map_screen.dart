import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/components/ads/banner_ad.dart';
import 'package:route_mates/src/components/map/bottom_sheet/bottom_sheet.dart';
import 'package:route_mates/src/components/map/map.dart';
import 'package:route_mates/src/components/map/sharing_button.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/screens/developing_page.dart';
import 'package:route_mates/utils/map/control_map_service.dart';
import 'package:route_mates/utils/view.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.navbarVisibility,
  });

  final Function(bool? value) navbarVisibility;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  ControlMapService mapService = ControlMapService();
  DraggableScrollableController sheetController =
      DraggableScrollableController();

  bool adLoaded = false;

  _setAdState(bool state) {
    setState(() {
      adLoaded = state;
    });
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool work = Config().getBool("map_page");
    if (!work) {
      return const DevelopingPage();
    }

    mapService = ControlMapService();

    return ChangeNotifierProvider(
      create: (_) => ControlMapService(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: darkBg,
          body: Stack(
            fit: StackFit.expand,
            alignment: Alignment.topCenter,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding: EdgeInsets.only(
                    top: adLoaded && ViewOrientation().isPortrait(context)
                        ? 60
                        : 0),
                child: const FullMap(),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                top: 0,
                left: adLoaded && !ViewOrientation().isPortrait(context)
                    ? 0
                    : null,
                child: MyBannerAd(
                  setAdLoaded: _setAdState,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                top: adLoaded && ViewOrientation().isPortrait(context) ? 66 : 6,
                right: 16,
                child: const SharingButton(),
              ),
              const BottomPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
