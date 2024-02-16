import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rev_fb_app/helpers/fb_helper.dart';

class AdHelper {
  AdHelper._();
  static final AdHelper adHelper = AdHelper._();

  late BannerAd bannerAd;
  late InterstitialAd interstitialAd;
  late AppOpenAd appOpenAd;

  bool appOpenAdLoaded = false;

  Future<void> loadBannerAd() async {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: await FbHelper.fbHelper.getAdId(
        adType: AdType.bannerAd,
      ),
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
      adUnitId: await FbHelper.fbHelper.getAdId(
        adType: AdType.interstitialAd,
      ),
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

  Future<void> loadAppOpenAd() async {
    await AppOpenAd.load(
      adUnitId: await FbHelper.fbHelper.getAdId(
        adType: AdType.appOpenAd,
      ),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          appOpenAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          log("AOD error: ${error.message}");
        },
      ),
      orientation: AppOpenAd.orientationPortrait,
    );
  }
}
