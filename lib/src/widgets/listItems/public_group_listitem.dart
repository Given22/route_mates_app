import 'package:flutter/material.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class PublicGroupListItem extends StatefulWidget {
  const PublicGroupListItem({
    super.key,
    required this.uid,
    required this.name,
    this.location,
    this.membersAmount,
  });

  final String uid;
  final String name;
  final String? location;
  final int? membersAmount;

  @override
  State<PublicGroupListItem> createState() => _FriendsListItemState();
}

class _FriendsListItemState extends State<PublicGroupListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Picture(
              photoUrl: DB().getPhotoUrl(
                folder: DB().groupFolder,
                uid: widget.uid,
              ),
              asset: DB().groupAsset,
              size: 48,
              borderRadius: 8,
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: widget.name,
                  color: grey,
                  screenPartMaxWidth: 0.4,
                ),
                Row(
                  children: [
                    widget.location != null && widget.location!.isNotEmpty
                        ? Row(
                            children: [
                              CustomText(
                                text: widget.location!,
                                color: grey2,
                                screenPartMaxWidth: 0.4,
                                fontFamily: Fonts().secondary,
                              ),
                              const SizedBox(
                                width: 4,
                                height: 4,
                              )
                            ],
                          )
                        : const SizedBox(),
                    if (widget.membersAmount != null) ...[
                      CustomText(
                        text: 'members: ',
                        color: grey2,
                        fontFamily: Fonts().secondary,
                      ),
                      CustomText(
                        text: widget.membersAmount! >= 1000
                            ? '+999'
                            : widget.membersAmount.toString(),
                        color: grey2,
                        fontFamily: Fonts().secondary,
                      )
                    ],
                  ],
                )
              ],
            )
          ],
        ),
        IconButton(
          onPressed: () async {
            await FBFunctions().joinGroup.call({
              'groupId': widget.uid,
              'groupName': widget.name,
            });
          },
          splashRadius: 24,
          icon: Icon(
            Icons.group_add_rounded,
            color: orange,
          ),
        ),
      ],
    );
  }
}
