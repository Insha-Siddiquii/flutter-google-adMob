import 'package:flutter/material.dart';
import 'package:flutter_inline_ads/helper/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsPage extends StatefulWidget {
  AdsPage({Key? key}) : super(key: key);

  @override
  _AdsPageState createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  int _kAdIndex = 8;
  late BannerAd _ad;
  late InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  bool _isAdLoaded = false;
  static final AdRequest request = AdRequest(
    keywords: <String>['flutter', 'ad'],
    contentUrl:
        'https://ionicframework.com/docs/v3/intro/tutorial/project-structure/',
    nonPersonalizedAds: true,
  );

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    _ad.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  _createBannerAd() {
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15 + (_isAdLoaded ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isAdLoaded && index == _kAdIndex) {
          return Container(
            child: AdWidget(ad: _ad),
            width: _ad.size.width.toDouble(),
            height: _ad.size.height.toDouble(),
            alignment: Alignment.center,
          );
        } else {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(
                Icons.ad_units,
                color: Colors.white,
              ),
            ),
            title: Text('${index + 1}: Ads List'),
            subtitle: Text('Place any subtitle'),
            onTap: _showInterstitialAd,
          );
        }
      },
    );
  }
}
