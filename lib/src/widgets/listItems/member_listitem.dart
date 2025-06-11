import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/small_outlined_button.dart';

import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class MemberListItem extends StatefulWidget {
  const MemberListItem({
    super.key,
    required this.uid,
    required this.name,
    required this.groupId,
    required this.canRemove,
  });

  final String uid;
  final String name;
  final String groupId;
  final bool canRemove;

  @override
  State<MemberListItem> createState() => _MemberListItemState();
}

class _MemberListItemState extends State<MemberListItem> {
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
            children: [
              Picture(
                photoUrl: DB().getPhotoUrl(
                  folder: DB().profileFolder,
                  uid: widget.uid,
                ),
                asset: DB().profileAsset,
                size: 48,
                borderRadius: 8,
                shadowSize: 10,
              ),
              const SizedBox(
                width: 8,
              ),
              CustomText(
                text: widget.name,
                color: grey,
                screenPartMaxWidth: 0.4,
              ),
            ],
          ),
        ),
        if (widget.canRemove)
          ButtonsSection(
            remove: () async {
              await FBFunctions()
                  .removeGroupMember
                  .call({'groupId': widget.groupId, 'userId': widget.uid});
            },
          ),
      ],
    );
  }
}

class ButtonsSection extends StatefulWidget {
  const ButtonsSection({
    super.key,
    required this.remove,
  });

  final Future<void> Function() remove;

  @override
  State<ButtonsSection> createState() => _ButtonsSectionState();
}

class _ButtonsSectionState extends State<ButtonsSection> {
  bool loading = false;

  _remove() async {
    setState(() {
      loading = true;
    });
    await widget.remove();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      FlutterView view = PlatformDispatcher.instance.views.first;
      double physicalWidth = view.physicalSize.width;
      double devicePixelRatio = view.devicePixelRatio;
      double screenWidth = physicalWidth / devicePixelRatio;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 45,
            width: screenWidth * 0.2,
            child: const LoadingIndicator(),
          ),
        ],
      );
    }

    return SmallOulinedButtonWid(
        text: 'Remove', color: grey, borderRadius: 24, onPressFn: _remove);
  }
}
