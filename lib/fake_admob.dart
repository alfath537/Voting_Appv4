// ignore_for_file: avoid_print
import 'package:flutter/material.dart';

/// Fake classes untuk Banner Ad (untuk testing di Windows, Android, iOS)
/// Tidak menampilkan iklan asli, hanya placeholder.

class BannerAd {
  final String adUnitId;
  final AdSize size;
  final AdRequest request;
  final BannerAdListener listener;

  BannerAd({
    required this.adUnitId,
    required this.size,
    required this.request,
    required this.listener,
  });

  void load() {
    debugPrint('Fake BannerAd load called');
    listener.onAdLoaded(this);
  }

  void dispose() {
    debugPrint('Fake BannerAd disposed');
  }
}

class AdSize {
  final int width;
  final int height;
  const AdSize.banner() : width = 320, height = 50;
}

class AdRequest {
  const AdRequest();
}

class BannerAdListener {
  final void Function(BannerAd) onAdLoaded;
  final void Function(BannerAd, Object) onAdFailedToLoad;

  BannerAdListener({required this.onAdLoaded, required this.onAdFailedToLoad});
}

class AdWidget extends StatelessWidget {
  final BannerAd ad;
  const AdWidget({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    // Menampilkan container placeholder untuk banner
    return Container(
      color: Colors.grey[300],
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      alignment: Alignment.center,
      child: const Text(
        'Banner Ad Placeholder',
        style: TextStyle(color: Colors.black54),
      ),
    );
  }
}
