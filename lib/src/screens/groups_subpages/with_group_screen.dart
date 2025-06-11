import 'package:flutter/material.dart';
import 'package:route_mates/src/components/groups/with/card.dart';
import 'package:route_mates/src/components/groups/with/friends.dart';
import 'package:route_mates/src/components/groups/with/header.dart';
import 'package:route_mates/src/components/groups/with/members.dart';
import 'package:route_mates/src/const.dart';

class WithGroupPage extends StatefulWidget {
  const WithGroupPage({super.key});

  @override
  State<WithGroupPage> createState() => _WithGroupPageState();
}

class _WithGroupPageState extends State<WithGroupPage> {
  final ScrollController _scrollController = ScrollController();

  scrollToTop() {
    _scrollController.animateTo(
      300,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
              child: Column(
                children: [
                  const GroupHeader(),
                  const SizedBox(
                    height: 32,
                  ),
                  const GroupCard(),
                  const SizedBox(
                    height: 32,
                  ),
                  const GroupMembers(),
                  const SizedBox(
                    height: 32,
                  ),
                  FriendsList(
                    onTap: scrollToTop,
                  ),
                  const SizedBox(
                    height: 32,
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
