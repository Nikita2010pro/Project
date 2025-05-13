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
    required this.fuelFee,
    required this.serviceFee,
  });

  double get totalCost => roomPrice + fuelFee + serviceFee;
}

// Константы стилей
const TextStyle headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo);
TextStyle subHeaderStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700]);
const TextStyle costTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green);

/// Виджет экрана бронирования
class BookingScreen extends StatelessWidget {
  final BookingData bookingData;

  const BookingScreen({Key? key, required this.bookingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Подтверждение бронирования'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HotelInfoSection(bookingData: bookingData),
            const SizedBox(height: 12),
            ImagesSection(images: bookingData.images),
            const SizedBox(height: 16),
            RoomDetailsSection(bookingData: bookingData),
            const SizedBox(height: 16),
            AdditionalFeesSection(bookingData: bookingData),
            const Divider(height: 24, thickness: 1, color: Colors.grey),
            TotalCostSection(totalCost: bookingData.totalCost),
            const SizedBox(height: 24),
            ConfirmButton(onPressed: () {
              // Реализуйте логику подтверждения бронирования
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Бронирование подтверждено!')),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Секция с информацией об отеле
class HotelInfoSection extends StatelessWidget {
  final BookingData bookingData;
  const HotelInfoSection({Key? key, required this.bookingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Отель: ${bookingData.hotelName}', style: headerStyle),
        Text('Город: ${bookingData.city}, ${bookingData.country}', style: subHeaderStyle),
        Text('Даты: ${bookingData.departureDate} - ${bookingData.returnDate} (${bookingData.nights} ночей)', style: subHeaderStyle),
      ],
    );
  }
}

// Секция с изображениями
class ImagesSection extends StatelessWidget {
  final List<String> images;
  const ImagesSection({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Секция с деталями номера
class RoomDetailsSection extends StatelessWidget {
  final BookingData bookingData;
  const RoomDetailsSection({Key? key, required this.bookingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Номер: ${bookingData.roomTitle}', style: subHeaderStyle),
        Text('Особенности: ${bookingData.roomFeatures}', style: subHeaderStyle),
        Text('Цена номера: ${bookingData.roomPrice.toStringAsFixed(0)} ₽', style: subHeaderStyle),
      ],
    );
  }
}

// Секция с дополнительными сборами
class AdditionalFeesSection extends StatelessWidget {
  final BookingData bookingData;
  const AdditionalFeesSection({Key? key, required this.bookingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Топливо: ${bookingData.fuelFee.toStringAsFixed(0)} ₽', style: subHeaderStyle),
        Text('Обслуживание: ${bookingData.serviceFee.toStringAsFixed(0)} ₽', style: subHeaderStyle),
      ],
    );
  }
}

// Секция общей стоимости
class TotalCostSection extends StatelessWidget {
  final double totalCost;
  const TotalCostSection({Key? key, required this.totalCost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Общая сумма: ${totalCost.toStringAsFixed(0)} ₽',
      style: costTextStyle,
    );
  }
}

// Кнопка подтверждения бронирования
class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ConfirmButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.indigo, // Цвет кнопки
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.black.withOpacity(0.3),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: const Text(
          'Подтвердить бронирование',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }
}
