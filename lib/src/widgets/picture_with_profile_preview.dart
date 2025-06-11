import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/utils/profile/someone_profile_preview.dart';
import 'package:shimmer/shimmer.dart';

class PictureWithProfilePreview extends StatelessWidget {
  const PictureWithProfilePreview({
    super.key,
    required this.size,
    required this.borderRadius,
    required this.photoUrl,
    required this.asset,
    required this.userId,
    required this.previewBackground,
    this.assetOpacity,
    this.shadowSize,
  });

  final double size;
  final double borderRadius;
  final Future<String> photoUrl;
  final String asset;
  final String userId;
  final bool previewBackground;
  final double? assetOpacity;
  final double? shadowSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SomeoneProfile().showDialogPreview(userId, context,
            barrierColor:
                previewBackground ? Colors.black45 : Colors.transparent);
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: darkGrey,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
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
                      width: size,
                      height: size,
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
      ),
    );
  }
}
