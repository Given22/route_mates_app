import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/requests.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/utils/phone_database.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    List<GotRequest> gotRequest = Provider.of<List<GotRequest>>(context);

    int? notificationsAmount =
        PhoneDatabase().get<int>("main", "notifications_amount");

    return Stack(
      children: [
        IconButton(
          splashRadius: 24,
          iconSize: 28,
          onPressed: () {
            context.pushNamed("NOTIFICATIONS");
          },
          icon: Icon(
            Icons.notifications_rounded,
            color: grey,
          ),
        ),
        StreamBuilder<BoxEvent>(
          stream: PhoneDatabase().watch("main", "notifications_amount"),
          builder: (context, snapshot) {
            if (gotRequest.isNotEmpty ||
                (snapshot.hasData && snapshot.data!.value > 0) ||
                (notificationsAmount != null && notificationsAmount != 0)) {
              return Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 10,
                  height: 10,
                ),
              );
            }
            return const SizedBox();
          },
        )
      ],
    );
  }
}
