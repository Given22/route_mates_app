import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/friendships.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/data/requests.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/list.dart';
import 'package:route_mates/src/widgets/listItems/friend_group_listitem.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({
    super.key,
    required this.onTap,
  });

  final Function() onTap;

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  String _inputValue = '';
  int _limit = 15;
  List<String> gotRequests = [];
  List<String> sendRequests = [];
  List<String> friends = [];

  _search(String input) {
    setState(() {
      _inputValue = input;
    });
  }

  header() {
    return Row(
      children: [
        CustomText(
          text: 'Your friends',
          size: 18,
          weight: FontWeight.bold,
          color: grey,
        )
      ],
    );
  }

  friendsList() {
    var group = Provider.of<AsyncSnapshot<Group?>>(context);

    var friends = Provider.of<List<Friend>>(context);

    if (friends.isEmpty) {
      return Center(
        child: CustomText(
          text: Config().getString("WITH_GROUP_EMPTY_FRIENDS"),
          size: 16,
          color: blueLink,
          align: TextAlign.center,
        ),
      );
    }

    var members = Provider.of<List<Member>>(context);
    var invited = Provider.of<List<SendGroupInvitation>>(context);

    List<String> membersUids = members.map((e) => e.uid).toList();
    List<String> invitedUids = invited.map((e) => e.uid).toList();

    if (_inputValue.isNotEmpty) {
      friends = friends
          .where((element) =>
              element.name.toLowerCase().contains(_inputValue.toLowerCase()))
          .toList();
    }

    if (friends.isEmpty) {
      return Center(
        child: CustomText(
          text: Config().getString("WITH_GROUP_NOT_MATCH_SEARCH"),
          size: 16,
          color: blueLink,
          align: TextAlign.center,
        ),
      );
    }

    List<Widget> friendWidgets = friends
        .getRange(0, friends.length > _limit ? _limit : friends.length)
        .map(
      (friend) {
        return FriendGroupListItem(
          uid: friend.uid,
          name: friend.name,
          isInvited: invitedUids.contains(friend.uid),
          isMember: membersUids.contains(friend.uid),
          isMaster:
              group.data != null ? group.data!.master == friend.uid : false,
        );
      },
    ).toList();

    if (friends.length > _limit) {
      friendWidgets.add(TextButton(
        onPressed: () {
          setState(() {
            _limit += 10;
          });
        },
        child: CustomText(
          text: Config().getString("MEMBERS_PAGE_SHOW_MORE"),
          color: blueLight2,
          size: 14,
          align: TextAlign.center,
        ),
      ));
    }

    return CustomVerticalList(
      gap: 16,
      maxHeight: 400,
      children: friendWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Invite your friends',
          size: 18,
          weight: FontWeight.bold,
          color: grey,
        ),
        const SizedBox(
          height: 8,
        ),
        TextInputBox(
          onSubmit: _search,
          label: 'Search',
          onCHange: _search,
        ),
        const SizedBox(
          height: 32,
        ),
        friendsList(),
      ],
    );
  }
}
