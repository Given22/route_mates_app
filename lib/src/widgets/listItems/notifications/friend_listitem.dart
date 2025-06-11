import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/listItems/notifications/buttons_section.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class FriendshipNotificationListItem extends StatefulWidget {
  const FriendshipNotificationListItem({
    super.key,
    required this.name,
    required this.uid,
    required this.type,
    required this.time,
  });

  final String type;
  final String uid;
  final String name;
  final String time;

  @override
  State<FriendshipNotificationListItem> createState() =>
      _NotificationListItemState();
}

class _NotificationListItemState extends State<FriendshipNotificationListItem> {
  Future<void> _accept() async {
    await FBFunctions()
        .acceptFriendship
        .call(<String, dynamic>{'withWho': widget.uid});
  }

  Future<void> _decline() async {
    await FBFunctions()
        .declineFriendship
        .call(<String, dynamic>{'withWho': widget.uid});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => context.push('/users/${widget.uid}'),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Picture(
                    size: 40,
                    borderRadius: 8,
                    photoUrl: DB().getPhotoUrl(
                        folder: DB().profileFolder, uid: widget.uid),
                    asset: DB().profileAsset,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Friend invitation!',
                        size: 16,
                        color: grey,
                        weight: FontWeight.bold,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: widget.name,
                            size: 15,
                            color: grey2,
                            maxTextLength: 10,
                            fontFamily: Fonts().secondary,
                          ),
                          CustomText(
                            text: ' send you an invitation',
                            size: 15,
                            color: grey2,
                            fontFamily: Fonts().secondary,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            CustomText(
              text: widget.time,
              color: grey,
              size: 13,
            )
          ],
        ),
        ButtonsSection(onAccept: _accept, onDeclined: _decline),
      ],
    );
  }
}
