import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/src/components/profile_preview/friends_pictures_list.dart';
import 'package:route_mates/src/components/profile_preview/garage.dart';
import 'package:route_mates/src/components/profile_preview/profile_section.dart';
import 'package:route_mates/src/const.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key, required this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      context.pop();
    }
    return Scaffold(
      backgroundColor: darkBg,
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        onLongPress: () => context.go("/main"),
                        child: SizedBox(
                          height: 32,
                          width: 32,
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: grey,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                ProfileSection(id: id!),
                const SizedBox(
                  height: 48,
                ),
                FriendsPicturesList(id: id!),
                const SizedBox(
                  height: 32,
                ),
                GarageSection(
                  id: id!,
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
      resizeToAvoidBottomInset: true,
    );
  }
}
