import 'package:flutter/material.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class ProfileBox extends StatelessWidget {
  final String pictureSrc;
  final String name;
  const ProfileBox({super.key, required this.pictureSrc, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: Config().getString('HOME_PAGE_HELLO_TEXT'),
                  color: blueLink,
                  fontFamily: Fonts().secondary,
                  size: 22,
                ),
                CustomText(
                  text: name,
                  color: grey,
                  size: 20,
                  weight: FontWeight.w700,
                  screenPartMaxWidth: 0.5,
                )
              ],
            ),
          ),
          Picture(
            size: 80,
            borderRadius: 40,
            photoUrl: DB().getPhotoUrl(
              uid: Auth().currentUser!.uid,
              folder: DB().profileFolder,
            ),
            asset: DB().profileAsset,
          ),
        ],
      ),
    );
  }
}
