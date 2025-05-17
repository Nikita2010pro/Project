import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HotelMapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String hotelName;

  const HotelMapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.hotelName,
  });

  @override
  Widget build(BuildContext context) {
    final point = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(title: Text('on_the_map'.tr())),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: point,
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: point,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
