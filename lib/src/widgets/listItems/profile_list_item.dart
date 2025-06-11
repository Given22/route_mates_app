import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/small_outlined_button.dart';
import 'package:route_mates/src/widgets/buttons/small_solid_button.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class ProfileListItem extends StatefulWidget {
  const ProfileListItem({
    super.key,
    required this.uid,
    required this.name,
    required this.isFriend,
    required this.isInvited,
    required this.gotRequest,
  });

  final String uid;
  final String name;
  final bool isFriend;
  final bool isInvited;
  final bool gotRequest;

  @override
  State<ProfileListItem> createState() => _ProfileListItemState();
}

class _ProfileListItemState extends State<ProfileListItem> {
  bool _isLoading = false;

  _loading() {
    return const SizedBox(
      height: 30,
      width: 30,
      child: Center(
        child: CircularLoadingIndicator(
          size: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            context.push('/users/${widget.uid}');
          },
          child: Row(
            children: [
              Picture(
                photoUrl: DB()
                    .getPhotoUrl(folder: DB().profileFolder, uid: widget.uid),
                asset: DB().profileAsset,
                size: 52,
                borderRadius: 8,
              ),
              const SizedBox(
                width: 16,
              ),
              CustomText(
                text: widget.name,
                color: grey,
                screenPartMaxWidth: 0.4,
              ),
            ],
          ),
        ),
        if (widget.isFriend)
          SmallOulinedButtonWid(
              text: 'Remove',
              color: grey,
              borderRadius: 24,
              onPressFn: () async {
                setState(() {
                  _isLoading = true;
                });

                await FBFunctions()
                    .removeFriendship
                    .call({'withWho': widget.uid});
              })
        else if (widget.gotRequest)
          SmallSolidButton(
              text: 'Accept',
              bgColor: Colors.green,
              color: darkBg,
              onPressFn: () async {
                setState(() {
                  _isLoading = true;
                });
                await FBFunctions()
                    .acceptFriendship
                    .call({'withWho': widget.uid});
              })
        else if (widget.isInvited)
          CustomText(
            text: 'Invited',
            size: 16,
            color: grey,
          )
        else if (_isLoading)
          _loading()
        else
          SmallSolidButton(
              text: 'Invite',
              bgColor: Colors.green,
              color: darkBg,
              onPressFn: () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await FBFunctions()
                      .invitePerson
                      .call(<String, dynamic>{'to': widget.uid});
                } on FirebaseFunctionsException {
                  Fluttertoast.showToast(msg: "Invitation failed");
                }
              })
      ],
    );
  }
}
