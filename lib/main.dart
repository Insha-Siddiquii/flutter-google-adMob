import 'package:flutter/material.dart';
import 'package:flutter_inline_ads/home/home.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initGoogleMobileAds();
  runApp(MyApp());
}

Future<InitializationStatus> initGoogleMobileAds() async {
  return MobileAds.instance.initialize();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Inline Ads',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: Home());
  }
}
