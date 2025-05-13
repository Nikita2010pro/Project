import 'package:flutter/material.dart';
import 'package:project/screens/booking_screen.dart';


class RoomCard extends StatefulWidget {
  final String title;
  final List<String> images;
  final List<String> features;
  final double price;

  const RoomCard({
    Key? key,
    required this.title,
    required this.images,
    required this.features,
    required this.price,
  });


  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool _showDetails = false;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 📸 Вот тут находится PageView
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.images[index],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
          const SizedBox(height: 12),

          // Название
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          // Характеристики
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: widget.features
                .map((f) => Chip(
                      label: Text(f),
                      backgroundColor: Colors.grey.shade200,
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // Кнопка раскрытия описания
          TextButton.icon(
            onPressed: () {
              setState(() {
                _showDetails = !_showDetails;
              });
            },
            icon: Icon(
              _showDetails ? Icons.expand_less : Icons.info_outline,
              size: 18,
            ),
            label: Text(_showDetails ? 'Скрыть описание' : 'Подробнее о номере'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(fontSize: 14),
            ),
          ),

          // Описание
          if (_showDetails)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Просторный номер с панорамными окнами, большой кроватью и джакузи. Идеален для отдыха вдвоем. В номере есть телевизор, сейф, мини-бар и бесплатный Wi-Fi.',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
            ),

          const SizedBox(height: 8),

          // Цена
          Text(
            'от ${widget.price.toStringAsFixed(0)} ₽',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            'За 7 ночей с перелетом',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),

          // Кнопка выбора
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
    // Собираем данные для бронирования
final bookingData = BookingData(
      hotelName: widget.title,
      city: 'Москва', // или из переменных
      country: 'Россия',
      departureDate: '2024-05-01', // ваши даты
      returnDate: '2024-05-10',
      nights: 9,
      roomTitle: widget.title,
      roomFeatures: widget.features.join(', '),
      roomPrice: widget.price,
      images: widget.images,
      tourTitle: 'Название тура', // если есть
      tourPrice: 50000,
      fuelFee: 2000,
      serviceFee: 3000,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingScreen(bookingData: bookingData),
      ),
    );
  },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Выбрать номер'),
            ),
          ),
        ],
      ),
    );
  }
}
