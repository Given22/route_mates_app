import 'package:flutter/material.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/components/search/all_users_search.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/screens/developing_page.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool work = Config().getBool("search_page");
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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 8, top: 16, right: 8),
            child: AllUsersSearch(),
          ),
        ),
      ),
    );
  }
}
