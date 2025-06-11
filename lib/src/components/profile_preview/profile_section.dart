import 'package:flutter/material.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/src/components/profile_preview/friendship_button_section.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key, required this.id});

  final String id;

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Store().getUser(widget.id),
      builder: (_, future) {
        if (future.connectionState != ConnectionState.done) {
          return const CircularLoadingIndicator(size: 48);
        }

        if (future.hasData) {
          return Column(
            children: [
              Picture(
                size: 110,
                borderRadius: 16,
                photoUrl: DB().getPhotoUrl(
                    folder: DB().profileFolder, uid: future.data!.uid),
                asset: DB().profileAsset,
                shadowSize: 6,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomText(
                text: future.data!.displayName,
                color: grey,
                size: 20,
                weight: FontWeight.w700,
              ),
              const SizedBox(
                height: 32,
              ),
              if (widget.id != Auth().currentUser?.uid)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: FriendshipButtonSection(userId: widget.id),
                ),
            ],
          );
        } else {
          return const CircularLoadingIndicator(size: 48);
        }
      },
    );
  }
}
