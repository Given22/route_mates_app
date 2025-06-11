import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/list.dart';
import 'package:route_mates/src/widgets/listItems/public_group_listitem.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class PublicGroups extends StatefulWidget {
  const PublicGroups({super.key});

  @override
  State<PublicGroups> createState() => _PublicGroupsState();
}

class _PublicGroupsState extends State<PublicGroups> {
  String? _inputValue;
  int _limit = 15;

  _search(String input) {
    setState(() {
      _inputValue = input;
    });
  }

  _loading() {
    return const SizedBox(
      height: 50,
      child: Center(
        child: LoadingIndicator(),
      ),
    );
  }

  _list() {
    return StreamBuilder<List<Group>>(
      stream: Store()
          .firestore
          .collection('groups')
          .where('public', isEqualTo: true)
          .where('name',
              isGreaterThanOrEqualTo: '${_inputValue?.toUpperCase()}')
          .where('name',
              isLessThanOrEqualTo: '${_inputValue?.toLowerCase()}\uf8ff')
          .limit(_limit)
          .snapshots()
          .map(
        (event) {
          return event.docs.map((doc) => Group.fromFirebase(doc)).toList();
        },
      ),
      builder: (context, AsyncSnapshot<List<Group>> groupsSnapshot) {
        if (groupsSnapshot.connectionState == ConnectionState.none) {
          return SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: CustomText(
                align: TextAlign.center,
                text: "Something gone wrong",
                color: blueLink,
              ),
            ),
          );
        }

        if (groupsSnapshot.connectionState == ConnectionState.active ||
            groupsSnapshot.connectionState == ConnectionState.done) {
          List<Widget>? widgets = groupsSnapshot.data?.map((group) {
            final groupUid = group.uid;

            return FutureBuilder(
                future: Store()
                    .firestore
                    .collection('groups')
                    .doc(groupUid)
                    .collection('members')
                    .count()
                    .get(),
                builder:
                    (context, AsyncSnapshot<AggregateQuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return PublicGroupListItem(
                      uid: groupUid,
                      name: group.name,
                      location: group.location,
                      membersAmount: snapshot.data!.count,
                    );
                  }
                  return const SizedBox();
                });
          }).toList();

          if (widgets == null || widgets.isEmpty) {
            return SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: CustomText(
                  align: TextAlign.center,
                  text: Config().getString("WITHOUT_GROUP_NO_PUBLIC_GROUPS"),
                  color: grey2,
                ),
              ),
            );
          }

          if (widgets.length >= _limit) {
            widgets.add(
              TextButton(
                onPressed: () {
                  setState(() {
                    _limit += 10;
                  });
                },
                child: CustomText(
                  text: Config().getString("WITHOUT_GROUP_SHOW_MORE"),
                  color: grey2,
                  size: 14,
                  align: TextAlign.center,
                ),
              ),
            );
          }

          return CustomVerticalList(
            gap: 16,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            children: widgets,
          );
        }
        return _loading();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Public groups",
          color: grey,
          size: 18,
          weight: FontWeight.w700,
        ),
        const SizedBox(
          height: 8,
        ),
        Column(
          children: [
            TextInputBox(
              label: 'Search',
              validator: emptyInputValidator,
              keyboardType: TextInputType.name,
              onSubmit: _search,
            ),
            const SizedBox(
              height: 32,
            ),
            _list()
          ],
        ),
      ],
    );
  }
}
