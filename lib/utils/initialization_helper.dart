import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

class GDPR {
  bool _shouldLoad() {
    bool load = true;

    assert(() {
      load = false;
      return true;
    }());

    return load;
  }

  Future<FormError?> initialize() async {
    final completer = Completer<FormError?>();
    if (_shouldLoad()) {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          await _loadConsentForm();
        } else {
          await _initialize();
        }

        completer.complete();
      }, (error) {
        completer.complete(error);
      });
    } else {
      completer.complete();
    }
    return completer.future;
  }

  Future<FormError?> _loadConsentForm() async {
    final completer = Completer<FormError?>();

    ConsentForm.loadConsentForm((consentForm) async {
      final status = await ConsentInformation.instance.getConsentStatus();
      if (status == ConsentStatus.required) {
        consentForm.show((formError) {
          completer.complete(_loadConsentForm());
        });
      } else {
        await _initialize();
        completer.complete();
      }
    }, (FormError? error) {
      completer.complete(error);
    });

    return completer.future;
  }

  Future<bool> changePrivacyPreferences() async {
    final completer = Completer<bool>();

    ConsentInformation.instance
        .requestConsentInfoUpdate(ConsentRequestParameters(), () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        ConsentForm.loadConsentForm((consentForm) {
          consentForm.show((formError) async {
            await _initialize();
            completer.complete(true);
          });
        }, (formError) {
          completer.complete(false);
        });
      } else {
        completer.complete(false);
      }
    }, (error) {
      completer.complete(false);
    });

    return completer.future;
  }

  Future<void> _initialize() async {
    await MobileAds.instance.initialize();
  }
}
