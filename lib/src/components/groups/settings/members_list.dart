import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/list.dart';
import 'package:route_mates/src/widgets/listItems/member_listitem.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class MembersList extends StatefulWidget {
  const MembersList({
    super.key,
    required this.groupId,
    required this.isMaster,
  });

  final String groupId;
  final bool isMaster;

  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  final formKey = GlobalKey<FormState>();

  String _inputValue = '';
  int _limit = 15;
  List<String> gotRequests = [];
  List<String> sendRequests = [];
  List<String> friends = [];

  _search(String input) {
    setState(() {
      _inputValue = input;
    });
  }

  _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomText(
            text: 'Members',
            color: grey,
            size: 18,
            weight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {
            context.go('/main', extra: 0);
          },
          iconSize: 30,
          splashRadius: 24,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: grey,
          ),
        ),
      ],
    );
  }

  _membersList() {
    return StreamBuilder(
      stream: Store()
          .firestore
          .collection('groups')
          .doc(widget.groupId)
          .collection('members')
          .where('name', isGreaterThanOrEqualTo: _inputValue.toUpperCase())
          .where('name',
              isLessThanOrEqualTo: '${_inputValue.toLowerCase()}\uf8ff')
          .limit(_limit)
          .snapshots()
          .map((event) {
        return event.docs.map((doc) => Member.fromFirestore(doc)).toList();
      }),
      builder: (context, memberSnapshot) {
        if (memberSnapshot.connectionState == ConnectionState.none) {
          return SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: CustomText(
                align: TextAlign.center,
                text: Config().getString("MEMBERS_PAGE_ERROR"),
                color: blueLink,
              ),
            ),
          );
        }

        if (memberSnapshot.connectionState == ConnectionState.active ||
            memberSnapshot.connectionState == ConnectionState.done) {
          if (memberSnapshot.hasData) {
            var members = memberSnapshot.data as List<Member>;

            members
                .removeWhere((member) => member.uid == Auth().currentUser!.uid);

            if (members.isEmpty) {
              return CustomText(
                text: "We can't find any member",
                size: 16,
                color: blueLink,
                align: TextAlign.center,
              );
            }

            List<Widget> widgets = members.map((member) {
              final memberUid = member.uid;
              final memberName = member.name;

              return MemberListItem(
                uid: memberUid,
                name: memberName,
                groupId: widget.groupId,
                canRemove: widget.isMaster,
              );
            }).toList();

            if (members.length == _limit) {
              widgets.add(
                TextButton(
                  onPressed: () {
                    setState(() {
                      _limit += 10;
                    });
                  },
                  child: CustomText(
                    text: Config().getString("MEMBERS_PAGE_SHOW_MORE"),
                    color: blueLight2,
                    size: 14,
                    align: TextAlign.center,
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomVerticalList(
                gap: 16,
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                children: widgets,
              ),
            );
          }
        }

        return const LoadingIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(),
        const SizedBox(
          height: 8,
        ),
        TextInputBox(
          onSubmit: _search,
          label: 'Find member by name',
          keyboardType: TextInputType.name,
          validator: emptyInputValidator,
        ),
        const SizedBox(
          height: 32,
        ),
        _membersList(),
      ],
    );
  }
}
