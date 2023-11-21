import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String label;

  const MapScreen({super.key, required this.latitude, required this.longitude, required this.label});

  Future<void> _openMap() async {
    var googleUrl = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving&dir_action=navigate';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Impossible de lancer Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ouvrir dans Google Maps'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _openMap,
          child: Text('Aller à $label'),
        ),
      ),
    );
  }
}
