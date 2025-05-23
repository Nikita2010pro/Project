import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:project/screens/account/booking_details_screen.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print('Current userId: ${user?.uid}');

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('my_bookings'.tr())),
        body: Center(child: Text('not_logged_in'.tr())),
      );
    }

    final bookingsRef = FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: user.uid);

    return Scaffold(
      appBar: AppBar(title: Text('my_bookings'.tr())),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookingsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('no_bookings'.tr()));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final createdAt = (booking['createdAt'] as Timestamp?)?.toDate();

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('email'.tr() + ": ${booking['email']}"),
                  subtitle: Text(createdAt != null
                      ? '${'date'.tr()}: ${DateFormat('dd.MM.yyyy HH:mm').format(createdAt)}'
                      : 'no_date'.tr()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsScreen(
                          booking: booking.data() as Map<String, dynamic>,
                          bookingId: booking.id,
                        ),
                      ),
                    );
                  },
                  onLongPress: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('bookingScreen.delete_booking'.tr()),
                        content: Text('bookingScreen.confirm_delete_booking'.tr()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('bookingScreen.cancel'.tr()),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('bookingScreen.delete'.tr()),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await FirebaseFirestore.instance
                          .collection('bookings')
                          .doc(booking.id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('bookingScreen.booking_deleted'.tr())),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
