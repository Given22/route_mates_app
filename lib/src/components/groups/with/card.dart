import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    var group = Provider.of<AsyncSnapshot<Group?>>(context);

    if (!group.hasData) {
      return Shimmer.fromColors(
        baseColor: darkGrey,
        highlightColor: grey2,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: darkGrey,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 5),
                blurRadius: 10,
              )
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  CustomText(
                    text: group.data!.public ? 'Public' : 'Private',
                    size: 16,
                    fontFamily: Fonts().secondary,
                    color: blueLink,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Picture(
                    photoUrl: DB().getPhotoUrl(
                        folder: DB().groupFolder, uid: group.data!.uid),
                    size: 120,
                    borderRadius: 16,
                    asset: DB().groupAsset,
                    shadowSize: 10,
                  ),
                ],
              ),
            ),
            group.data!.master == Auth().currentUser?.uid
                ? Positioned(
                    top: 9,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => context.push("/edit_group", extra: group),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: blueLink,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              offset: Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 14,
                          color: grey,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    width: 32,
                  ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        CustomText(
          text: group.hasData ? group.data!.name : '...',
          size: 20,
          weight: FontWeight.bold,
          color: grey,
        ),
        group.hasData
            ? group.data!.location != null
                ? CustomText(
                    text: group.data!.location!,
                    size: 16,
                    weight: FontWeight.normal,
                    fontFamily: Fonts().secondary,
                    color: blueLink,
                  )
                : const SizedBox()
            : CustomText(
                text: '...',
                size: 20,
                weight: FontWeight.normal,
                fontFamily: Fonts().secondary,
                color: blueLink,
              ),
      ],
    );
  }
}
