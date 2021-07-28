import 'package:flutter/material.dart';
import 'package:flutter_inline_ads/ads/ads_inline_page.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Flutter In-line Ads',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: AdsPage(),
    );
  }
}
