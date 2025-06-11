import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/data/friendships.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/list.dart';
import 'package:route_mates/src/widgets/listItems/friends_list_item.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key, required this.userId});

  final String? userId;

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  String _inputValue = '';

  _search(String input) {
    setState(() {
      _inputValue = input;
    });
  }

  _friends() {
    return FutureBuilder(
        future: Store().userFriendsFuture(widget.userId!),
        builder: (_, future) {
          if (future.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(
                child: LoadingIndicator(),
              ),
            );
          }
          List<Friend> friendsList = future.data ?? [];

          List<Widget> usersWigets = [];

          if (_inputValue.isNotEmpty) {
            List<Friend> filteredFriends = friendsList
                .where((element) => element.name
                    .toString()
                    .toLowerCase()
                    .startsWith(_inputValue.toLowerCase()))
                .toList();

            usersWigets = filteredFriends.map((data) {
              return FriendsListItem(
                uid: data.uid,
                name: data.name,
                canRemove: false,
              );
            }).toList();
          } else {
            usersWigets = friendsList.map((data) {
              return FriendsListItem(
                uid: data.uid,
                name: data.name,
                canRemove: false,
              );
            }).toList();
          }

          if (usersWigets.isEmpty && _inputValue.isNotEmpty) {
            return SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Center(
                child: CustomText(
                  align: TextAlign.center,
                  text: Config().getString("FRIENDS_PAGE_NOT_FOUND"),
                  color: blueLink,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomVerticalList(
              gap: 16,
              customEmptyListText: Config().getString("FRIENDS_PAGE_USER_NOT_HAVE_FRIENDS"),
              children: usersWigets,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userId == null) {
      context.go("/main");
    }
    return Scaffold(
      backgroundColor: darkBg,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 16, right: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Friends',
                          color: grey,
                          size: 20,
                          weight: FontWeight.w600,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          iconSize: 30,
                          splashRadius: 24,
                          icon: Icon(
                            Icons.arrow_downward_outlined,
                            color: grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextInputBox(
                    onSubmit: _search,
                    label: 'Find friend by name',
                    keyboardType: TextInputType.name,
                    validator: emptyInputValidator,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  _friends(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
