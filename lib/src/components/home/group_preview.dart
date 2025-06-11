import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/wide_solid_button.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';
import 'package:route_mates/utils/get_active_members.dart';

class GroupPreview extends StatefulWidget {
  const GroupPreview({super.key, required this.setActiveIndex});

  final void Function(int) setActiveIndex;

  @override
  State<GroupPreview> createState() => _GroupPreviewState();
}

class _GroupPreviewState extends State<GroupPreview> {
  StreamSubscription<List<UserLocation>>? _subscription;
  List<UserLocation> activeMembers = [];

  @override
  void didChangeDependencies() {
    if (_subscription != null) return;
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context);
    if (user.data != null && _subscription == null) {
      _subscription = GetActiveMembers()
          .activeMembersListStream(user.data!.group.uid)
          .listen((event) {
        setState(() {
          activeMembers = event;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  Widget _loading() {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: LoadingIndicator(),
    );
  }

  Widget _head() {
    return Row(
      children: [
        CustomText(
          text: 'Your group',
          size: 18,
          weight: FontWeight.bold,
          color: grey,
        )
      ],
    );
  }

  Widget _withOutGroup() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          _head(),
          const SizedBox(height: 24),
          Opacity(
            opacity: 0.9,
            child: SvgPicture.asset(
              'assets/svgs/alone.svg',
              height: 90,
            ),
          ),
          const SizedBox(height: 8),
          CustomText(
            text: Config().getString("HOME_PAGE_GROUP_NOT_A_MEMBER"),
            color: grey2,
            fontFamily: Fonts().secondary,
          ),
          const SizedBox(height: 24),
          BigSolidButton(
            borderRadius: 10,
            text: "Groups",
            buttonColor: darkGrey2,
            textColor: grey2,
            onPressFn: () => widget.setActiveIndex(1),
            height: 40,
            textWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }

  Widget _activeMembers() {
    if (activeMembers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.group_off_rounded,
                color: blueLink,
              ),
              CustomText(
                text: Config().getString("HOME_PAGE_GROUP_NO_ACTIVE_MEMBERS"),
                color: blueLink,
                weight: FontWeight.bold,
              ),
            ],
          ),
        ),
      );
    } else {
      List<String> activeMembersUids =
          activeMembers.map((member) => member.id).toList();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            UsersPhotosList(
              users: activeMembersUids,
              count: false,
            ),
            const SizedBox(height: 8),
            CustomText(
              text:
                  "${activeMembersUids.length} active route mate${activeMembersUids.length > 1 ? "s" : ""}",
              color: grey2,
              fontFamily: Fonts().secondary,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context);

    if (user.hasData) {
      if (user.data!.group.uid.isEmpty) {
        return _withOutGroup();
      }
      return StreamBuilder(
          stream: Store().groupDataStream(user.data!.group.uid),
          builder: (context, stream) {
            if (!stream.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    _head(),
                    _loading(),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  _head(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                    child: GestureDetector(
                      onTap: () => widget.setActiveIndex(1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Picture(
                            size: 80,
                            borderRadius: 8,
                            photoUrl: DB().getPhotoUrl(
                              uid: user.data!.group.uid,
                              folder: DB().groupFolder,
                            ),
                            asset: DB().groupAsset,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomText(
                                  text: stream.data!.name,
                                  color: grey,
                                  size: 17,
                                  weight: FontWeight.bold,
                                ),
                                if (stream.data!.location != null &&
                                    stream.data!.location!.isNotEmpty)
                                  CustomText(
                                    text: stream.data!.location!,
                                    color: grey2,
                                    size: 15,
                                    fontFamily: Fonts().secondary,
                                  ),
                                CustomText(
                                  text: stream.data!.public
                                      ? "public"
                                      : "private",
                                  color: blueLink,
                                  size: 16,
                                  fontFamily: Fonts().secondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _activeMembers(),
                ],
              ),
            );
          });
    } else if (user.data == null) {
      return CustomText(
        text: Config().getString("HOME_PAGE_GROUP_NO_DATA"),
        color: grey,
      );
    } else {
      return _loading();
    }
  }
}
