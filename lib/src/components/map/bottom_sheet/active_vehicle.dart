import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/screens/profile_subpages/garage/new_vehicle_screen.dart';
import 'package:route_mates/src/widgets/buttons/wide_solid_button.dart';
import 'package:route_mates/src/widgets/listItems/vehicle_listitem.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/slide_page_route.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:shimmer/shimmer.dart';

class ActiveVehicle extends StatefulWidget {
  const ActiveVehicle({super.key});

  @override
  State<ActiveVehicle> createState() => _ActiveVehicleState();
}

class _ActiveVehicleState extends State<ActiveVehicle> {
  openBottomModal(AsyncSnapshot<UserStore?> user) async {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: darkGrey,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                StreamBuilder(
                    stream: Store().garageStream,
                    builder: (_, streamData) {
                      if (streamData.connectionState !=
                          ConnectionState.active) {
                        return const Center(child: LoadingIndicator());
                      }

                      List<Widget>? vehicles = streamData.data?.map((vehicle) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: VehicleListItem(
                            vehicle: vehicle,
                            isActive: vehicle.uid == user.data!.activeVehicle,
                          ),
                        );
                      }).toList();

                      if (vehicles == null || vehicles.isEmpty) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.garage_rounded,
                                    color: grey2,
                                    size: 32,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  CustomText(
                                    text: "Your garage is empty",
                                    color: grey2,
                                    weight: FontWeight.w500,
                                    fontFamily: Fonts().secondary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            BigSolidButton(
                              borderRadius: 12,
                              text: 'Add your first vehicle',
                              buttonColor: orange,
                              textColor: darkBg,
                              onPressFn: () {
                                Navigator.push(
                                    context,
                                    slidePageRouteFromDown(
                                        const NewVehicleScreen()));
                              },
                              textWeight: FontWeight.bold,
                              height: 40,
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          CustomText(
                            text: 'Choose vehicle from your garage',
                            color: grey,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [...vehicles],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context);

    if (user.connectionState == ConnectionState.active && user.data != null) {
      var garage = Provider.of<List<Vehicle>>(context);

      final vehicle = garage.singleWhere(
        (element) => element.uid == user.data!.activeVehicle,
        orElse: () => Vehicle(name: "unknown", uid: "unknown"),
      );

      String name;
      if (vehicle.name.length > 16 && vehicle.name.length <= 32) {
        name =
            '${vehicle.name.substring(0, 16)}\n${vehicle.name.substring(16, vehicle.name.length)}';
      } else {
        name = vehicle.name.substring(0, vehicle.name.length);
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 60,
                  width: 60 * 1.4,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: darkGrey2,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 5),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: user.data!.activeVehicle != ""
                      ? FutureBuilder(
                          future: DB().getPhotoUrl(
                              folder: DB().vehicleFolder,
                              uid: user.data!.activeVehicle),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> future) {
                            if (future.connectionState ==
                                ConnectionState.waiting) {
                              return Shimmer.fromColors(
                                baseColor: darkGrey,
                                highlightColor: grey2,
                                child: Container(
                                  height: 60,
                                  width: 60 * 1.4,
                                  color: darkGrey,
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6)),
                                color: darkGrey,
                                image: future.data! != ''
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            future.data!),
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
                  text: name == 'unknown' ? 'No active\nvehicle' : name,
                  color: user.data!.activeVehicle == "" ? grey2 : grey,
                  fontFamily: Fonts().secondary,
                )
              ],
            ),
            TextButton(
              onPressed: () => openBottomModal(user),
              child: CustomText(
                text: user.data!.activeVehicle == "" ? "Choose" : "Change",
                color: grey2,
                weight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      );
    }
    return const Center(
      child: CircularLoadingIndicator(
        size: 16,
      ),
    );
  }
}
