import 'package:flutter/material.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/screens/users_preview/friends_screen.dart';
import 'package:route_mates/src/widgets/buttons/text_button.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/slide_page_route.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class FriendsPicturesList extends StatefulWidget {
  const FriendsPicturesList({super.key, required this.id});

  final String id;

  @override
  State<FriendsPicturesList> createState() => _FriendsPicturesListState();
}

class _FriendsPicturesListState extends State<FriendsPicturesList> {
  _goToFriendsScreen() {
    Navigator.push(
      context,
      slidePageRouteFromDown(
        FriendsScreen(
          userId: widget.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Store().userFriendsFuture(widget.id),
        builder: (_, future) {
          if (future.connectionState != ConnectionState.done) {
            return const CircularLoadingIndicator(size: 48);
          }
          if (future.hasData) {
            List<String> friends = future.data!
                .map(
                  (e) => e.uid,
                )
                .toList();

            // friends
            //     .removeWhere((element) => element == Auth().currentUser!.uid);

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
                              width:
                                  MediaQuery.of(context).size.width - (2 * 16),
                              child: Center(
                                child: CustomText(
                                  align: TextAlign.center,
                                  text: Config().getString(
                                      'FRIENDS_PAGE_USER_NOT_HAVE_FRIENDS'),
                                  color: grey2,
                                  size: 15,
                                  fontFamily: Fonts().secondary,
                                ),
                              ),
                            )
                          : TextButtonWid(
                              onPressFn: _goToFriendsScreen,
                              text: 'See friends',
                              textColor: blueLink,
                              textWeight: FontWeight.bold,
                              textSize: 16,
                            )
                    ],
                  ),
                )
              ],
            );
          } else {
            return const CircularLoadingIndicator(size: 48);
          }
        });
  }
}
