import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';
import 'package:route_mates/utils/view.dart';

class SomeoneProfile {
  double? _getWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ViewOrientation().isPortrait(context) ? null : width * 0.5;
  }

  AlignmentGeometry? _getAligment(BuildContext context) {
    return ViewOrientation().isPortrait(context)
        ? Alignment.topCenter
        : Alignment.topLeft;
  }

  Future<void> showDialogPreview(String uid, BuildContext context,
      {Color barrierColor = Colors.transparent}) async {
    await showDialog<bool>(
      barrierColor: barrierColor,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          context.pop();
        },
        onVerticalDragUpdate: (_) {
          context.pop();
        },
        onHorizontalDragUpdate: (_) {
          context.pop();
        },
        child: Dialog(
          alignment: _getAligment(context),
          insetPadding: const EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          child: FutureBuilder(
              future: Store().getUser(uid),
              builder: (_, user) {
                if (user.connectionState == ConnectionState.waiting) {
                  return Container(
                    decoration: BoxDecoration(
                      color: darkGrey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: 80,
                    width: _getWidth(context),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: LoadingIndicator(),
                      ),
                    ),
                  );
                }
                if (!user.hasData) {
                  return SizedBox(
                    height: 80,
                    width: _getWidth(context),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomText(
                          text: "We had some problem\nWe cannot find this user",
                          color: blueLink,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () {
                    context.pop();
                    context.push('/users/$uid');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: darkGrey,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    width: _getWidth(context),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Picture(
                                size: 100,
                                borderRadius: 8,
                                photoUrl: DB().getPhotoUrl(
                                    folder: DB().profileFolder, uid: uid),
                                asset: DB().profileAsset,
                                shadowSize: 10,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              CustomText(
                                text: user.data!.displayName,
                                weight: FontWeight.bold,
                                color: grey,
                                size: 18,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [],
                              ),
                              if (user.data!.activeVehicle != "")
                                const SizedBox(
                                  height: 12,
                                ),
                              if (user.data!.activeVehicle != "")
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60 * 1.4,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        color: darkGrey,
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
                                                  uid:
                                                      user.data!.activeVehicle),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      future) {
                                                if (future.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularLoadingIndicator(
                                                      size: 16,
                                                    ),
                                                  );
                                                }
                                                if (future.data! == '') {
                                                  return Center(
                                                    child: Icon(
                                                      Icons
                                                          .directions_car_filled_rounded,
                                                      color: blueLink,
                                                      size: 28,
                                                    ),
                                                  );
                                                }
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(6)),
                                                    color: darkBg,
                                                    image: future.data! != ''
                                                        ? DecorationImage(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                                    future
                                                                        .data!),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : null,
                                                  ),
                                                );
                                              },
                                            )
                                          : Center(
                                              child: Icon(
                                                Icons
                                                    .directions_car_filled_rounded,
                                                color: blueLink,
                                                size: 28,
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (user
                                              .data!.activeVehicle.isNotEmpty)
                                            FutureBuilder(
                                                future: Store().getVehicle(uid,
                                                    user.data!.activeVehicle),
                                                builder: (_, vehicle) {
                                                  if (vehicle.connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const SizedBox(
                                                        width: 30,
                                                        height: 10,
                                                        child:
                                                            LoadingIndicator());
                                                  }

                                                  if (vehicle.connectionState ==
                                                          ConnectionState
                                                              .none ||
                                                      !vehicle.hasData) {
                                                    return CustomText(
                                                      text: "No active vehicle",
                                                      color: blueLink,
                                                      fontFamily:
                                                          Fonts().secondary,
                                                    );
                                                  }

                                                  String n = vehicle.data!.name;

                                                  String name;
                                                  if (n.length > 16 &&
                                                      n.length <= 32) {
                                                    name =
                                                        '${n.substring(0, 16)}\n${n.substring(16, n.length)}';
                                                  } else {
                                                    name = n.substring(
                                                        0, n.length);
                                                  }

                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        CustomText(
                                                          text: name,
                                                          color: grey2,
                                                          align: TextAlign.end,
                                                          fontFamily:
                                                              Fonts().secondary,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                })
                                          else
                                            CustomText(
                                              text: "No active vehicle",
                                              color: blueLink,
                                              fontFamily: Fonts().secondary,
                                            )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
