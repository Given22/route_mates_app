import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/src/widgets/buttons/small_solid_button.dart';
import 'package:route_mates/utils/map/background_sharing_service.dart';
import 'package:route_mates/utils/confirm_action_service.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';

class SharingButton extends StatefulWidget {
  const SharingButton({super.key});

  @override
  State<SharingButton> createState() => _SharingButtonState();
}

class _SharingButtonState extends State<SharingButton> {
  InterstitialAd? _interstitialAd;

  int count = 0;

  String _adUnitId = Platform.isAndroid
      ? AdsIDs().offline_fullscreen_android
      : AdsIDs().offline_fullscreen_ios;

  Future _loadAd() async {
    assert(() {
      _adUnitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
      return true;
    }());

    await _interstitialAd?.dispose();
    _interstitialAd = null;

    await InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
          );
          _interstitialAd = ad;
          _interstitialAd?.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          count++;
          if (count < 3) {
            _loadAd();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context);

    if (user.hasData && user.data!.group.uid.isEmpty) {
      return const SizedBox();
    }

    var bgService = Provider.of<BackgroundSharingService>(context);

    bool running = bgService.isRunning;
    bool sharing = bgService.isSharing;

    toggleService() async {
      if (await bgService.isServiceAlreadyRunning) {
        if (context.mounted) {
          await ConfirmAction().certify(() {
            bgService.service.invoke('stopService');
            _loadAd();
          }, context);
        }
      } else {
        await bgService.runSharingService();
      }
    }

    Widget liveButton() {
      return SmallSolidButton(
        text: '● Live',
        bgColor: redLight,
        color: grey,
        onPressFn: () => toggleService(),
      );
    }

    Widget offlineButton() {
      return SmallSolidButton(
        text: 'Offline',
        bgColor: darkGrey3,
        color: blueLink,
        onPressFn: () => toggleService(),
      );
    }

    Widget loadingIndicator() {
      return GestureDetector(
        onTap: () => toggleService(),
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: darkGrey,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: CircularLoadingIndicator(
            size: 16,
            color: blueLink,
          ),
        ),
      );
    }

    if (sharing) {
      return liveButton();
    }
    if (running) {
      return loadingIndicator();
    }
    return offlineButton();
  }
}
