import 'package:flutter/material.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/src/components/groups/settings/members_list.dart';
import 'package:route_mates/src/const.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key, required this.group});

  final AsyncSnapshot<Group?> group;

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MembersList(
              groupId: group.data!.uid,
              isMaster: (Auth().currentUser?.uid == group.data?.master),
            ),
          ),
        ),
      ),
    );
  }
}
