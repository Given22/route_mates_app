import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/notification_token_service.dart';
import 'package:route_mates/src/screens/loading_page.dart';

class LogOutPage extends StatelessWidget {
  const LogOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NotificationTokenService().removeTokenData();
      if (await FlutterBackgroundService().isRunning()) {
        FlutterBackgroundService().invoke("stop");
      }
      await Auth().signOut();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
    });
    return const LoadingPage();
  }
}
