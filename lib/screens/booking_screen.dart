import 'package:flutter/material.dart';

// Модель данных для бронирования
class BookingData {
  final String hotelName;
  final String city;
  final String country;
  final String departureDate;
  final String returnDate;
  final int nights;

  final String roomTitle;
  final String roomFeatures;
  final double roomPrice;
  final List<String> images;

  final String tourTitle;
  final double tourPrice;

  final double fuelFee;
  final double serviceFee;

  BookingData({
    required this.hotelName,
    required this.city,
    required this.country,
    required this.departureDate,
    required this.returnDate,
    required this.nights,
    required this.roomTitle,
    required this.roomFeatures,
    required this.roomPrice,
    required this.images,
    required this.tourTitle,
    required this.tourPrice,
    required this.fuelFee,
    required this.serviceFee,
  });
}

// Ваш виджет экрана бронирования
class BookingScreen extends StatelessWidget {
  final BookingData bookingData;

  const BookingScreen({Key? key, required this.bookingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalCost = bookingData.roomPrice + bookingData.tourPrice + bookingData.fuelFee + bookingData.serviceFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Подтверждение бронирования'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация о отеле/номере
            Text(
              'Отель: ${bookingData.hotelName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Город: ${bookingData.city}, ${bookingData.country}'),
            Text('Даты: ${bookingData.departureDate} - ${bookingData.returnDate} (${bookingData.nights} ночей)'),
            const SizedBox(height: 12),

            // Изображения
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: bookingData.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        bookingData.images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Детали номера
            Text(
              'Номер: ${bookingData.roomTitle}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text('Особенности: ${bookingData.roomFeatures}'),
            Text('Цена номера: ${bookingData.roomPrice.toStringAsFixed(0)} ₽'),

            const SizedBox(height: 16),

            // Информация о туре
            Text(
              'Тур: ${bookingData.tourTitle}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text('Цена тура: ${bookingData.tourPrice.toStringAsFixed(0)} ₽'),

            const SizedBox(height: 16),

            // Дополнительные сборы
            Text('Топливо: ${bookingData.fuelFee.toStringAsFixed(0)} ₽'),
            Text('Обслуживание: ${bookingData.serviceFee.toStringAsFixed(0)} ₽'),

            const Divider(height: 24, thickness: 1),

            // Общая стоимость
            Text(
              'Общая сумма: ${totalCost.toStringAsFixed(0)} ₽',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            // Кнопка подтверждения
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Тут можете реализовать логику подтверждения бронирования
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Бронирование подтверждено!')),
                  );
                },
                child: const Text(
                  'Подтвердить бронирование',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}