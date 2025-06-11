import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:route_mates/src/components/onboarding/header.dart';
import 'package:route_mates/src/components/onboarding/keypage/key_section.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class KeyPage extends StatefulWidget {
  const KeyPage({super.key});

  @override
  State<KeyPage> createState() => _KeyPageState();
}

class _KeyPageState extends State<KeyPage> {
  _svg() {
    FlutterView view = PlatformDispatcher.instance.views.first;
    double physicalWidth = view.physicalSize.width;
    double devicePixelRatio = view.devicePixelRatio;
    double screenWidth = physicalWidth / devicePixelRatio;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(
        'assets/svgs/secure_login.svg',
        width: screenWidth * 0.5,
      ),
    );
  }

  // footer with text
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
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
                  const Header(alpha: true),
                  const KeyInputSection(),
                  _svg(),
                  CustomText(
                    text:
                        "We require a unique key for registration to protect the exclusivity of our community throughout the alpha period.",
                    color: blueLink,
                    weight: FontWeight.bold,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
