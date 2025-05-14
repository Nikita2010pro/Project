import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/models/booking_data.dart'; // Импорт модели данных для бронирования
import 'package:project/models/tourist.dart'; // Импорт модели для туристов
import 'package:intl/intl.dart'; // Для форматирования даты

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
        return false; // Номер паспорта не уникален
      }
    }
    return true; // Номер паспорта уникален
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

  @override
  Widget build(BuildContext context) {
    final booking = widget.bookingData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Подтверждение бронирования'),
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
              Text('Контактная информация', style: headerStyle),
              const SizedBox(height: 8),
              // Телефон
              TextFormField(
  controller: phoneController,
  decoration: const InputDecoration(labelText: 'Телефон'),
  validator: (value) => value == null || value.isEmpty ? 'Введите номер телефона' : null,
  keyboardType: TextInputType.phone, // Чтобы можно было вводить только цифры
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly, // Ограничиваем ввод только цифрами
  ],
),
              // Почта
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Почта'),
                validator: (value) => value == null || value.isEmpty ? 'Введите почту' : null,
              ),
              const SizedBox(height: 16),
              // Туристы
              for (int i = 0; i < tourists.length; i++) _buildTouristCard(i),
              TextButton.icon(
                onPressed: addTourist,
                icon: const Icon(Icons.add),
                label: const Text('Добавить туриста'),
              ),
              const SizedBox(height: 16),
              // Кнопка подтверждения бронирования
              ConfirmButton(onPressed: () {
                if (_formKey.currentState!.validate()) {
                  bool isValid = true;
                  for (int i = 0; i < tourists.length; i++) {
                    final tourist = tourists[i];
                    if (!isPassportUnique(tourist.passportNumber, i)) {
                      isValid = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Номер паспорта ${tourist.passportNumber} не уникален!')) 
                      );
                      break;
                    }
                  }

                  if (isValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Бронирование подтверждено!')),
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
            Text('${index + 1}-й турист'),
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
            decoration: const InputDecoration(labelText: 'Имя'),
            validator: (value) => value == null || value.isEmpty ? 'Введите имя' : null,
            onChanged: (v) => tourist.firstName = v,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Фамилия'),
            validator: (value) => value == null || value.isEmpty ? 'Введите фамилию' : null,
            onChanged: (v) => tourist.lastName = v,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Дата рождения: ${tourist.birthDate != null ? DateFormat('dd.MM.yyyy').format(tourist.birthDate!) : 'Не выбрана'}'),
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
            decoration: const InputDecoration(labelText: 'Гражданство'),
            validator: (value) => value == null || value.isEmpty ? 'Введите гражданство' : null,
            onChanged: (v) => tourist.citizenship = v,
          ),
          TextFormField(
  decoration: const InputDecoration(labelText: 'Номер загранпаспорта'),
  validator: (value) => value == null || value.isEmpty ? 'Введите номер паспорта' : null,
  keyboardType: TextInputType.number, // Чтобы можно было вводить только цифры
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly, // Ограничиваем ввод только цифрами
  ],
  onChanged: (v) => tourist.passportNumber = v,
),
          Row(
            children: [
              Expanded(
                child: Text('Срок действия паспорта: ${tourist.passportExpiry != null ? DateFormat('dd.MM.yyyy').format(tourist.passportExpiry!) : 'Не выбран'}'),
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
            Text('Отель: ${bookingData.hotelName}', style: headerStyle),
            Text('Город: ${bookingData.country}', style: subHeaderStyle),
            Text('Даты: ${bookingData.departureDate} - ${bookingData.returnDate} (${bookingData.nights} ночей)', style: subHeaderStyle),
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

// Секция с общей суммой
class TotalCostSection extends StatelessWidget {
final double totalCost;
const TotalCostSection({Key? key, required this.totalCost}) : super(key: key);

@override
Widget build(BuildContext context) {
return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text('Итого', style: headerStyle),
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
child: const Text('Подтвердить бронирование'),
);
}
}