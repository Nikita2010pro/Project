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
      appBar: AppBar(
        title: Text(tr('bookingDetails.booking_details')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (booking['email'] != null)
                Text('${tr('bookingDetails.email')}: ${booking['email']}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('${tr('bookingDetails.booking_date')}: $formattedDate'),
              const SizedBox(height: 8),
              if (booking['hotelTitle'] != null)
                Text('${tr('bookingDetails.hotel')}: ${booking['hotelTitle']}'),
              if (booking['roomTitle'] != null)
                Text('${tr('bookingDetails.room_type')}: ${booking['roomTitle']}'),
              if (booking['totalCost'] != null)
                Text('${tr('bookingDetails.total_cost')}: ${booking['totalCost']} ₽'),
              const Divider(height: 32),

              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(widget.bookingId)
                    .collection('tourists')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text(tr('bookingDetails.error_loading_tourists'));
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return Text(tr('bookingDetails.no_tourists'));
                  }

                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: tr('bookingDetails.select_tourist')),
                    value: selectedTouristId,
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
                  );
                },
              ),

              if (selectedTourist != null) ...[
                const SizedBox(height: 16),
                Text('${tr('bookingDetails.first_name')}: ${selectedTourist!.firstName}', style: const TextStyle(fontSize: 16)),
                Text('${tr('bookingDetails.last_name')}: ${selectedTourist!.lastName}', style: const TextStyle(fontSize: 16)),
                Text(
                  '${tr('bookingDetails.birth_date')}: ${selectedTourist!.birthDate != null ? DateFormat('dd.MM.yyyy').format(selectedTourist!.birthDate!) : tr('bookingDetails.not_specified')}',
                ),
                Text('${tr('bookingDetails.citizenship')}: ${selectedTourist!.citizenship}'),
                Text('${tr('bookingDetails.passport_number')}: ${selectedTourist!.passportNumber}'),
                Text(
                  '${tr('bookingDetails.passport_expiry')}: ${selectedTourist!.passportExpiry != null ? DateFormat('dd.MM.yyyy').format(selectedTourist!.passportExpiry!) : tr('bookingDetails.not_specified')}',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
