import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<DateTimeRange?> showDateRangePickerDialog(BuildContext context) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: isDark
              ? const ColorScheme.dark(
                  primary: Colors.teal,
                  onPrimary: Colors.white,
                  surface: Colors.black87,
                  onSurface: Colors.white,
                )
              : const ColorScheme.light(
                  primary: Colors.teal,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black87,
                ),
          dialogBackgroundColor:
              isDark ? Colors.grey[900] : Colors.white, // фон диалогов
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.teal,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked == null) return null;

  final duration = picked.duration.inDays;

  if (duration < 7) {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'invalid_range'.tr(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'min_nights_error'.tr(),
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'.tr()), // переведённый текст
          ),
        ],
      ),
    );
    return null;
  }

  return picked;
}
