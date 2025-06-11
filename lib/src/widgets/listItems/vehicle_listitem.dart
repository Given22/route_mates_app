import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class VehicleListItem extends StatefulWidget {
  const VehicleListItem(
      {super.key, required this.vehicle, required this.isActive});

  final Vehicle vehicle;
  final bool isActive;

  @override
  State<VehicleListItem> createState() => _VehicleListItemState();
}

class _VehicleListItemState extends State<VehicleListItem> {
  @override
  Widget build(BuildContext context) {
    String name;
    if (widget.vehicle.name.length > 16 && widget.vehicle.name.length <= 32) {
      name =
          '${widget.vehicle.name.substring(0, 16)}\n${widget.vehicle.name.substring(16, widget.vehicle.name.length)}';
    } else {
      name = widget.vehicle.name.substring(0, widget.vehicle.name.length);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 60,
              width: 60 * 1.4,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: darkGrey3,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 5),
                    blurRadius: 10,
                  )
                ],
              ),
              child: widget.vehicle.uid != ""
                  ? FutureBuilder(
                      future: DB().getPhotoUrl(
                          folder: DB().vehicleFolder, uid: widget.vehicle.uid),
                      builder:
                          (BuildContext context, AsyncSnapshot<String> future) {
                        if (future.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularLoadingIndicator(
                              size: 16,
                            ),
                          );
                        }
                        if (future.data! == '') {
                          return Center(
                            child: Icon(
                              Icons.directions_car_filled_rounded,
                              color: blueLink,
                              size: 28,
                            ),
                          );
                        }
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            color: darkBg,
                            image: future.data! != ''
                                ? DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      future.data!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(
                        Icons.directions_car_filled_rounded,
                        color: blueLink,
                        size: 28,
                      ),
                    ),
            ),
            const SizedBox(
              width: 16,
            ),
            CustomText(
              text: name,
              color: grey,
              weight: FontWeight.w500,
              fontFamily: Fonts().secondary,
            )
          ],
        ),
        widget.isActive
            ? TextButton(
                onPressed: () async {
                  await Store().updateActiveVehicle(vehicleId: '');
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: CustomText(
                  text: "Leave",
                  color: grey2,
                  weight: FontWeight.bold,
                ),
              )
            : TextButton(
                onPressed: () async {
                  await Store()
                      .updateActiveVehicle(vehicleId: widget.vehicle.uid);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: CustomText(
                  text: "Choose",
                  color: grey2,
                  weight: FontWeight.bold,
                ),
              )
      ],
    );
  }
}
