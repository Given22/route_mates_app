import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class DevelopingPage extends StatelessWidget {
  const DevelopingPage({super.key});

  _svg() {
    FlutterView view = PlatformDispatcher.instance.views.first;
    double physicalWidth = view.physicalSize.width;
    double devicePixelRatio = view.devicePixelRatio;
    double screenWidth = physicalWidth / devicePixelRatio;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(
        'assets/svgs/mobile_development.svg',
        width: screenWidth * 0.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              darkBg2,
              darkBg,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _svg(),
                const SizedBox(
                  height: 64,
                ),
                CustomText(
                  text: Config().getString("DEVELOPMENT_PAGE_MAIN"),
                  color: grey2,
                  size: 18,
                  weight: FontWeight.bold,
                  align: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomText(
                  text: Config().getString("DEVELOPMENT_PAGE_SECOND"),
                  color: grey2,
                  size: 18,
                  fontFamily: Fonts().secondary,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
