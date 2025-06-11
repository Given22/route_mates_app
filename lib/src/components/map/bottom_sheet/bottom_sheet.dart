import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/src/components/map/bottom_sheet/active_vehicle.dart';
import 'package:route_mates/src/components/map/bottom_sheet/active_members.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/utils/get_active_members.dart';
import 'package:route_mates/utils/map/control_map_service.dart';
import 'package:route_mates/utils/view.dart';

class BottomPanel extends StatefulWidget {
  const BottomPanel({
    super.key,
  });

  @override
  State<BottomPanel> createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  late ControlMapService mapService;
  DraggableScrollableController sheetController =
      DraggableScrollableController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void getActiveMembers() {
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context, listen: false);
    if (user.data == null) return;
    if (user.data!.group.uid.isEmpty) return;

    GetActiveMembers().activeMembersList(user.data!.group.uid).then((value) {
      if (value.isNotEmpty) {
        if (mounted) {
          sheetController.animateTo(
              ViewOrientation().pixelsToHeightPercent(150),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCirc);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getActiveMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    mapService = context.watch<ControlMapService>();

    double min = ViewOrientation().pixelsToHeightPercent(35);
    double snap = ViewOrientation().pixelsToHeightPercent(150);
    double max = ViewOrientation().pixelsToHeightPercent(280);

    return DraggableScrollableSheet(
        initialChildSize: min,
        minChildSize: min,
        maxChildSize: max,
        snapSizes: [snap],
        snap: true,
        controller: sheetController,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: darkGrey,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 27,
                    child: Center(
                      child: Container(
                        height: 6,
                        width: MediaQuery.of(context).size.width * 0.33,
                        decoration: BoxDecoration(
                          color: grey,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const ActiveMembers(),
                  const SizedBox(
                    height: 16,
                  ),
                  const ActiveVehicle(),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
