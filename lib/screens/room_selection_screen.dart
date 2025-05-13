import 'package:flutter/material.dart';
import 'package:project/models/room_card.dart';

class RoomSelectionScreen extends StatelessWidget {
  const RoomSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор номера')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RoomCard(
            title: 'Стандартный номер с видом на бассейн',
            images: [
              'https://avatars.mds.yandex.net/get-altay/12813249/2a00000191c5df23708d1b7d6b96d25e6139/XXXL',
              'https://avatars.mds.yandex.net/i?id=9a6a409a96730e12067a70505c1f21f2_sr-3979482-images-thumbs&n=13',
            ],
            features: ['Включен только завтрак', 'Кондиционер'],
            price: 186600,
          ),
          const SizedBox(height: 24),
          RoomCard(
            title: 'Люкс с джакузи',
            images: [
              'https://avatars.mds.yandex.net/i?id=9a6a409a96730e12067a70505c1f21f2_sr-3979482-images-thumbs&n=13',
              'https://avatars.mds.yandex.net/get-altay/12813249/2a00000191c5df23708d1b7d6b96d25e6139/XXXL',
            ],
            features: ['Все включено', 'Собственный бассейн', 'Кондиционер'],
            price: 289000,
        
          ),
        ],
      ),
    );
  }
}
