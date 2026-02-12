import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/cycle_provider.dart';
import '../../../domain/services/period_prediction_service.dart';
import '../../widgets/quick_health_selector.dart';
import '../../widgets/custom_button.dart';

class CalendarTab extends ConsumerStatefulWidget {
  const CalendarTab({super.key});

  @override
  ConsumerState<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends ConsumerState<CalendarTab> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final periodDatesAsync = ref.watch(periodDatesProvider);
    final avgCycleLengthAsync = ref.watch(averageCycleLengthProvider);
    final avgPeriodLengthAsync = ref.watch(averagePeriodLengthProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.panel,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.info_outline, color: colors.neutral400, size: 26),
          onPressed: () => context.push('/settings/calendar-view'),
        ),
        actions: [
          if (!isSameDay(_focusedDay, DateTime.now()))
            TextButton(
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime.now();
                  _selectedDay = DateTime.now();
                });
              },
              child: Text(
                'calendar.today'.tr(),
                style: TextStyle(color: colors.primary, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: periodDatesAsync.when(
              data: (dates) {
                return avgCycleLengthAsync.when(
                  data: (avgCycle) {
                    return avgPeriodLengthAsync.when(
                      data: (avgPeriod) {
                        final predictions = dates.isNotEmpty
                            ? PeriodPredictionService.generatePredictedDates(
                                _getLastPeriodStart(dates),
                                avgCycle,
                                avgPeriod,
                              )
                            : {};

                        return TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                            _showDetailsSheet(context, selectedDay, dates, avgCycle);
                          },
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarStyle: CalendarStyle(
                            selectedDecoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: colors.primary.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              final dayStr = _dateFormat.format(day);
                              if (dates.contains(dayStr)) {
                                return _buildCalendarDay(day, colors.accentPink, colors.white);
                              }
                              if (predictions.containsKey(dayStr)) {
                                final type = predictions[dayStr]!['type'];
                                if (type == 'period') {
                                  return _buildCalendarDay(day, colors.accentPink.withOpacity(0.3), colors.textPrimary);
                                } else if (type == 'ovulation') {
                                  return _buildCalendarDay(day, colors.accentBlue, colors.white);
                                } else if (type == 'fertile') {
                                  return _buildCalendarDay(day, colors.accentBlue.withOpacity(0.3), colors.textPrimary);
                                }
                              }
                              return null;
                            },
                          ),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Text('Error: $e'),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Text('Error: $e'),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Error: $e'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              title: 'calendar.editPeriod.editPeriodDates'.tr(),
              fullWidth: true,
              onPress: () => context.push('/edit-period'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(DateTime day, Color bgColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        '${day.day}',
        style: TextStyle(color: textColor),
      ),
    );
  }

  String _getLastPeriodStart(List<String> dates) {
    final sorted = List<String>.from(dates)..sort((a, b) => b.compareTo(a));
    final periods = PeriodPredictionService.groupDateIntoPeriods(sorted);
    return periods.isNotEmpty ? periods[0].last : _dateFormat.format(DateTime.now());
  }

  void _showDetailsSheet(BuildContext context, DateTime date, List<String> dates, int avgCycle) {
    final dayStr = _dateFormat.format(date);
    final cycleDay = _calculateCycleDay(dayStr, dates, avgCycle);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CalendarDetailsSheet(
        selectedDate: dayStr,
        cycleDay: cycleDay,
        averageCycleLength: avgCycle,
      ),
    );
  }

  int? _calculateCycleDay(String date, List<String> dates, int avgCycle) {
    if (dates.isEmpty) return null;
    final sorted = List<String>.from(dates)..sort((a, b) => b.compareTo(a));
    final periods = PeriodPredictionService.groupDateIntoPeriods(sorted);
    if (periods.isEmpty) return null;

    final lastStart = periods[0].last;
    if (date.compareTo(lastStart) >= 0) {
      return PeriodPredictionService.getCurrentCycleDay(lastStart, date);
    }
    // Simple logic for past cycles
    for (final period in periods) {
      final start = period.last;
      if (date.compareTo(start) >= 0 && date.compareTo(period.first) <= 0) {
        return PeriodPredictionService.getCurrentCycleDay(start, date);
      }
    }
    return null;
  }
}

class _CalendarDetailsSheet extends StatelessWidget {
  final String selectedDate;
  final int? cycleDay;
  final int averageCycleLength;

  const _CalendarDetailsSheet({
    required this.selectedDate,
    this.cycleDay,
    required this.averageCycleLength,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dateObj = DateTime.parse(selectedDate);
    final formattedDate = DateFormat.MMMd(context.locale.toString()).format(dateObj);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$formattedDate${cycleDay != null ? ' • ${'common.cycleDetails.cycleDay'.tr(namedArgs: {'number': '$cycleDay'})}' : ''}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (cycleDay != null)
                      Text(
                        'common.cycleDetails.conceptionChance.${PeriodPredictionService.getPregnancyChance(cycleDay!, averageCycleLength).toLowerCase()}'.tr(),
                        style: TextStyle(color: colors.textSecondary),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: colors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (DateTime.parse(selectedDate).isBefore(DateTime.now().add(const Duration(days: 1)))) ...[
            Text(
              'health.quickHealthSelector.title'.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            QuickHealthSelector(selectedDate: selectedDate),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
