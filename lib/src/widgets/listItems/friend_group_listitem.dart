import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/small_outlined_button.dart';

import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class FriendGroupListItem extends StatefulWidget {
  const FriendGroupListItem({
    super.key,
    required this.uid,
    required this.name,
    required this.isInvited,
    required this.isMember,
    required this.isMaster,
  });

  final String uid;
  final String name;
  final bool isInvited;
  final bool isMember;
  final bool isMaster;

  @override
  State<FriendGroupListItem> createState() => _FriendGroupListItemState();
}

class _FriendGroupListItemState extends State<FriendGroupListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.push('/users/${widget.uid}'),
          child: Row(
            children: [
              Picture(
                photoUrl: DB().getPhotoUrl(
                  folder: DB().profileFolder,
                  uid: widget.uid,
                ),
                asset: DB().profileAsset,
                size: 48,
                borderRadius: 8,
              ),
              const SizedBox(
                width: 16,
              ),
              CustomText(
                text: widget.name,
                weight: FontWeight.normal,
                size: 16,
                color: grey,
                screenPartMaxWidth: 0.4,
                fontFamily: Fonts().primary,
              ),
            ],
          ),
        ),
        Button(
          uid: widget.uid,
          name: widget.name,
          isInvited: widget.isInvited,
          isMaster: widget.isMaster,
          isMember: widget.isMember,
        ),
      ],
    );
  }
}

class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.uid,
    required this.name,
    required this.isInvited,
    required this.isMember,
    required this.isMaster,
  });

  final String uid;
  final String name;
  final bool isInvited;
  final bool isMember;
  final bool isMaster;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
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

  invite() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var group = Provider.of<AsyncSnapshot<Group?>>(context, listen: false);

      if (group.hasData) {
        await FBFunctions().inviteToGroup.call({
          'groupId': group.data!.uid,
          'groupName': group.data!.name,
          'to': widget.uid,
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "We had some problems with invitation");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMaster) {
      setState(() {
        _isLoading = false;
      });
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomText(
          text: 'Owner',
          color: blueLink,
          size: 16,
          weight: FontWeight.w500,
          fontFamily: Fonts().secondary,
        ),
      );
    } else if (widget.isMember) {
      setState(() {
        _isLoading = false;
      });
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomText(
          text: 'Member',
          color: darkBlue,
          size: 16,
          weight: FontWeight.w500,
          fontFamily: Fonts().secondary,
        ),
      );
    } else if (widget.isInvited) {
      setState(() {
        _isLoading = false;
      });
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomText(
          text: 'Invited',
          color: grey2,
          size: 16,
        ),
      );
    } else if (_isLoading) {
      return _loading();
    } else {
      setState(() {
        _isLoading = false;
      });
      return SmallOulinedButtonWid(
        text: 'Invite',
        color: orange,
        borderRadius: 24,
        onPressFn: invite,
      );
    }
  }
}
