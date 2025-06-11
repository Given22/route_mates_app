import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/small_outlined_button.dart';

import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class FriendsListItem extends StatefulWidget {
  const FriendsListItem({
    super.key,
    required this.uid,
    required this.name,
    required this.canRemove,
  });

  final String uid;
  final String name;
  final bool canRemove;

  @override
  State<FriendsListItem> createState() => _FriendsListItemState();
}

class _FriendsListItemState extends State<FriendsListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.push('/users/${widget.uid}'),
          child: Row(
            mainAxisAlignment: widget.canRemove
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Picture(
                size: 48,
                borderRadius: 8,
                photoUrl: DB().getPhotoUrl(
                  folder: DB().profileFolder,
                  uid: widget.uid,
                ),
                asset: DB().profileAsset,
              ),
              SizedBox(
                width: widget.canRemove ? 8 : 24,
              ),
              CustomText(
                text: widget.name,
                color: grey,
                screenPartMaxWidth: 0.6,
              ),
            ],
          ),
        ),
        if (widget.canRemove)
          RemoveButton(
            uid: widget.uid,
          ),
      ],
    );
  }
}

class RemoveButton extends StatefulWidget {
  const RemoveButton({super.key, required this.uid});

  final String uid;

  @override
  State<RemoveButton> createState() => _RemoveButtonState();
}

class _RemoveButtonState extends State<RemoveButton> {
  bool loading = false;
  _removeFriend() async {
    try {
      setState(() {
        loading = true;
      });
      await FBFunctions().removeFriendship.call({'withWho': widget.uid});
      Fluttertoast.showToast(msg: "Removed");
    } catch (e) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: "We had some problems with removing this relationship");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
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
    return SmallOulinedButtonWid(
      text: 'Remove',
      color: grey,
      borderRadius: 24,
      onPressFn: _removeFriend,
    );
  }
}
