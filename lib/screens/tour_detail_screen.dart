import 'package:flutter/material.dart';
import '../models/tour.dart';

class TourDetailScreen extends StatelessWidget {
  final Tour tour;

  const TourDetailScreen({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отель')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение тура
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.network(
                tour.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            // Рейтинг
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text('${tour.rating} Превосходно', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Название и адрес
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                tour.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                tour.location,
                style: const TextStyle(color: Colors.blue),
              ),
            ),

            // Цена
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'от ${tour.price.toStringAsFixed(0)} ₽',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('за тур с перелётом'),
            ),

            const Divider(height: 32),

            // Инфо-иконки об отеле
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 10,
                children: [
                  _buildInfoChip(Icons.map, '3-я линия'),
                  _buildInfoChip(Icons.wifi, 'Платный Wi-Fi'),
                  _buildInfoChip(Icons.flight, tour.airportDistance),
                  _buildInfoChip(Icons.beach_access, tour.beachDistance),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Описание
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Об отеле',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                tour.description,
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const Divider(height: 32),

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

      // Кнопка "К выбору номера"
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            // TODO: переход на экран выбора номера
          },
          child: const Text('К выбору номера', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
