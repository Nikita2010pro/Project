import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/models/booking_data.dart';
import 'package:project/models/tourist.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingScreen extends StatefulWidget {
  final BookingData bookingData;

  const BookingScreen({Key? key, required this.bookingData}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final List<Tourist> tourists = [Tourist()];

  bool isPassportUnique(String passportNumber, int excludeIndex) {
    for (int i = 0; i < tourists.length; i++) {
      if (i != excludeIndex && tourists[i].passportNumber == passportNumber) {
        return false;
      }
    }
    return true;
  }

  void addTourist() {
    setState(() {
      tourists.add(Tourist());
    });
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate, ValueChanged<DateTime> onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Future<void> _submitBooking() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('confirm_title'.tr()),
        content: Text('confirm_message'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Отмена')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Да')),
        ],
      ),
    );
    if (confirmed != true) return;


  final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Пользователь не авторизован')),
    );
    return;
  }

  try {
    final bookingDoc = await firestore.collection('bookings').add({
      'phone': phoneController.text,
      'email': emailController.text,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'hotelTitle': widget.bookingData.hotelName,           // Название отеля
      'roomTitle': widget.bookingData.roomTitle,             // Название номера
      'totalCost': widget.bookingData.totalCost.toString(),  // Общая стоимость
    });

    for (final tourist in tourists) {
      await bookingDoc.collection('tourists').add({
        'firstName': tourist.firstName,
        'lastName': tourist.lastName,
        'birthDate': tourist.birthDate,
        'citizenship': tourist.citizenship,
        'passportNumber': tourist.passportNumber,
        'passportExpiry': tourist.passportExpiry,
      });
    }

    Navigator.of(context).pop(); // Закрыть лоадер
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('booking_success'.tr())),
    );
  } catch (e) {
    Navigator.of(context).pop(); // Закрыть лоадер
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('booking_error: $e'.tr())),
    );
  } finally {
  }
}

  @override
  Widget build(BuildContext context) {
    final booking = widget.bookingData;

    return Scaffold(
      appBar: AppBar(
        title: Text('submit_booking'.tr()),
        backgroundColor: Colors.indigo,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Информация о отеле
              HotelInfoSection(bookingData: booking),
              const SizedBox(height: 16),
              // Изображения отеля
              ImagesSection(images: booking.images),
              const SizedBox(height: 16),
              // Детали номера
              RoomDetailsSection(bookingData: booking),
              const SizedBox(height: 16),
              // Дополнительные сборы
              AdditionalFeesSection(bookingData: booking),
              const Divider(height: 24, thickness: 1),
              // Общая сумма
              TotalCostSection(totalCost: booking.totalCost),
              const SizedBox(height: 24),
              // Контактная информация
              Text('contact_info'.tr(), style: headerStyle),
              const SizedBox(height: 8),
              // Телефон
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'phone'.tr()),
                validator: (value) => value == null || value.isEmpty ? 'enter_number'.tr() : null,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'mail'.tr()),
                validator: (value) {if (value == null || value.isEmpty) return 'enter_email'.tr(); final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) return 'invalid_email'.tr(); return null;},
              ),
              const SizedBox(height: 16),
              // Туристы
              for (int i = 0; i < tourists.length; i++) _buildTouristCard(i),
              TextButton.icon(
                onPressed: addTourist,
                icon: const Icon(Icons.add),
                label: Text('add_tourist'.tr()),
              ),
              const SizedBox(height: 16),
              ConfirmButton(onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool isValid = true;
                  for (int i = 0; i < tourists.length; i++) {
                    final tourist = tourists[i];
                    if (!isPassportUnique(tourist.passportNumber, i)) {
                      isValid = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('passport_not_unique'.tr(namedArgs: {'passport': tourist.passportNumber,})),),
                      );
                      break;
                    }
                  }

              if (isValid) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.indigo,
                          size: 60,
                        ),
                      ),
                    );

                    await _submitBooking();

                    Navigator.of(context).pop(); // Закрыть лоадер

                    // Перейти на экран отелей и очистить стек
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', // Убедись, что у тебя этот маршрут прописан
                      (Route<dynamic> route) => false,
                    );
                  }
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTouristCard(int index) {
    final tourist = tourists[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('tourist_number'.tr(namedArgs: {'number': (index + 1).toString()})),
            if (index != 0)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    tourists.removeAt(index);
                  });
                },
              ),
          ],
        ),
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'first_name'.tr()),
            validator: (value) => value == null || value.isEmpty ? 'enter_name'.tr() : null,
            onChanged: (v) => tourist.firstName = v,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'last_name'.tr()),
            validator: (value) => value == null || value.isEmpty ? 'enter_last_name'.tr() : null,
            onChanged: (v) => tourist.lastName = v,
          ),
          Row(
            children: [
              Expanded(
                child: Text('birth_date'.tr(namedArgs: {'date': tourist.birthDate != null ? DateFormat('dd.MM.yyyy').format(tourist.birthDate!) : 'not_selected'.tr(),}),),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context, tourist.birthDate, (date) {
                  setState(() => tourist.birthDate = date);
                }),
              )
            ],
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'citizenship'.tr()),
            validator: (value) => value == null || value.isEmpty ? 'enter_citizenship'.tr() : null,
            onChanged: (v) => tourist.citizenship = v,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'passport_number'.tr()),
            validator: (value) => value == null || value.isEmpty ? 'enter_passport_number'.tr() : null,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) => tourist.passportNumber = v,
          ),
          Row(
            children: [
              Expanded(
                child: Text('passport_expiry'.tr(namedArgs: {'date': tourist.passportExpiry != null ? DateFormat('dd.MM.yyyy').format(tourist.passportExpiry!) : 'not_selected'.tr(),}),),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context, tourist.passportExpiry, (date) {
                  setState(() => tourist.passportExpiry = date);
                }),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// ========== Дополнительные виджеты ==========

const TextStyle headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo);
TextStyle subHeaderStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700]);
const TextStyle costTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green);

class HotelInfoSection extends StatelessWidget {
  final BookingData bookingData;
  const HotelInfoSection({Key? key, required this.bookingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('hotel_name'.tr(namedArgs: {'hotelName': bookingData.hotelName}), style: headerStyle),
            Text('city'.tr(namedArgs: {'city': bookingData.country}), style: subHeaderStyle),
            Text('date_range'.tr(namedArgs: {'from': bookingData.departureDate,'to': bookingData.returnDate,'nights': bookingData.nights.toString(),}),style: subHeaderStyle),
          ],
        ),
      ),
    );
  }
}

// Секция с изображениями
class ImagesSection extends StatelessWidget {
  final List<String> images;
  const ImagesSection({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox();
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(images[index], fit: BoxFit.cover, width: double.infinity),
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
        Text('room_number'.tr(namedArgs: {'room': bookingData.roomTitle}), style: subHeaderStyle),
        Text('features'.tr(namedArgs: {'features': bookingData.roomFeatures}), style: subHeaderStyle),
        Text('room_price'.tr(namedArgs: {'price': bookingData.roomPrice.toStringAsFixed(0),}), style: subHeaderStyle),
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
        Text('fuel_fee'.tr(namedArgs: {'amount': bookingData.fuelFee.toStringAsFixed(0)}), style: subHeaderStyle),
        Text('service_fee'.tr(namedArgs: {'amount': bookingData.serviceFee.toStringAsFixed(0)}), style: subHeaderStyle),
        if (bookingData.extraNightsCost > 0)
          Text('extra_nights'.tr(namedArgs: {'amount': bookingData.extraNightsCost.toStringAsFixed(0)}), style: subHeaderStyle),
      ],
    );
  }
}

// Секция с общей суммой
class TotalCostSection extends StatelessWidget {
  final double totalCost;
  const TotalCostSection({Key? key, required this.totalCost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('total'.tr(), style: headerStyle),
        Text('${totalCost.toStringAsFixed(0)} ₽', style: costTextStyle),
      ],
    );
  }
}

// Кнопка подтверждения бронирования
class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ConfirmButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text('submit_booking'.tr()),
    );
  }
}
