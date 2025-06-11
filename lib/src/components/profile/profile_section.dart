import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context);

    if (user.hasData) {
      return Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Picture(
                  size: 120,
                  borderRadius: 16,
                  photoUrl: DB().getPhotoUrl(
                      folder: DB().profileFolder, uid: user.data!.uid),
                  asset: DB().profileAsset,
                  shadowSize: 6,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => context.push("/edit_profile"),
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
              ),
            ],
          ),
          CustomText(
            text: user.data!.displayName,
            color: grey,
            size: 20,
            weight: FontWeight.w700,
          )
        ],
      );
    } else {
      return const CircularLoadingIndicator(size: 48);
    }
  }
}
