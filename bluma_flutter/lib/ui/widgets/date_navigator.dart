import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/date_utils.dart';

class DateNavigator extends StatelessWidget {
  final String selectedDate;
  final ValueChanged<String> onDateChange;
  final String? minDate;
  final String? maxDate;

  const DateNavigator({
    super.key,
    required this.selectedDate,
    required this.onDateChange,
    this.minDate,
    this.maxDate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final date = DateTime.parse(selectedDate);
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    void goToPreviousDay() {
      final prev = date.subtract(const Duration(days: 1));
      final prevStr = dateFormat.format(prev);
      if (minDate == null || prevStr.compareTo(minDate!) >= 0) {
        onDateChange(prevStr);
      }
    }

    void goToNextDay() {
      final next = date.add(const Duration(days: 1));
      final nextStr = dateFormat.format(next);
      if (maxDate == null || nextStr.compareTo(maxDate!) <= 0) {
        onDateChange(nextStr);
      }
    }

    final prevDisabled = minDate != null && dateFormat.format(date.subtract(const Duration(days: 1))).compareTo(minDate!) < 0;
    final nextDisabled = maxDate != null && dateFormat.format(date.add(const Duration(days: 1))).compareTo(maxDate!) > 0;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: prevDisabled ? null : goToPreviousDay,
            icon: Icon(Icons.chevron_left, color: prevDisabled ? colors.textPrimary.withOpacity(0.38) : colors.textPrimary),
          ),
          Text(
            AppDateUtils.formatTodayOrDate(selectedDate, context),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          IconButton(
            onPressed: nextDisabled ? null : goToNextDay,
            icon: Icon(Icons.chevron_right, color: nextDisabled ? colors.textPrimary.withOpacity(0.38) : colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
