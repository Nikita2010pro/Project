import 'package:flutter/material.dart';
import 'package:project/data/room_selection_screen.dart';
import '../models/hotel.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel tour;

  const HotelDetailScreen({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Информация об отеле')),
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
                      Text(
                        '${tour.rating} Превосходно',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
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
                    Text(
                      'от ${tour.price.toStringAsFixed(0)} ₽',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text('за тур с перелётом', style: TextStyle(fontSize: 13)),
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
                  _buildInfoChip(Icons.map, tour.features.isNotEmpty ? tour.features[0] : 'Инфо'),
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
                  const Text(
                    'Об отеле',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                children: const [
                  ExpansionTile(
                    title: Text('Удобства'),
                    children: [ListTile(title: Text('Самое необходимое'))],
                  ),
                  ExpansionTile(
                    title: Text('Что включено'),
                    children: [ListTile(title: Text('Перелёт, трансфер, питание'))],
                  ),
                  ExpansionTile(
                    title: Text('Что не включено'),
                    children: [ListTile(title: Text('Экскурсии и доп.услуги'))],
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
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const RoomSelectionScreen()),
  );
},
          child: const Text(
            'К выбору номера',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
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
