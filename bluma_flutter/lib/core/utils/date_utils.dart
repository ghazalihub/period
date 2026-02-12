import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppDateUtils {
  static String formatTodayShort(DateTime date, BuildContext context) {
    final monthDay = DateFormat.MMMd(context.locale.toString()).format(date);
    return '${'common.time.today'.tr()}, $monthDay';
  }

  static String formatTodayOrDate(String dateString, BuildContext context) {
    final date = DateTime.parse(dateString);
    final today = DateTime.now();
    final isToday = date.year == today.year && date.month == today.month && date.day == today.day;

    if (isToday) {
      final monthDay = DateFormat.MMMMd(context.locale.toString()).format(date);
      return '${'common.time.today'.tr()}, $monthDay';
    }

    return DateFormat.yMMMMEEEEd(context.locale.toString()).format(date);
  }

  static String formatDateLong(DateTime date, BuildContext context) {
    return DateFormat.MMMMd(context.locale.toString()).format(date);
  }

  static String formatDateShort(DateTime date, BuildContext context) {
    return DateFormat.MMMd(context.locale.toString()).format(date);
  }

  static String formatDateWithDay(DateTime date, BuildContext context) {
    return DateFormat.yMMMMEEEEd(context.locale.toString()).format(date);
  }
}
