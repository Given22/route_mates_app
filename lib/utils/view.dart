import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:route_mates/functions/fun.dart';

class ViewOrientation {
  FlutterView view = PlatformDispatcher.instance.views.first;

  bool isPortrait(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double w = nearestTen(MediaQuery.of(context).size.width);
    double h = nearestTen(MediaQuery.of(context).size.height);
    if ((w * 0.1) < (w - h)) {
      orientation = Orientation.landscape;
    }
    return orientation == Orientation.portrait;
  }

  double getLeftPadding(BuildContext context) {
    double screenWidth = view.physicalSize.width / view.devicePixelRatio;
    return isPortrait(context) ? 0 : (screenWidth / 2);
  }

  double getTopPadding(BuildContext context) {
    double screenH = view.physicalSize.height / view.devicePixelRatio;
    return isPortrait(context) ? (screenH / 4) : 0;
  }

  double width() {
    FlutterView view = PlatformDispatcher.instance.views.first;
    double physicalWidth = view.physicalSize.width;
    double devicePixelRatio = view.devicePixelRatio;
    double screenWidth = physicalWidth / devicePixelRatio;
    return screenWidth;
  }

  double height() {
    FlutterView view = PlatformDispatcher.instance.views.first;
    double physicalHeight = view.physicalSize.height;
    double devicePixelRatio = view.devicePixelRatio;
    double screenHeight = physicalHeight / devicePixelRatio;
    return screenHeight;
  }

  double pixelsToHeightPercent(double pixels) {
    FlutterView view = PlatformDispatcher.instance.views.first;
    double physicalHeight = view.physicalSize.height;
    double devicePixelRatio = view.devicePixelRatio;
    double screenHeight = physicalHeight / devicePixelRatio;
    double percentage = pixels / screenHeight;
    return percentage >= 0.9 ? 0.8 : percentage;
  }
}
