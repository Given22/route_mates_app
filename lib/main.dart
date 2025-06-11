import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/emulators.dart';
import 'package:route_mates/router.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/utils/map/background_sharing_service.dart';
import 'package:route_mates/utils/initialization_helper.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'src/const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GDPR().initialize();

  await FirebaseEmulators().init();
  await Config().init();

  if (Config().getBool("app_closed")) {
    runApp(const DevelopmentApp());
    return;
  }

  if (await BackgroundSharingService().isServiceAlreadyRunning) {
    BackgroundSharingService().stop();
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<AsyncSnapshot<User?>>.value(
          value: Auth().authChanges,
          initialData: const AsyncSnapshot.waiting(),
          updateShouldNotify: (before, after) {
            if (before != after) {
              return true;
            }
            return false;
          },
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: "Route Mates",
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class DevelopmentApp extends StatelessWidget {
  const DevelopmentApp({super.key});

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
    return MaterialApp(
      home: Scaffold(
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
                    text: "App was closed",
                    color: grey2,
                    size: 18,
                    weight: FontWeight.bold,
                    align: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomText(
                    text: "Update app and wait carefully for the fix",
                    color: grey2,
                    size: 18,
                    weight: FontWeight.bold,
                    fontFamily: Fonts().secondary,
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
