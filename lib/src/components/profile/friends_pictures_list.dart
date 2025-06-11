import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/friendships.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/text_button.dart';
import 'package:route_mates/src/widgets/slide_page_route.dart';
import 'package:route_mates/src/screens/profile_subpages/friends_screen.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class FriendsPicturesList extends StatefulWidget {
  const FriendsPicturesList({super.key});

  @override
  State<FriendsPicturesList> createState() => _FriendsPicturesListState();
}

class _FriendsPicturesListState extends State<FriendsPicturesList> {
  _goToFriendsScreen() {
    Navigator.push(context, slidePageRouteFromDown(const FriendsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    List<String> friends = [];

    List<Friend> friendsList = Provider.of<List<Friend>>(context);
    for (var element in friendsList) {
      friends.add(element.uid);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              UsersPhotosList(
                users: friends,
                count: true,
              ),
              const SizedBox(
                height: 4,
              ),
              friends.isEmpty
                  ? SizedBox(
                      height: 32,
                      width: MediaQuery.of(context).size.width - (2 * 16),
                      child: Center(
                        child: CustomText(
                          align: TextAlign.center,
                          text: Config().getString("PROFILE_PAGE_NO_FRIENDS"),
                          color: grey2,
                          size: 16,
                        ),
                      ),
                    )
                  : TextButtonWid(
                      onPressFn: _goToFriendsScreen,
                      text: 'Friends',
                      textColor: blueLink,
                      textWeight: FontWeight.bold,
                      textSize: 16,
                    )
            ],
          ),
        )
      ],
    );
  }
}
