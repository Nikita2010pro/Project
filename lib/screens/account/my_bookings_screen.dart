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


    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('my_bookings'.tr(),
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
          Center(child: Text('not_logged_in'.tr())),
        ),
      );
    }

    final bookingsRef = FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: user.uid);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('my_bookings'.tr(),
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
        StreamBuilder<QuerySnapshot>(
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
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final createdAt = (booking['createdAt'] as Timestamp?)?.toDate();

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      'email'.tr() + ": ${booking['email']}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      createdAt != null
                          ? '${'date'.tr()}: ${DateFormat('dd.MM.yyyy HH:mm').format(createdAt)}'
                          : 'no_date'.tr(),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => BookingDetailsScreen(
                            booking: booking.data() as Map<String, dynamic>,
                            bookingId: booking.id,
                          ),
                          transitionsBuilder: (_, animation, __, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;
                            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            return SlideTransition(position: animation.drive(tween), child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 400),
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
        SafeArea(child: child),
      ],
    );
  }
}
