import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/hotel/hotel_map_screen.dart';
import '../../models/hotel.dart';
import 'package:project/screens/room/room_selection_screen.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel tour;

  const HotelDetailScreen({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('hotel_info'.tr())),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.network(
                tour.imageUrl,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            // Название, рейтинг и адрес
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('${tour.rating} ${'excellent'.tr()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tour.location,
                    style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
                  ),
                ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HotelMapScreen(
                          latitude: tour.latitude,
                          longitude: tour.longitude,
                          hotelName: tour.title,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.map),
                  label: Text('view_on_the_map'.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Цена
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${'from'.tr()} ${tour.price.toStringAsFixed(0)} ${'currency_ruble'.tr()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('per_tour_with_flight'.tr(), style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Характеристики
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  _buildInfoChip(Icons.map, tour.features.isNotEmpty ? tour.features[0] : 'info'.tr()),
                  if (tour.features.length > 1) _buildInfoChip(Icons.wifi, tour.features[1]),
                  _buildInfoChip(Icons.flight_takeoff, tour.airportDistance),
                  _buildInfoChip(Icons.beach_access, tour.beachDistance),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Описание
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('about_hotel'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    tour.description,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Аккордеоны
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  ExpansionTile(
                    title: Text('amenities'.tr()),
                    children: [ListTile(title: Text('basics'.tr()))],
                  ),
                  ExpansionTile(
                    title: Text('included'.tr()),
                    children: [ListTile(title: Text('flight_transfer_meals'.tr()))],
                  ),
                  ExpansionTile(
                    title: Text('not_included'.tr()),
                    children: [ListTile(title: Text('excursions_additional_services'.tr()))],
                  ),

                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // Кнопка внизу
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => RoomSelectionScreen(hotel: tour), // где tour — это Hotel
  ),
);
          },
          child: Text('to_room_selection'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
