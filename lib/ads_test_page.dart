import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsTestPage extends StatefulWidget {
  const AdsTestPage({Key? key}) : super(key: key);

  @override
  _AdsTestPageState createState() => _AdsTestPageState();
}

class _AdsTestPageState extends State<AdsTestPage> {
  final myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(onAdLoaded: (a) {
      print(a);
    }),
  );

  Future<void> init() async {
    await myBanner.load();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('広告テスト'),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const Text('広告テスト！'),
              SizedBox(
                height: 64.0,
                width: double.infinity,
                child: AdWidget(ad: myBanner),
              ),
            ],
          );
        },
      ),
    );
  }
}
