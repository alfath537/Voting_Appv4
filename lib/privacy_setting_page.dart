import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool location = false;
  bool camera = false;
  bool microphone = false;
  bool contact = false;

  BannerAd? myBannerAd;

  @override
  void initState() {
    super.initState();
    _setupFCM();
    _setupBannerAd();
  }

  // Firebase Cloud Messaging
  Future<void> _setupFCM() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      debugPrint('FCM Token: $token');
    } catch (e) {
      debugPrint('FCM setup error: $e');
    }
  }

  // Banner Ad setup
  void _setupBannerAd() {
    MobileAds.instance.initialize().then((_) {
      myBannerAd = BannerAd(
        adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Testing ID resmi
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) => debugPrint('Banner Ad loaded'),
          onAdFailedToLoad: (ad, err) {
            debugPrint('Banner Ad failed: $err');
            ad.dispose();
          },
        ),
      )..load();
      setState(() {});
    });
  }

  Future<void> _confirmToggle(String title, bool currentValue, Function(bool) onConfirmed) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm', style: TextStyle(fontFamily: 'PTSerif')),
        content: Text(
          'Are you sure you want to ${currentValue ? 'disable' : 'enable'} $title access?',
          style: const TextStyle(fontFamily: 'PTSerif'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(fontFamily: 'PTSerif')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes', style: TextStyle(fontFamily: 'PTSerif')),
          ),
        ],
      ),
    );

    if (result == true) {
      onConfirmed(!currentValue);
    }
  }

  void _saveChanges() {
    debugPrint(
        'Settings saved -> Location:$location, Camera:$camera, Mic:$microphone, Contact:$contact');

    FirebaseFirestore.instance.collection('user_settings').doc('user1').set({
      'location': location,
      'camera': camera,
      'microphone': microphone,
      'contact': contact,
      'updated_at': DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleLocationSwitch(bool newValue) async {
    if (newValue) {
      try {
        Location loc = Location();
        await loc.requestPermission();
        debugPrint('Location enabled');
      } catch (e) {
        debugPrint('Location error: $e');
      }
    }
  }

  Future<void> _handleCameraSwitch(bool newValue) async {
    if (newValue) {
      try {
        ImagePicker picker = ImagePicker();
        await picker.pickImage(source: ImageSource.camera);
        debugPrint('Camera enabled');
      } catch (e) {
        debugPrint('Camera error: $e');
      }
    }
  }

  Future<void> _handleContactSwitch(bool newValue) async {
    if (newValue) {
      try {
        await ContactsService.getContacts();
        debugPrint('Contacts access enabled');
      } catch (e) {
        debugPrint('Contacts error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Settings",
          style: TextStyle(fontFamily: 'PTSerif', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Location Access", style: TextStyle(fontFamily: 'PTSerif')),
              value: location,
              onChanged: (val) => _confirmToggle("Location", location, (newValue) {
                setState(() {
                  location = newValue;
                  _handleLocationSwitch(newValue);
                });
              }),
            ),
            SwitchListTile(
              title: const Text("Camera Access", style: TextStyle(fontFamily: 'PTSerif')),
              value: camera,
              onChanged: (val) => _confirmToggle("Camera", camera, (newValue) {
                setState(() {
                  camera = newValue;
                  _handleCameraSwitch(newValue);
                });
              }),
            ),
            SwitchListTile(
              title: const Text("Microphone Access", style: TextStyle(fontFamily: 'PTSerif')),
              value: microphone,
              onChanged: (val) => _confirmToggle("Microphone", microphone, (newValue) {
                setState(() => microphone = newValue);
              }),
            ),
            SwitchListTile(
              title: const Text("Contact Access", style: TextStyle(fontFamily: 'PTSerif')),
              value: contact,
              onChanged: (val) => _confirmToggle("Contact", contact, (newValue) {
                setState(() {
                  contact = newValue;
                  _handleContactSwitch(newValue);
                });
              }),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _saveChanges,
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(fontFamily: 'PTSerif'),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    side: const BorderSide(color: Colors.blueAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontFamily: 'PTSerif', color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Banner Ad
            if (myBannerAd != null)
              SizedBox(
                height: myBannerAd!.size.height.toDouble(),
                width: myBannerAd!.size.width.toDouble(),
                child: AdWidget(ad: myBannerAd!),
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    myBannerAd?.dispose();
    super.dispose();
  }
}
