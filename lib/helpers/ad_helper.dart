import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  AdHelper._() {
    loadBannerAd();
    loadInterstitialAd();
  }
  static final AdHelper adHelper = AdHelper._();

  late BannerAd bannerAd;
  late InterstitialAd interstitialAd;

  Future<void> loadBannerAd() async {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log("Banner ad loaded...");
        },
        onAdFailedToLoad: (ad, error) {
          log("BANNER AD ERROR: ${error.message}");
        },
      ),
      request: const AdRequest(),
    );
    await bannerAd.load();
  }

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/8691691433",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          log("INTERSTITIAL ERROR: ${error.message}");
        },
      ),
    );
  }
}
