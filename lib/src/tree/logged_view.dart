import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/fire/messaging.dart';
import 'package:route_mates/fire/notification_token_service.dart';
import 'package:route_mates/src/screens/loading_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:route_mates/utils/phone_database.dart';

class LoggedWidgetTree extends StatelessWidget {
  const LoggedWidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context);

    MessageService().init();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NotificationTokenService().checkToken();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await PhoneDatabase().init();

      final user = await Store().user;

      if (context.mounted) {
        if (user == null || user.displayName == '') {
          context.goNamed("CREATE");
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            RemoteMessage? initialMessage =
                await FirebaseMessaging.instance.getInitialMessage();

            if (initialMessage != null) {
              if (context.mounted) {
                context.goNamed("NOTIFICATIONS");
              }
            } else {
              if (context.mounted) {
                context.go('/main');
              }
            }
          });
        }
      }
    });

    return const LoadingPage();
  }
}
