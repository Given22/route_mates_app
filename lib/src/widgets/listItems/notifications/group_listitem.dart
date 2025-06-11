import 'package:flutter/material.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/listItems/notifications/buttons_section.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class GroupNotificationListItem extends StatefulWidget {
  const GroupNotificationListItem({
    super.key,
    required this.type,
    required this.time,
    required this.userName,
    required this.userUid,
    required this.groupName,
    required this.groupUid,
  });

  final String type;
  final String time;
  final String userName;
  final String userUid;
  final String groupName;
  final String groupUid;

  @override
  State<GroupNotificationListItem> createState() =>
      _GroupNotificationListItemState();
}

class _GroupNotificationListItemState extends State<GroupNotificationListItem> {
  Future<void> _accept() async {
    await FBFunctions().acceptGroupInvitation.call({
      'groupId': widget.groupUid,
      'groupName': widget.groupName,
    });
  }

  Future<void> _decline() async {
    await FBFunctions().declineGroupInvitation.call({
      'groupId': widget.groupUid,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Picture(
                  photoUrl: DB().getPhotoUrl(
                      folder: DB().groupFolder, uid: widget.groupUid),
                  asset: DB().groupAsset,
                  size: 40,
                  borderRadius: 8,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Group invitation!',
                      size: 16,
                      color: grey,
                      weight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: widget.userName,
                          size: 14,
                          color: grey2,
                          maxTextLength: 8,
                          fontFamily: Fonts().secondary,
                        ),
                        CustomText(
                          text: ' invite you to ',
                          size: 14,
                          color: grey2,
                          fontFamily: Fonts().secondary,
                        ),
                        CustomText(
                          text: widget.groupName,
                          size: 14,
                          color: grey2,
                          maxTextLength: 8,
                          fontFamily: Fonts().secondary,
                        ),
                      ],
                    )
                  ],
                )
              ],
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
