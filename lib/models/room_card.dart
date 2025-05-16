import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:project/models/booking_data.dart';
import 'package:project/models/hotel.dart';
import 'package:project/screens/booking_screen.dart';
import 'package:project/screens/date_picker_dialog.dart';


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
          widget.images.isNotEmpty
              ? SizedBox(
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
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.broken_image)),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                      );
                    },
                  ),
                )
              : Center(child: Text('no_images').tr()),
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
            label: Text(_showDetails ? 'hide_description'.tr() : 'more_about_room'.tr()),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(fontSize: 14),
            ),
          ),

          // Описание
          if (_showDetails)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.description,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ),

          const SizedBox(height: 8),

          // Цена
          Text(
            'from_price'.tr(args: [widget.price.toStringAsFixed(0)]),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('for_7_nights_with_flight',style: TextStyle(color: Colors.grey, fontSize: 13),).tr(),
          const SizedBox(height: 12),

          // Кнопка выбора
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
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('select_room').tr(),
            ),
          ),
        ],
      ),
    );
  }
}
