import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/solid_outlined_button.dart';
import 'package:route_mates/src/widgets/buttons/wide_solid_button.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterView view = PlatformDispatcher.instance.views.first;
    double physicalWidth = view.physicalSize.width;
    double devicePixelRatio = view.devicePixelRatio;
    double screenWidth = physicalWidth / devicePixelRatio;

    return SafeArea(
      child: Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 52,
                  child: Align(
                    alignment: Alignment.center,
                    child: LongLogo(
                      size: 0.7,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/svgs/travel.svg',
                    width: screenWidth * 0.55,
                  ),
                ),
                Column(
                  children: [
                    CustomText(
                      text: Config().getString("START_PAGE_MAIN"),
                      color: grey,
                      weight: FontWeight.bold,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CustomText(
                      text: Config().getString("START_PAGE_SECOND"),
                      color: grey2,
                      align: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    BigSolidButton(
                      borderRadius: 25,
                      text: "Sign up",
                      buttonColor: orange,
                      textColor: darkBg2,
                      onPressFn: () {
                        context.push("/start/register");
                      },
                      height: 45,
                      textWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 24),
                    SolidOutlinedButton(
                      text: "Login",
                      color: orange,
                      borderColor: orange,
                      onPressFn: () {
                        context.push("/start/login");
                      },
                      height: 45,
                      fontWeight: FontWeight.bold,
                      borderRadius: 25,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
