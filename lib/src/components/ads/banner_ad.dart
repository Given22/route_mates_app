import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/utils/view.dart';

class MyBannerAd extends StatefulWidget {
  const MyBannerAd({super.key, required this.setAdLoaded});

  final Function setAdLoaded;

  @override
  State<MyBannerAd> createState() => _BannerAdState();
}

class _BannerAdState extends State<MyBannerAd> {
  BannerAd? _bannerAd;
  int failedCount = 0;
  int cpmLevel = 0;

  Timer? _bannerTimer;

  void _loadAd(AdSize addSize) async {
    List<String> adUnitIds = Platform.isAndroid
        ? AdsIDs().map_banner_android
        : AdsIDs().map_banner_ios;

    String adUnitId = adUnitIds[cpmLevel];

    assert(() {
      adUnitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
      return true;
    }());

    BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: addSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          widget.setAdLoaded(true);
          setState(() {
            _bannerAd = ad as BannerAd;
            failedCount = 0;
            cpmLevel = 0;
          });
        },
        onAdClosed: (ad) {
          ad.dispose();
          widget.setAdLoaded(false);
        },
        onAdWillDismissScreen: (ad) {
          ad.dispose();
          widget.setAdLoaded(false);
        },
        onAdFailedToLoad: (ad, err) {
          widget.setAdLoaded(false);

          _bannerAd?.dispose();
          _bannerAd = null;

          setState(() {
            failedCount++;
          });

          if ((failedCount == 2 && cpmLevel == (adUnitIds.length - 1)) ||
              err.code == 1) {
            _bannerTimer = Timer(const Duration(minutes: 3), () {
              if (mounted) {
                setState(() {
                  failedCount = 0;
                  cpmLevel = 0;
                });
                _loadAd(AdSize(
                    width: ViewOrientation().width().truncate(), height: 60));
              }
            });
            return;
          }
          if (err.code == 3) {
            if (failedCount < 2) {
              _loadAd(ViewOrientation().width() >= 450
                  ? AdSize.fullBanner
                  : AdSize.banner);
            } else {
              setState(() {
                failedCount = 0;
                if (cpmLevel < (adUnitIds.length - 1)) {
                  cpmLevel++;
                }
              });
              _loadAd(AdSize(
                  width: ViewOrientation().width().truncate(), height: 60));
            }
          }
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void initState() {
    super.initState();
    _loadAd(AdSize(width: ViewOrientation().width().truncate(), height: 60));
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null) {
      return SafeArea(
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: 60,
          child: Center(child: AdWidget(ad: _bannerAd!)),
        ),
      );
    }
    return const SizedBox();
  }
}
