import 'package:flutter/material.dart';
import '../models/tour.dart';

class TourDetailScreen extends StatelessWidget {
  final Tour tour;

  const TourDetailScreen({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tour.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(tour.imageUrl),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(tour.description, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}