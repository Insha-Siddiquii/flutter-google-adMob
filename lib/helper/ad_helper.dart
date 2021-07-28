import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'add your android banner inline ad ID';
    } else if (Platform.isIOS) {
      return 'add your ios banner inline ad ID';
    }
    throw new UnsupportedError("Unsupported platform");
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'add your android interstitial ad ID';
    } else if (Platform.isIOS) {
      return 'add your ios interstitial ad ID';
    }
    throw new UnsupportedError("Unsupported platform");
  }
}
