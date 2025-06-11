import 'package:flutter/material.dart';
import 'package:route_mates/src/components/profile/edit_profile_data.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Profile',
                        color: grey,
                        size: 20,
                        weight: FontWeight.bold,
                      ),
                      IconButton(
                        onPressed: () {
                          context.go('/main', extra: 3);
                        },
                        iconSize: 30,
                        splashRadius: 24,
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: grey,
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: EditProfileDataBox()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
