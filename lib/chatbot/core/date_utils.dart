import 'package:flutter/material.dart' show Locale;
import 'package:intl/intl.dart';

extension DateUtils on DateTime {
  /// Check if the date is today
  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  /// Check if the date is yesterday
  bool get isYesterday {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return yesterday.year == year &&
        yesterday.month == month &&
        yesterday.day == day;
  }

  /// Check if the date is tomorrow
  bool get isThisWeek {
    final now = DateTime.now();

    // 1. Get the start of today (00:00:00)
    final today = DateTime(now.year, now.month, now.day);

    // 2. Find Monday 00:00:00
    final beginningOfWeek = today.subtract(
      Duration(days: today.weekday - DateTime.monday),
    );

    // 3. Find Sunday 23:59:59
    final endOfWeek = today.add(
      Duration(
        days: DateTime.sunday - today.weekday,
        hours: 23,
        minutes: 59,
        seconds: 59,
      ),
    );

    return (isAtSameMomentAs(beginningOfWeek) || isAfter(beginningOfWeek)) &&
        (isAtSameMomentAs(endOfWeek) || isBefore(endOfWeek));
  }

  /// Check if the date is in the past
  bool get isInPast {
    return isBefore(DateTime.now());
  }

  /// Check if the date is in the future
  bool get isInFuture {
    return isAfter(DateTime.now());
  }

  /// Format the date as a string
  String format(String pattern) {
    final formatter = DateFormat(pattern, 'en');
    return formatter.format(this);
  }

  /// Add days to the date
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  /// Subtract days from the date
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }

  String formattedDate({String newPattern = 'yyyy-MM-dd'}) {
    return DateFormat(newPattern, 'en').format(this);
  }

  String formattedTime({String newPattern = 'HH:mm'}) {
    return DateFormat(newPattern, 'en').format(this);
  }

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  int get dateTimeId {
    return int.parse(DateFormat('yyyyMMdd', 'en').format(this)) * 100;
  }

  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  String formatAiChatTime({required Locale locale}) {
    return DateFormat('hh:mm a', locale.languageCode).format(this);
  }
}

extension DateTimeExtension on String {
  DateTime toDateTime([String pattern = 'yyyy-MM-dd']) {
    return DateFormat(pattern, 'en').parse(this);
  }
}
