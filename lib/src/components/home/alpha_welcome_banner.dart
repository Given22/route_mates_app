import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AlphaWelcomeBanner extends StatelessWidget {
  const AlphaWelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final socialmediaLink = Config().getString("alpha_banner_socialmedia_link");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () async {
          if (socialmediaLink.isNotEmpty) {
            final Uri url = Uri.parse(socialmediaLink);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          }
        },
        child: Container(
          height: socialmediaLink.isEmpty ? 130 : 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: darkGrey2,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 5),
                blurRadius: 10,
              )
            ],
          ),
          child: Stack(children: [
            Positioned(
              left: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: Config().getString("HOME_PAGE_ALPHA_BANNER_HEADER"),
                      size: 16,
                      color: grey,
                      weight: FontWeight.w700,
                    ),
                    if (socialmediaLink.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      CustomText(
                        text: Config().getString("HOME_PAGE_ALPHA_BANNER_TEXT"),
                        size: 14,
                        color: grey2,
                        weight: FontWeight.normal,
                        fontFamily: Fonts().secondary,
                      )
                    ],
                  ],
                ),
              ),
            ),
            if (socialmediaLink.isEmpty)
              Positioned(
                bottom: 0,
                top: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: Config().getString("HOME_PAGE_ALPHA_BANNER_TEXT"),
                        size: 16,
                        color: grey2,
                        weight: FontWeight.normal,
                        fontFamily: Fonts().secondary,
                      )
                    ],
                  ),
                ),
              ),
            if (socialmediaLink.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        color: blueLink,
                      ),
                      CustomText(
                        text: 'social media',
                        color: blueLink,
                        size: 16,
                        fontFamily: Fonts().secondary,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(16)),
                child: SvgPicture.asset(
                  'assets/svgs/repair_car.svg',
                  height: 90,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
