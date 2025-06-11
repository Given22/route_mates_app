import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/utils/confirm_action_service.dart';

class GroupHeader extends StatefulWidget {
  const GroupHeader({super.key});

  @override
  State<GroupHeader> createState() => _GroupHeaderState();
}

class _GroupHeaderState extends State<GroupHeader> {
  String? _stage;

  _leaveGroup() async {
    try {
      await ConfirmAction().certify(() async {
        setState(() {
          _stage = "WAITING";
        });
        final result = await FBFunctions().leaveGroup.call();
        Fluttertoast.showToast(
            msg: result.data.toString(), toastLength: Toast.LENGTH_SHORT);
        setState(() {
          _stage = "DONE";
        });
      }, context);
    } catch (e) {
      setState(() {
        _stage = "ERROR";
      });
    } finally {
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _stage = null;
          });
        }
      });
    }
  }

  _closeGroup() async {
    var group = Provider.of<AsyncSnapshot<Group?>>(context, listen: false);
    if (!group.hasData) {
      return;
    }
    try {
      await ConfirmAction().certify(() async {
        setState(() {
          _stage = "WAITING";
        });
        final result =
            await FBFunctions().removeGroup.call({'groupId': group.data!.uid});
        Fluttertoast.showToast(msg: result.data.toString());
        setState(() {
          _stage = "DONE";
        });
      }, context);
    } catch (e) {
      setState(() {
        _stage = "ERROR";
      });
      Fluttertoast.showToast(msg: "We had some problem with closing the group");
    } finally {
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _stage = null;
          });
        }
      });
    }
  }

  iconButton(void Function()? noPress, IconData icon) {
    if (_stage == "WAITING") {
      return const SizedBox(
        width: 48,
        child: Center(child: CircularLoadingIndicator(size: 16)),
      );
    } else if (_stage == "DONE") {
      return SizedBox(
        width: 48,
        child: Center(
          child: Icon(
            Icons.check_rounded,
            color: grey,
            size: 24,
          ),
        ),
      );
    } else if (_stage == "ERROR") {
      return SizedBox(
        width: 48,
        child: Center(
          child: Icon(
            Icons.close_rounded,
            color: redLight,
            size: 24,
          ),
        ),
      );
    }
    return IconButton(
      onPressed: noPress,
      splashRadius: 24,
      splashColor: darkBlue,
      icon: Icon(
        icon,
        color: grey,
        size: 24,
      ),
    );
  }

  _closeButton() {
    return iconButton(_closeGroup, Icons.group_off_rounded);
  }

  _leaveButton() {
    return iconButton(_leaveGroup, Icons.logout_rounded);
  }

  @override
  Widget build(BuildContext context) {
    var group = Provider.of<AsyncSnapshot<Group?>>(context);
    var user = Provider.of<AsyncSnapshot<User?>>(context);

    if (!group.hasData && !user.hasData) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            group.hasData && user.hasData
                ? group.data!.master == user.data!.uid
                    ? _closeButton()
                    : _leaveButton()
                : const SizedBox(
                    width: 48,
                  ),
          ],
        ),
        group.hasData && group.data!.key != null
            ? GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: group.data!.key!));
                  Fluttertoast.showToast(
                      msg: 'Copied', toastLength: Toast.LENGTH_SHORT);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: CustomText(
                    text: group.data!.key!,
                    size: 20,
                    weight: FontWeight.bold,
                    color: orange,
                    fontFamily: Fonts().roboto,
                    letterSpacing: 2.5,
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: CustomText(
                  text: 'Loading...',
                  size: 16,
                  weight: FontWeight.bold,
                  color: blueLink,
                ),
              ),
        const SizedBox(
          width: 48,
        ),
      ],
    );
  }
}
