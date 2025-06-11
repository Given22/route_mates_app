import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/text_button.dart';
import 'package:route_mates/src/widgets/slide_page_route.dart';
import 'package:route_mates/src/screens/profile_subpages/garage/edit_vehicle_screen.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:shimmer/shimmer.dart';

class VehicleBox extends StatefulWidget {
  const VehicleBox({
    super.key,
    required this.uid,
    required this.name,
    this.description,
    required this.editable,
  });

  final String uid;
  final String name;
  final bool editable;
  final String? description;

  @override
  State<VehicleBox> createState() => _VehicleBoxState();
}

class _VehicleBoxState extends State<VehicleBox> {
  _showEditVehiclePage() {
    if (mounted && widget.editable) {
      context.pop();
      Navigator.push(
        context,
        slidePageRouteFromDown(
          EditVehicleScreen(
            uid: widget.uid,
            name: widget.name,
            description: widget.description,
          ),
        ),
      );
    }
  }

  _openVehicleDialog() {
    const borderRadius = 16.0;
    return showDialogSuper(
      barrierColor: Colors.black87,
      context: context,
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    color: darkGrey,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 10),
                        blurRadius: 10,
                      )
                    ],
                    borderRadius:
                        const BorderRadius.all(Radius.circular(borderRadius))),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius)),
                      child: FutureBuilder(
                          future: DB().getPhotoUrl(
                              folder: DB().vehicleFolder, uid: widget.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data!.isNotEmpty) {
                                return CachedNetworkImage(
                                  imageUrl: snapshot.data!,
                                  fit: BoxFit.cover,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  fadeInDuration:
                                      const Duration(milliseconds: 250),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: darkGrey,
                                    size: 24,
                                  ),
                                );
                              }
                              return Container(
                                decoration: BoxDecoration(color: darkBg2),
                                child: Center(
                                  heightFactor: 4,
                                  child: Icon(
                                    Icons.garage_rounded,
                                    color: darkGrey2,
                                    size: 32,
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height:
                                    MediaQuery.of(context).size.width * 0.45,
                                child: Shimmer.fromColors(
                                  baseColor: darkGrey,
                                  highlightColor: grey2,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: MediaQuery.of(context).size.width *
                                        0.45,
                                    color: darkGrey,
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: widget.name,
                            color: grey,
                            size: 16,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(
                            width: double.infinity,
                          ),
                          widget.description != null &&
                                  widget.description!.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CustomText(
                                    text: widget.description!,
                                    color: grey,
                                    size: 16,
                                    fontFamily: 'QuattrocentaSans',
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.editable)
                TextButtonWid(
                  onPressFn: _showEditVehiclePage,
                  text: 'Update vehicle',
                  textWeight: FontWeight.w600,
                  textColor: grey,
                )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openVehicleDialog,
      child: Container(
        width: 256,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: darkGrey,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  child: FutureBuilder(
                      future: DB().getPhotoUrl(
                          folder: DB().vehicleFolder, uid: widget.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data!.isNotEmpty) {
                            return CachedNetworkImage(
                              imageUrl: snapshot.data!,
                              fit: BoxFit.cover,
                              width: 256,
                              fadeInDuration: const Duration(milliseconds: 250),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: darkGrey,
                                size: 24,
                              ),
                            );
                          }
                          return Container(
                            decoration: BoxDecoration(color: darkBg2),
                            child: Center(
                              heightFactor: 4,
                              child: Icon(
                                Icons.garage_rounded,
                                color: darkGrey2,
                                size: 32,
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(
                            width: 256,
                            height: 228,
                            child: Shimmer.fromColors(
                              baseColor: darkGrey,
                              highlightColor: grey2,
                              child: Container(
                                width: 256,
                                height: 200,
                                color: darkGrey,
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: CustomText(
                text: widget.name,
                size: 14,
                color: grey,
                weight: FontWeight.w700,
                screenPartMaxWidth: 0.4,
              ),
            )
          ],
        ),
      ),
    );
  }
}
