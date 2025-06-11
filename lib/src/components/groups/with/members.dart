import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/list.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class GroupMembers extends StatefulWidget {
  const GroupMembers({super.key});

  static const size = 60.0;

  @override
  State<GroupMembers> createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  _showAddVehiclePage() {
    var group = Provider.of<AsyncSnapshot<Group?>>(context, listen: false);
    context.push('/groupMembers', extra: group);
  }

  @override
  Widget build(BuildContext context) {
    var members = Provider.of<List<Member>>(context);

    List<Member> newMembers = [...members];

    newMembers.removeWhere(
      (element) => element.uid == Auth().currentUser!.uid,
    );

    List<Widget> widgets = newMembers.map((member) {
      return GestureDetector(
        onTap: () => context.push('/users/${member.uid}'),
        child: Picture(
          photoUrl:
              DB().getPhotoUrl(folder: DB().profileFolder, uid: member.uid),
          asset: DB().profileAsset,
          size: GroupMembers.size,
          borderRadius: 32,
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Route Mates',
              size: 18,
              weight: FontWeight.bold,
              color: grey,
            ),
            TextButton(
              onPressed: _showAddVehiclePage,
              child: CustomText(
                text: 'see all',
                color: blueLink,
                size: 18,
                weight: FontWeight.bold,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        newMembers.isEmpty
            ? SizedBox(
                height: GroupMembers.size,
                child: Center(
                  child: CustomText(
                    text: Config().getString("WITH_GROUP_ALONE"),
                    size: 16,
                    color: blueLink,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CustomHorizontalList(
                  gap: 8,
                  children: widgets,
                ),
              )
      ],
    );
  }
}
