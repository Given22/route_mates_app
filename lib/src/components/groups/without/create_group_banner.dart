import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:shimmer/shimmer.dart';

class CreateGroupBanner extends StatefulWidget {
  const CreateGroupBanner({super.key});

  @override
  State<CreateGroupBanner> createState() => _CreateGroupBannerState();
}

class _CreateGroupBannerState extends State<CreateGroupBanner> {
  _goToCreateGroupPage() {
    context.go('/createGroup');
  }

  _wantToCreateGroup() {
    if (!mounted) return;

    if (_failed) {
      _goToCreateGroupPage();
      return;
    }
    _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      _goToCreateGroupPage();
    });
  }

  int _count = 0;
  bool _failed = false;
  RewardedAd? _rewardedAd;

  String _adUnitId = Platform.isAndroid
      ? REWARD_AD_CREATE_GROUP_ID_ANDROID
      : REWARD_AD_CREATE_GROUP_ID_IOS;

  @override
  void initState() {
    super.initState();

    _loadAd();
  }

  /// Loads a rewarded ad.
  void _loadAd() {
    assert(() {
      _adUnitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
      return true;
    }());

    setState(() {
      _failed = false;
    });

    RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {},
            onAdImpression: (ad) {},
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdClicked: (ad) {},
          );
          if (mounted) {
            setState(() {
              _rewardedAd = ad;
            });
          }
        }, onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _count++;
          });
          if (_count <= 1) {
            _loadAd();
          } else {
            setState(() {
              _failed = true;
            });
          }
        }));
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_failed && _rewardedAd == null) {
      return Shimmer.fromColors(
        baseColor: darkGrey,
        highlightColor: darkBlue,
        child: Container(
          height: 100,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: darkGrey,
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(0, 3),
                blurRadius: 5,
              ),
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: _wantToCreateGroup,
      child: Container(
        height: 100,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: darkGrey,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(45, 0, 0, 0),
              offset: Offset(0, 1),
              blurRadius: 7,
            ),
          ],
        ),
        child: Stack(children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: Config().getString("WITHOUT_GROUP_BANNER_HEADER"),
                    size: 18,
                    color: grey2,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.smart_display_rounded,
                        color: blueLink,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: Config().getString("WITHOUT_GROUP_BANNER_FOOTER"),
                        color: blueLink,
                        size: 15,
                        fontFamily: Fonts().secondary,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/svgs/trip.svg',
              height: 70,
            ),
          ),
        ]),
      ),
    );
  }
}
