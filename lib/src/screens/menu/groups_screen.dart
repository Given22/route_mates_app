import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/data/requests.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/src/screens/developing_page.dart';
import 'package:route_mates/src/screens/groups_subpages/with_group_screen.dart';
import 'package:route_mates/src/screens/groups_subpages/without_group_screen.dart';
import 'package:route_mates/src/screens/loading_page.dart';

class GroupsMainScreen extends StatefulWidget {
  const GroupsMainScreen({super.key});

  @override
  State<GroupsMainScreen> createState() => _GroupsMainScreenState();
}

class _GroupsMainScreenState extends State<GroupsMainScreen> {
  @override
  Widget build(BuildContext context) {
    bool work = Config().getBool("group_page");
    if (!work) {
      return const DevelopingPage();
    }
    
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context);

    if (user.connectionState == ConnectionState.active ||
        user.connectionState == ConnectionState.done) {
      if (user.hasData) {
        if (user.data!.group.uid.isNotEmpty) {
          return MultiProvider(
            providers: [
              StreamProvider<List<Member>>.value(
                value: Store().groupMembersStream(user.data!.group.uid),
                initialData: const [],
                catchError: (context, error) {
                  return [];
                },
                updateShouldNotify: (before, after) {
                  if (before != after) {
                    return true;
                  }
                  return false;
                },
              ),
              StreamProvider<List<SendGroupInvitation>>.value(
                value: Store().groupSendInvitationsStream(user.data!.group.uid),
                initialData: const [],
                catchError: (context, error) {
                  return [];
                },
                updateShouldNotify: (before, after) {
                  if (before != after) {
                    return true;
                  }
                  return false;
                },
              ),
              StreamProvider<AsyncSnapshot<Group?>>.value(
                value: Store().groupStream(user.data!.group.uid),
                initialData: const AsyncSnapshot.waiting(),
                catchError: (context, error) {
                  return const AsyncSnapshot.nothing();
                },
                updateShouldNotify: (before, after) {
                  if (before != after) {
                    return true;
                  }
                  return false;
                },
              ),
            ],
            child: const WithGroupPage(),
          );
        }
        return const WithoutGroupPage();
      }
    }
    return const LoadingPage();
  }
}
