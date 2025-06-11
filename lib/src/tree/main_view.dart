import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/messaging.dart';
import 'package:route_mates/src/components/navbar.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/screens/menu/map_screen.dart';
import 'package:route_mates/src/screens/menu/groups_screen.dart';
import 'package:route_mates/src/screens/menu/profile_screen.dart';
import 'package:route_mates/src/screens/menu/search_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:route_mates/utils/view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, this.page});

  final int? page;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var _activeIndex = 1;
  Orientation _orientation = Orientation.portrait;
  bool navbar = true;

  late StreamSubscription? stream;

  void _changeNavbarVisibility(bool? visible) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        navbar = visible ?? !navbar;
      });
    });
    return;
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'friend' || message.data['type'] == 'group') {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          context.pushNamed("NOTIFICATIONS");
        }
      });
    }
  }

  @override
  void initState() {
    if (widget.page != null) {
      _activeIndex = widget.page!;
    }
    stream = MessageService().listenAlertMessage(context);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    super.initState();
  }

  void setActiveIndex(int index) {
    if (_activeIndex == index) return;
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const GroupsMainScreen(),
      MapScreen(navbarVisibility: _changeNavbarVisibility),
      const SearchScreen(),
      const ProfileScreen(),
    ];

    return OrientationBuilder(builder: (context, orientation) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!ViewOrientation().isPortrait(context)) {
          orientation = Orientation.landscape;
        }
        if (_orientation != orientation) {
          _changeNavbarVisibility(orientation != Orientation.landscape);
          setState(() {
            _orientation = orientation;
          });
        }
      });
      return Scaffold(
        backgroundColor: darkBg,
        body: screens[_activeIndex],
        extendBody: true,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: navbar
            ? Navbar(
                setActiveIndex: setActiveIndex,
                activeIndex: _activeIndex,
              )
            : null,
      );
    });
  }
}
