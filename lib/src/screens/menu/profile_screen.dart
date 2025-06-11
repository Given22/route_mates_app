import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/components/home/notification_button.dart';
import 'package:route_mates/src/components/profile/friends_pictures_list.dart';
import 'package:route_mates/src/components/profile/garage.dart';
import 'package:route_mates/src/components/profile/profile_section.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/screens/developing_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    bool work = Config().getBool("profile_page");
    if (!work) {
      return const DevelopingPage();
    }

    return Container(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const NotificationButton(),
                    IconButton(
                      onPressed: () {
                        context.go('/settings');
                      },
                      iconSize: 30,
                      splashRadius: 24,
                      icon: Icon(
                        Icons.settings,
                        color: grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const ProfileSection(),
              const SizedBox(
                height: 48,
              ),
              const FriendsPicturesList(),
              const SizedBox(
                height: 32,
              ),
              const GarageSection(),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
