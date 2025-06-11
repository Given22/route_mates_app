import 'dart:async';

import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';

class AlertDelay extends ChangeNotifier {
  Timer? _timer;
  Timer? _progressTimer;
  double progress = 0;
  bool canSendMessage = true;

  void startTimer() {
    canSendMessage = false;
    progress = 0;
    notifyListeners();
    _timer = Timer( Duration(seconds: SEND_ALERT_DELAY_IN_SEC), () {
      canSendMessage = true;
      progress = 1;
      _progressTimer?.cancel();
      notifyListeners();
    });
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (progress < 1) {
        progress += (1 / SEND_ALERT_DELAY_IN_SEC);
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _progressTimer?.cancel();
    canSendMessage = true;
    progress = 1;
    notifyListeners();
  }
}
