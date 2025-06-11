import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/utils/alerts/alert_delay.dart';
import 'package:route_mates/utils/alerts/alert_group_service.dart';
import 'package:route_mates/utils/map/background_sharing_service.dart';

class AlertGroupButton extends StatefulWidget {
  const AlertGroupButton({super.key});

  @override
  State<AlertGroupButton> createState() => _AlertGroupButtonState();
}

class _AlertGroupButtonState extends State<AlertGroupButton> {
  @override
  Widget build(BuildContext context) {
    var alertDelay = Provider.of<AlertDelay>(context);

    return Consumer<BackgroundSharingService>(
        builder: (context, bgService, __) {
      if (bgService.isSharing) {
        return Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: alertDelay.canSendMessage ? orange : darkBg2,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 5),
                    blurRadius: 4,
                  )
                ],
              ),
              height: 55,
              width: 55,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: IconButton(
                  color: darkGrey,
                  iconSize: 32,
                  splashRadius: 24,
                  onPressed: alertDelay.canSendMessage
                      ? () async {
                          if (await AlertGroup().openDialog(context)) {
                            alertDelay.startTimer();
                          }
                        }
                      : null,
                  icon: Icon(
                    Icons.announcement_rounded,
                    size: 32,
                    color: alertDelay.canSendMessage ? darkBg2 : darkGrey2,
                  ),
                ),
              ),
            ),
          ],
        );
      }
      return const SizedBox();
    });
  }
}
