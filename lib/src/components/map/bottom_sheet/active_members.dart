import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/list.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';
import 'package:route_mates/utils/map/control_map_service.dart';
import 'package:route_mates/utils/get_active_members.dart';
import 'package:route_mates/utils/profile/someone_profile_preview.dart';
import 'package:go_router/go_router.dart';

class ActiveMembers extends StatefulWidget {
  const ActiveMembers({
    super.key,
  });

  @override
  State<ActiveMembers> createState() => _ActiveMembersState();
}

class _ActiveMembersState extends State<ActiveMembers> {
  StreamSubscription<List<UserLocation>>? _subscription;
  List<UserLocation> activeMembers = [];
  late ControlMapService mapService;

  @override
  void didChangeDependencies() {
    if (_subscription != null) return;
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context);
    if (user.data != null &&
        _subscription == null &&
        user.data!.group.uid.isNotEmpty) {
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

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context);
    mapService = context.watch<ControlMapService>();

    if (user.connectionState != ConnectionState.active) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: LoadingIndicator(),
      );
    }

    Widget content() {
      if (user.data!.group.uid.isEmpty) {
        return SizedBox(
          height: 74,
          child: Center(
            child: CustomText(
              text: Config().getString("MAP_PAGE_SHEET_NOT_A_MEMBER"),
              color: grey2,
              align: TextAlign.center,
            ),
          ),
        );
      }
      if (activeMembers.isEmpty) {
        return SizedBox(
          height: 74,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.group_off_rounded,
                  color: blueLink,
                ),
                CustomText(
                  text:
                      Config().getString("MAP_PAGE_SHEET_EMPTY_ACTIVE_MEMBERS"),
                  fontFamily: Fonts().secondary,
                  color: blueLink,
                ),
              ],
            ),
          ),
        );
      } else {
        List<Widget> widgets = activeMembers.map((member) {
          return GestureDetector(
            onTap: () async {
              if (mounted) {
                context.pop();
                await mapService.goToUserLocation(
                    Position(member.lng, member.lat), context);
                if (context.mounted) {
                  SomeoneProfile().showDialogPreview(member.id, context,
                      barrierColor: Colors.transparent);
                }
              }
            },
            child: Picture(
              size: 60,
              borderRadius: 35,
              photoUrl:
                  DB().getPhotoUrl(folder: DB().profileFolder, uid: member.id),
              asset: DB().profileAsset,
            ),
          );
        }).toList();

        return Container(
          height: 74,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomHorizontalList(
            gap: 8,
            children: widgets,
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        content(),
      ],
    );
  }
}
