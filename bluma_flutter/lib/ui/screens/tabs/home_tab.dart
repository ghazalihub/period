import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/cycle_provider.dart';
import '../../../providers/database_provider.dart';
import '../../widgets/cycle_overview_widget.dart';
import '../../widgets/cycle_insights.dart';
import '../../widgets/quick_health_selector.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final periodDatesAsync = ref.watch(periodDatesProvider);
    final avgCycleLengthAsync = ref.watch(averageCycleLengthProvider);
    final cycleInfoAsync = ref.watch(cycleInfoProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('common.navigation.appName'.tr(), style: TextStyle(color: colors.textPrimary, fontSize: 18)),
        backgroundColor: colors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: colors.neutral400),
            onPressed: () => context.push('/info/prediction-info'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(periodDatesProvider);
          ref.refresh(averageCycleLengthProvider);
          ref.refresh(cycleInfoProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              periodDatesAsync.when(
                data: (dates) {
                  return avgCycleLengthAsync.when(
                    data: (avgLength) {
                      return cycleInfoAsync.when(
                        data: (info) {
                          // Calculate prediction
                          final prediction = dates.isNotEmpty
                              ? _getPrediction(dates, avgLength)
                              : null;

                          // Calculate if today is period day
                          final todayStr = DateFormat('yyyy-MM-dd').format(_currentDate);
                          final isPeriodDay = dates.contains(todayStr);

                          int periodDayNumber = 0;
                          if (isPeriodDay) {
                            // Find period day number (consecutive days)
                            periodDayNumber = _calculatePeriodDayNumber(dates, todayStr);
                          }

                          return Column(
                            children: [
                              CycleOverviewWidget(
                                currentDate: _currentDate,
                                isPeriodDay: isPeriodDay,
                                periodDayNumber: periodDayNumber,
                                prediction: prediction,
                                selectedDates: dates,
                                currentCycleDay: info?.cycleDay,
                                averageCycleLength: avgLength,
                              ),
                              CycleInsights(
                                currentCycleDay: info?.cycleDay,
                                averageCycleLength: avgLength,
                              ),
                            ],
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
              const SizedBox(height: 16),
              Text(
                'health.quickHealthSelector.title'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colors.textPrimary,
                    ),
              ),
              const SizedBox(height: 16),
              const QuickHealthSelector(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  PredictionResult? _getPrediction(List<String> dates, int avgLength) {
    if (dates.isEmpty) return null;
    final sortedDates = List<String>.from(dates)..sort((a, b) => b.compareTo(a));
    // Simplified: get prediction from the last period start
    // We need to group dates to find the last period start
    final periods = _groupDateIntoPeriods(sortedDates);
    if (periods.isEmpty) return null;
    final lastStart = periods[0].last;

    final start = DateTime.parse(lastStart);
    final nextPeriod = start.add(Duration(days: avgLength));
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final daysUntil = nextPeriod.difference(today).inDays;

    return PredictionResult(
      days: daysUntil,
      date: DateFormat('yyyy-MM-dd').format(nextPeriod),
      cycleLength: avgLength,
    );
  }

  List<List<String>> _groupDateIntoPeriods(List<String> dates) {
    if (dates.isEmpty) return [];
    final sorted = List<String>.from(dates)..sort((a, b) => b.compareTo(a));
    List<List<String>> periods = [];
    List<String> current = [sorted[0]];
    for (int i = 1; i < sorted.length; i++) {
      final prev = DateTime.parse(sorted[i - 1]);
      final curr = DateTime.parse(sorted[i]);
      if (prev.difference(curr).inDays.abs() <= 1) {
        current.add(sorted[i]);
      } else {
        periods.add(current);
        current = [sorted[i]];
      }
    }
    periods.add(current);
    return periods;
  }

  int _calculatePeriodDayNumber(List<String> dates, String todayStr) {
    int count = 1;
    DateTime temp = DateTime.parse(todayStr).subtract(const Duration(days: 1));
    while (dates.contains(DateFormat('yyyy-MM-dd').format(temp))) {
      count++;
      temp = temp.subtract(const Duration(days: 1));
    }
    return count;
  }
}

class PredictionResult {
  final int days;
  final String date;
  final int cycleLength;
  PredictionResult({required this.days, required this.date, required this.cycleLength});
}
