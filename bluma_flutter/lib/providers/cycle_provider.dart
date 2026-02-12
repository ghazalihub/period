import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/services/period_prediction_service.dart';
import 'database_provider.dart';

final periodDatesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(periodRepositoryProvider);
  final dates = await repo.getAllPeriodDates();
  return dates.map((e) => e.date).toList();
});

final averageCycleLengthProvider = FutureProvider<int>((ref) async {
  final dates = await ref.watch(periodDatesProvider.future);
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  final userCycleLengthStr = await settingsRepo.getSetting('userCycleLength');
  final userCycleLength = int.tryParse(userCycleLengthStr ?? '28') ?? 28;

  return PeriodPredictionService.getAverageCycleLength(dates, userCycleLength);
});

final averagePeriodLengthProvider = FutureProvider<int>((ref) async {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  final userPeriodLengthStr = await settingsRepo.getSetting('userPeriodLength');
  return int.tryParse(userPeriodLengthStr ?? '5') ?? 5;
});

final cycleInfoProvider = FutureProvider<CycleInfo?>((ref) async {
  final dates = await ref.watch(periodDatesProvider.future);
  if (dates.isEmpty) return null;

  final sortedDates = List<String>.from(dates)..sort((a, b) => b.compareTo(a));
  final periods = PeriodPredictionService.groupDateIntoPeriods(sortedDates);
  if (periods.isEmpty) return null;

  final lastPeriodStart = periods[0].last;
  final avgLength = await ref.watch(averageCycleLengthProvider.future);

  return PeriodPredictionService.getCycleInfo(lastPeriodStart, cycleLength: avgLength);
});
