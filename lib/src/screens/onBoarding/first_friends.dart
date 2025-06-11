import 'package:flutter/material.dart';
import 'package:route_mates/src/components/search/first_friends_search.dart';
import 'package:route_mates/src/const.dart';

class FirstFriends extends StatelessWidget {
  const FirstFriends({super.key});

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
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: const SafeArea(
              child: FirstFriendsSearch(),
            ),
          ),
        ),
      ),
    );
  }
}
