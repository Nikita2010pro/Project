import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:project/models/tourist.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> booking;
  final String bookingId;

  const BookingDetailsScreen({
    super.key,
    required this.booking,
    required this.bookingId,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  String? selectedTouristId;
  Tourist? selectedTourist;

  void _loadTouristData(String touristId) async {
    final doc = await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.bookingId)
        .collection('tourists')
        .doc(touristId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        selectedTourist = Tourist(
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          birthDate: (data['birthDate'] as Timestamp?)?.toDate(),
          citizenship: data['citizenship'] ?? '',
          passportNumber: data['passportNumber'] ?? '',
          passportExpiry: (data['passportExpiry'] as Timestamp?)?.toDate(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final createdAt = (booking['createdAt'] as Timestamp?)?.toDate();
    final formattedDate = createdAt != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(createdAt)
        : tr('bookingDetails.no_date');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(tr('bookingDetails.booking_details'),
        style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 26,
            color: Theme.of(context).colorScheme.onBackground,
            shadows: [
              const Shadow(blurRadius: 4, offset: Offset(1, 1), color: Colors.black45),
            ],
          ),
          ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildBackground(
        context,
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoText(tr('bookingDetails.email'), booking['email']),
                _infoText(tr('bookingDetails.booking_date'), formattedDate),
                _infoText(tr('bookingDetails.hotel'), booking['hotelTitle']),
                _infoText(tr('bookingDetails.room_type'), booking['roomTitle']),
                _infoText(tr('bookingDetails.total_cost'), '${booking['totalCost']} ₽'),
                const Divider(height: 32),

                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('bookings')
                      .doc(widget.bookingId)
                      .collection('tourists')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text(tr('bookingDetails.error_loading_tourists'));
                    }
                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return Text(tr('bookingDetails.no_tourists'));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr('bookingDetails.select_tourist'),
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedTouristId,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(0.9),
                          ),
                          items: docs.map((doc) {
                            final firstName = doc['firstName'] ?? '';
                            final lastName = doc['lastName'] ?? '';
                            return DropdownMenuItem<String>(
                              value: doc.id,
                              child: Text('$firstName $lastName'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedTouristId = value;
                              });
                              _loadTouristData(value);
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),

                if (selectedTourist != null) ...[
                  const SizedBox(height: 12),
                  _infoText(tr('bookingDetails.first_name'), selectedTourist!.firstName),
                  _infoText(tr('bookingDetails.last_name'), selectedTourist!.lastName),
                  _infoText(
                    tr('bookingDetails.birth_date'),
                    selectedTourist!.birthDate != null
                        ? DateFormat('dd.MM.yyyy').format(selectedTourist!.birthDate!)
                        : tr('bookingDetails.not_specified'),
                  ),
                  _infoText(tr('bookingDetails.citizenship'), selectedTourist!.citizenship),
                  _infoText(tr('bookingDetails.passport_number'), selectedTourist!.passportNumber),
                  _infoText(
                    tr('bookingDetails.passport_expiry'),
                    selectedTourist!.passportExpiry != null
                        ? DateFormat('dd.MM.yyyy').format(selectedTourist!.passportExpiry!)
                        : tr('bookingDetails.not_specified'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Общий фон с затемнением
  Widget _buildBackground(BuildContext context, Widget child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            isDark
                ? 'assets/images/background_dark.jpg'
                : 'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(isDark ? 0.6 : 0.3),
          ),
        ),
        SafeArea(
        child: SizedBox.expand(  // добавляем SizedBox.expand
          child: child,
        ),
      ),
      ],
    );
  }

  Widget _infoText(String title, String? value) {
    if (value == null || value.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '$title: $value',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
