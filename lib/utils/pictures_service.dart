import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image/image.dart' as img;
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/src/const.dart';
import 'package:screenshot/screenshot.dart';

class Pictures {
  ScreenshotController screenshotController = ScreenshotController();

  Widget getMarkerWidget(String url, bool darkMode) {
    const double w = 200;
    const double h = 220;
    const double borderSize = 40;

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        children: [
          Positioned(
            child: SvgPicture.asset(
              'assets/svgs/pin.svg',
              width: w,
              height: h,
              colorFilter:
                  ColorFilter.mode(darkMode ? grey : darkGrey, BlendMode.srcIn),
            ),
          ),
          Positioned(
            top: borderSize / 2,
            left: borderSize / 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(w / 2),
                child: Container(
                  color: darkMode ? grey2 : darkGrey3,
                  child: url != ""
                      ? Image.network(
                          url,
                          fit: BoxFit.cover,
                          height: w - borderSize,
                          width: w - borderSize,
                        )
                      : Image.asset(
                          DB().profileAsset,
                          fit: BoxFit.cover,
                          height: w - borderSize,
                          width: w - borderSize,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> getMarkerIntList(
      String id, bool darkmode, int width, int height) async {
    final url = await DB().getPhotoUrl(folder: DB().profileFolder, uid: id);

    final capturedImage = await screenshotController
        .captureFromWidget(getMarkerWidget(url, darkmode));

    final Uint8List list = _resize(capturedImage, width, height);
    return list;
  }

  Uint8List _resize(Uint8List data, int width, int height) {
    Uint8List resizeddata = data;

    img.Image? i = img.decodeImage(data);

    if (i == null) return resizeddata;

    img.Image resized = img.copyResize(i, width: width, height: height);

    final result = Uint8List.fromList(img.encodePng(resized));
    return result;
  }
}
