import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:route_mates/data/friendships.dart';
import 'package:route_mates/data/requests.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/text_button.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/list.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/listItems/profile_list_item.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class FirstFriendsSearch extends StatefulWidget {
  const FirstFriendsSearch({super.key, this.maxH});

  final double? maxH;

  @override
  State<FirstFriendsSearch> createState() => _FirstFriendsSearchState();
}

class _FirstFriendsSearchState extends State<FirstFriendsSearch> {
  String _inputValue = '';
  int _limit = 15;

  _search(String input) {
    setState(() {
      _inputValue = input;
      _limit = 15;
    });
  }

  _findSomeone() {
    return SizedBox(
      height: 200,
      child: Center(
        child: CustomText(
          align: TextAlign.center,
          text: Config().getString("SEARCH_PAGE_FIND_SOMEONE"),
          color: grey2,
        ),
      ),
    );
  }

  _loading() {
    return const SizedBox(
      height: 50,
      child: Center(
        child: LoadingIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> gotRequests = [];
    List<String> sendRequests = [];
    List<String> friends = [];

    List<SendRequest> sendFriendshipRequests =
        Provider.of<List<SendRequest>>(context);
    for (var element in sendFriendshipRequests) {
      sendRequests.add(element.uid);
    }

    List<GotRequest> gotFriendshipRequests =
        Provider.of<List<GotRequest>>(context);
    for (var element in gotFriendshipRequests) {
      gotRequests.add(element.userUid);
    }

    List<Friend> friendsList = Provider.of<List<Friend>>(context);
    for (var element in friendsList) {
      friends.add(element.uid);
    }

    return Stack(
      children: [
        _inputValue != ''
            ? StreamBuilder<List<UserStore>>(
                stream: Store()
                    .firestore
                    .collection('users')
                    .where('displayName',
                        isGreaterThanOrEqualTo: _inputValue.toUpperCase())
                    .where('displayName',
                        isLessThanOrEqualTo:
                            '${_inputValue.toLowerCase()}\uf8ff')
                    .limit(_limit + 1)
                    .snapshots()
                    .map(
                  (event) {
                    return event.docs
                        .map((doc) => UserStore.fromQueryFirestore(doc))
                        .toList();
                  },
                ),
                builder:
                    (context, AsyncSnapshot<List<UserStore>> usersSnapshot) {
                  if (usersSnapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: SizedBox(
                        height: 100,
                        child: CustomText(
                          align: TextAlign.center,
                          text: "Something gone wrong",
                          color: blueLink,
                        ),
                      ),
                    );
                  }

                  if (usersSnapshot.connectionState == ConnectionState.active ||
                      usersSnapshot.connectionState == ConnectionState.done) {
                    usersSnapshot.data!.removeWhere(
                        (user) => user.uid == Auth().currentUser!.uid);

                    usersSnapshot.data!.sort((a, b) => a.displayName
                        .toLowerCase()
                        .compareTo(b.displayName.toLowerCase()));

                    final bool more = usersSnapshot.data!.length > _limit;

                    List<Widget> widgets = usersSnapshot.data!
                        .getRange(0, more ? _limit : usersSnapshot.data!.length)
                        .map((user) {
                      final userUid = user.uid;

                      return ProfileListItem(
                        key: Key("${Random().nextDouble()}"),
                        uid: user.uid,
                        name: user.displayName,
                        gotRequest: gotRequests.contains(userUid),
                        isInvited: sendRequests.contains(userUid),
                        isFriend: friends.contains(userUid),
                      );
                    }).toList();

                    if (more) {
                      widgets = [
                        ...widgets,
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _limit += 10;
                            });
                          },
                          child: CustomText(
                            text: "Show more",
                            color: blueLink,
                            fontFamily: Fonts().primary,
                            size: 16,
                            align: TextAlign.center,
                            weight: FontWeight.bold,
                          ),
                        )
                      ];
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomVerticalList(
                        gap: 16,
                        customEmptyListText:
                            "We can't find any user with this name",
                        customEmptyTextColor: blueLink,
                        paddingAtStart: 140,
                        children: widgets,
                      ),
                    );
                  }
                  return _loading();
                },
              )
            : _findSomeone(),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  darkBg2,
                  darkBg.withAlpha(0),
                ],
              ),
            ),
            height: 130,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Find first friends',
                            color: grey,
                            size: 18,
                            weight: FontWeight.bold,
                          ),
                          TextButtonWid(
                            onPressFn: () {
                              context.go('/main');
                            },
                            text: "End",
                            textColor: grey,
                            textSize: 18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextInputBox(
                      label: 'Search',
                      onSubmit: _search,
                      validator: inputValidator,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
