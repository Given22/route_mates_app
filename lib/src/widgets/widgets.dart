import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:shimmer/shimmer.dart';

class LongLogo extends StatelessWidget {
  final double size;
  const LongLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    // FlutterView view = PlatformDispatcher.instance.views.first;
    // double physicalWidth = view.physicalSize.width;
    // double devicePixelRatio = view.devicePixelRatio;
    // double screenWidth = physicalWidth / devicePixelRatio;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(
        'assets/svgs/new.svg',
        width: MediaQuery.of(context).size.width * size,
      ),
    );
  }
}

class Box extends StatelessWidget {
  final Widget child;
  final double? padding;
  const Box({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: darkGrey,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}

class Picture extends StatelessWidget {
  const Picture({
    super.key,
    required this.size,
    required this.borderRadius,
    required this.photoUrl,
    required this.asset,
    this.assetOpacity,
    this.shadowSize,
  });

  final double size;
  final double borderRadius;
  final Future<String> photoUrl;
  final String asset;
  final double? assetOpacity;
  final double? shadowSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: darkGrey5,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, shadowSize != null ? (shadowSize! / 2) : 2),
            blurRadius: shadowSize ?? 2,
          )
        ],
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: FutureBuilder(
              future: photoUrl,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data!.isNotEmpty) {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data!,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 250),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: darkGrey,
                      size: size / 2,
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: darkGrey,
                    highlightColor: grey2,
                    child: Container(
                      width: size,
                      height: size,
                      color: darkGrey,
                    ),
                  );
                } else {
                  return Image.asset(
                    asset,
                    fit: BoxFit.cover,
                    height: size,
                    width: size,
                    opacity: AlwaysStoppedAnimation(assetOpacity ?? 1),
                  );
                }
              }),
        ),
      ),
    );
  }
}

class UsersPhotosList extends StatelessWidget {
  const UsersPhotosList({
    super.key,
    required this.users,
    required this.count,
  });

  final List<String> users;
  final bool count;

  _friendsCount(num count) {
    final text = count > 99 ? '+99' : count.toString();

    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: darkGrey,
        border: Border.all(color: grey, width: 1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Center(
        child: CustomText(
          text: text,
          color: grey,
          size: count > 99 ? 15 : 16,
          weight: FontWeight.w500,
          fontFamily: Fonts().secondary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> usersList =
        users.sublist(0, users.length > 5 ? 5 : users.length).map(
      (e) {
        return Picture(
          photoUrl: DB().getPhotoUrl(folder: DB().profileFolder, uid: e),
          size: 40,
          borderRadius: 32,
          asset: DB().profileAsset,
        );
      },
    ).toList();

    usersList = [
      count ? _friendsCount(users.length) : const SizedBox(),
      ...usersList,
    ];

    return RowSuper(
      mainAxisSize: MainAxisSize.max,
      invert: true,
      innerDistance: -12.0,
      children: usersList,
    );
  }
}
