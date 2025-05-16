import 'package:flutter/material.dart';

Future<DateTimeRange?> showDateRangePickerDialog(BuildContext context) async {
  final picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked == null) return null;

  final duration = picked.duration.inDays;

  if (duration < 7) {
    // Показываем диалог с ошибкой
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Недопустимый диапазон'),
        content: const Text('Минимальное количество ночей — 7. Пожалуйста, выберите другой диапазон.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ок'),
          ),
        ],
      ),
    );
    return null;
  }

  return picked;
}
