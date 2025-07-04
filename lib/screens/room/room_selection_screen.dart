import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:project/models/hotel.dart';
import 'package:project/models/room.dart';
import 'package:project/screens/room/room_card.dart';

class RoomSelectionScreen extends StatefulWidget {
  final Hotel hotel;

  const RoomSelectionScreen({Key? key, required this.hotel}) : super(key: key);

  @override
  State<RoomSelectionScreen> createState() => _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends State<RoomSelectionScreen> {
  late Future<List<Room>> _roomsFuture;

  @override
  void initState() {
    super.initState();
    _roomsFuture = fetchRooms();
  }

  Future<List<Room>> fetchRooms() async {
    final hotelId = widget.hotel.id;
    print('Загружаем номера для hotelId: $hotelId');

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('rooms')
          .get();

      print('Найдено документов: ${querySnapshot.docs.length}');

      final rooms = querySnapshot.docs.map((doc) {
        final data = doc.data();
        print('Документ: $data');
        return Room.fromJson(data, doc.id);
      }).toList();

      print('Итого номеров: ${rooms.length}');
      return rooms;
    } catch (e) {
      print('Ошибка при загрузке номеров: $e');
      return [];
    }
  }

@override
Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Scaffold(
    // чтобы фон был под всей областью, и заголовок тоже
    extendBodyBehindAppBar: true, 
    
    appBar: AppBar(
      backgroundColor: Colors.transparent, // прозрачный фон
      elevation: 0, // без тени
      title: Text(
        'room_selection.title'.tr(),
        style: const TextStyle(
          fontFamily: 'Pacifico',
          fontSize: 28,
          fontWeight: FontWeight.w400,
          // можно настроить цвет, например белый с тенью
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black54,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
      centerTitle: true,
      toolbarHeight: 80,
    ),

    body: Stack(
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
        Padding(
          // чтобы контент не ушёл под AppBar, добавим отступ сверху
          padding: const EdgeInsets.only(top: 80),
          child: FutureBuilder<List<Room>>(
            future: _roomsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                print("Ошибка загрузки номеров: ${snapshot.error}");
                return Center(child: Text('room_selection.error_loading'.tr()));
              }

              final rooms = snapshot.data ?? [];

              if (rooms.isEmpty) {
                return Center(child: Text('room_selection.no_rooms'.tr()));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return RoomCard(
                    hotel: widget.hotel,
                    title: room.title,
                    images: room.images,
                    features: room.features,
                    price: room.price,
                    description: room.description,
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
}