import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/friendships.dart';
import 'package:route_mates/data/requests.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/outlined_button.dart';
import 'package:route_mates/src/widgets/buttons/wide_solid_button.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class FriendshipButtonSection extends StatefulWidget {
  const FriendshipButtonSection({super.key, required this.userId});

  final String userId;

  @override
  State<FriendshipButtonSection> createState() => _FriendshipButtonState();
}

class _FriendshipButtonState extends State<FriendshipButtonSection> {
  bool _isLoading = false;

  List<String> sendRequests = [];

  List<String> gotRequests = [];

  List<String> friends = [];

  _loading() {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Center(
        child: LinearProgressIndicator(
          color: orange,
          backgroundColor: grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> sendRequests =
        Provider.of<List<SendRequest>>(context).map((e) => e.uid).toList();

    List<String> gotRequests =
        Provider.of<List<GotRequest>>(context).map((e) => e.userUid).toList();

    List<String> friends =
        Provider.of<List<Friend>>(context).map((e) => e.uid).toList();

    if (friends.contains(widget.userId)) {
      return OutlinedButtonWid(
          height: 42,
          width: double.infinity,
          text: "Remove",
          color: blueLink,
          textWeight: FontWeight.bold,
          borderRadius: 12,
          onPressFn: () async {
            setState(() {
              _isLoading = true;
            });
            try {
              await FBFunctions()
                  .removeFriendship
                  .call({'withWho': widget.userId});
            } on FirebaseFunctionsException {
              Fluttertoast.showToast(msg: "Remove failed");
            }
            setState(() {
              _isLoading = false;
            });
          });
    } else if (gotRequests.contains(widget.userId)) {
      return BigSolidButton(
        borderRadius: 12,
        text: "Accept",
        buttonColor: Colors.green,
        textColor: darkGrey,
        textWeight: FontWeight.bold,
        onPressFn: () async {
          setState(() {
            _isLoading = true;
          });
          try {
            await FBFunctions()
                .acceptFriendship
                .call({'withWho': widget.userId});
          } on FirebaseFunctionsException {
            Fluttertoast.showToast(msg: "Acceptation failed");
          }
          setState(() {
            _isLoading = false;
          });
        },
        height: 42,
      );
    } else if (sendRequests.contains(widget.userId)) {
      return Container(
        height: 42,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: grey, width: 2),
        ),
        child: Center(
          child: CustomText(
            text: 'Invited',
            size: 16,
            color: grey,
          ),
        ),
      );
    } else if (_isLoading) {
      return _loading();
    } else {
      return BigSolidButton(
        borderRadius: 12,
        text: "Invite",
        buttonColor: orange,
        textColor: darkGrey,
        textWeight: FontWeight.bold,
        onPressFn: () async {
          setState(() {
            _isLoading = true;
          });
          try {
            await FBFunctions()
                .invitePerson
                .call(<String, dynamic>{'to': widget.userId});
          } on FirebaseFunctionsException {
            Fluttertoast.showToast(msg: "Invitation failed");
          }
          setState(() {
            _isLoading = false;
          });
        },
        height: 42,
      );
    }
  }
}
