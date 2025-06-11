import 'dart:async';

import 'package:flutter/material.dart';
import 'package:route_mates/data/notifications.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/utils/phone_database.dart';
import 'package:route_mates/utils/view.dart';
import 'package:vibration/vibration.dart';

class AlertBox extends StatefulWidget {
  const AlertBox({
    super.key,
    required this.notification,
  });

  final Message notification;

  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox>
    with SingleTickerProviderStateMixin {
  double progress = 0.0;
  late Timer timer;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (progress < 1) {
        setState(() {
          progress += (1 / HOW_LONG_ALERT_SHOULD_BE_VISIBLE_IN_SEC);
        });
      }
    });
    if (PhoneDatabase().get<bool>("Settings", "alert_vibration") ?? true) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        bool? can = await Vibration.hasCustomVibrationsSupport();
        if (can != null && can) {
          Vibration.vibrate(pattern: [500, 500, 500, 500]);
        } else {
          Vibration.vibrate();
          await Future.delayed(const Duration(milliseconds: 500));
          Vibration.vibrate();
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 20,
        shadowColor: darkBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetAnimationCurve: Curves.elasticOut,
        alignment: Alignment.topCenter,
        insetAnimationDuration: const Duration(milliseconds: 500),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    orange,
                    orange.withAlpha(220),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: darkBg.withOpacity(0.8),
                    offset: const Offset(0, 50),
                    spreadRadius: 100,
                    blurRadius: 50,
                  ),
                ]),
            constraints: BoxConstraints(
              maxWidth: ViewOrientation().isPortrait(context)
                  ? double.infinity
                  : MediaQuery.of(context).size.width * 0.5,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  color: grey2,
                  backgroundColor: darkBg,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomText(
                  text: "${widget.notification.data.whoName}",
                  color: darkBg,
                  weight: FontWeight.bold,
                  size: 18,
                  align: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Icon(
                    Alerts().icons[widget.notification.data.alertTag!],
                    color: darkBg,
                    size: 76,
                  ),
                ),
                CustomText(
                  text: "${widget.notification.message?.body}",
                  color: darkBg,
                  weight: FontWeight.bold,
                  size: 20,
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
