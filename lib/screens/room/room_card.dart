import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:project/models/booking_data.dart';
import 'package:project/models/hotel.dart';
import 'package:project/screens/booking/booking_screen.dart';
import 'package:project/screens/booking/date_picker_dialog.dart';

class RoomCard extends StatefulWidget {
  final Hotel hotel;
  final String title;
  final List<String> images;
  final List<String> features;
  final double price;
  final String description;

  const RoomCard({
    Key? key,
    required this.hotel,
    required this.title,
    required this.images,
    required this.features,
    required this.price,
    required this.description,
  }) : super(key: key);

  @override
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black54 : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Карусель изображений
          widget.images.isNotEmpty
              ? SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          widget.images[index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.broken_image)),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                      );
                    },
                  ),
                )
              : Center(child: Text('no_images'.tr())),
          const SizedBox(height: 14),

          // Название
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          // Удобства
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: widget.features
                .map((f) => Chip(
                      label: Text(f),
                      backgroundColor: isDark ? Colors.grey[800] : Colors.blueGrey[50],
                      labelStyle: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),

          // Кнопка описания
          TextButton.icon(
            onPressed: () => setState(() => _showDetails = !_showDetails),
            icon: Icon(
              _showDetails ? Icons.expand_less : Icons.info_outline,
              size: 18,
            ),
            label: Text(
              _showDetails ? 'hide_description'.tr() : 'more_about_room'.tr(),
              style: const TextStyle(fontSize: 14),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.teal,
              padding: EdgeInsets.zero,
            ),
          ),

          // Описание (анимированное появление)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showDetails ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                widget.description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Цена
          Text(
            'from_price'.tr(args: [widget.price.toStringAsFixed(0)]),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'for_7_nights_with_flight',
            style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[700]),
          ).tr(),

          const SizedBox(height: 16),

          // Кнопка выбора номера
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final selectedRange = await showDateRangePickerDialog(context);
                if (selectedRange == null) return;

                final nights = selectedRange.duration.inDays;
                final extraNights = nights > 7 ? nights - 7 : 0;
                final extraNightsCost = extraNights * 5000;

                final bookingData = BookingData(
                  hotelName: widget.hotel.title,
                  country: widget.hotel.location,
                  departureDate: selectedRange.start.toIso8601String().split('T').first,
                  returnDate: selectedRange.end.toIso8601String().split('T').first,
                  nights: nights,
                  roomTitle: widget.title,
                  roomFeatures: widget.features.join(', '),
                  roomPrice: widget.price,
                  images: widget.images,
                  fuelFee: 2000,
                  serviceFee: 3000,
                  extraNightsCost: extraNightsCost,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(bookingData: bookingData),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: Text(
                'select_room'.tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
