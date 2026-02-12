import 'package:intl/intl.dart';

class PredictionResult {
  final int days;
  final String date;
  final int cycleLength;

  PredictionResult({
    required this.days,
    required this.date,
    required this.cycleLength,
  });
}

class FertilityWindow {
  final String start;
  final String end;
  final String ovulationDay;

  FertilityWindow({
    required this.start,
    required this.end,
    required this.ovulationDay,
  });
}

class CycleInfo {
  final String phase;
  final String description;
  final int cycleDay;
  final String pregnancyChance;

  CycleInfo({
    required this.phase,
    required this.description,
    required this.cycleDay,
    required this.pregnancyChance,
  });
}

class PeriodPredictionService {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static List<List<String>> groupDateIntoPeriods(List<String> dates) {
    if (dates.isEmpty) return [];

    final sortedDates = List<String>.from(dates)
      ..sort((a, b) => b.compareTo(a));

    List<List<String>> periods = [];
    List<String> currentPeriod = [sortedDates[0]];

    for (int i = 1; i < sortedDates.length; i++) {
      final prevDate = DateTime.parse(sortedDates[i - 1]);
      final currDate = DateTime.parse(sortedDates[i]);
      final dayDiff = prevDate.difference(currDate).inDays.abs();

      if (dayDiff <= 1) {
        currentPeriod.add(sortedDates[i]);
      } else {
        periods.add(currentPeriod);
        currentPeriod = [sortedDates[i]];
      }
    }
    periods.add(currentPeriod);
    return periods;
  }

  static int getAverageCycleLength(List<String> dates, [int? userCycleLength]) {
    if (dates.length < 2) return userCycleLength ?? 28;

    final periods = groupDateIntoPeriods(dates);

    double weightedTotal = 0;
    double weightSum = 0;
    int cycles = 0;

    for (int i = 1; i < (periods.length < 6 ? periods.length : 6); i++) {
      final currentPeriodStart = DateTime.parse(periods[i - 1].last);
      final prevPeriodStart = DateTime.parse(periods[i].last);

      final dayDiff = currentPeriodStart.difference(prevPeriodStart).inDays;

      final weight = (1 - cycles * 0.2) > 0.2 ? (1 - cycles * 0.2) : 0.2;
      weightedTotal += dayDiff * weight;
      weightSum += weight;
      cycles++;
    }

    return cycles > 0
        ? (weightedTotal / weightSum).round()
        : userCycleLength ?? 28;
  }

  static Map<String, dynamic> calculatePeriodDay(Map<String, dynamic> periodDates) {
    final today = DateTime.now();
    final todayStr = _dateFormat.format(today);

    if (!periodDates.containsKey(todayStr)) {
      return {'isPeriodDay': false, 'dayNumber': 0};
    }

    int dayCount = 1;
    DateTime tempDate = DateTime(today.year, today.month, today.day, 12);

    while (true) {
      tempDate = tempDate.subtract(const Duration(days: 1));
      final prevDateStr = _dateFormat.format(tempDate);

      if (periodDates.containsKey(prevDateStr)) {
        dayCount++;
      } else {
        break;
      }
    }

    return {'isPeriodDay': true, 'dayNumber': dayCount};
  }

  static PredictionResult getPrediction(
      String startDate, List<String> allDates, [int? userCycleLength]) {
    final cycleLength = getAverageCycleLength(allDates, userCycleLength);
    final today = DateTime.now();
    final start = DateTime.parse(startDate);
    final nextPeriod = start.add(Duration(days: cycleLength));

    final daysUntil = nextPeriod.difference(today).inDays + 1;

    return PredictionResult(
      days: daysUntil,
      date: _dateFormat.format(nextPeriod),
      cycleLength: cycleLength,
    );
  }

  static int getCurrentCycleDay(String startDate, [String? currentDate]) {
    final start = DateTime.parse(startDate);
    final current = currentDate != null ? DateTime.parse(currentDate) : DateTime.now();

    final dayDiff = DateTime(current.year, current.month, current.day)
        .difference(DateTime(start.year, start.month, start.day))
        .inDays;

    return dayDiff + 1;
  }

  static String getOvulationDay(String startDate, [int? cycleLength]) {
    final start = DateTime.parse(startDate);
    final length = cycleLength ?? 28;
    final ovulationDayOffset = length - 14;
    final ovulationDate = start.add(Duration(days: ovulationDayOffset));

    return _dateFormat.format(ovulationDate);
  }

  static FertilityWindow getFertilityWindow(String startDate, [int? cycleLength]) {
    final cycle = cycleLength ?? 28;
    final ovulationDay = getOvulationDay(startDate, cycle);
    final ovulationDate = DateTime.parse(ovulationDay);

    final startWindow = ovulationDate.subtract(const Duration(days: 5));

    return FertilityWindow(
      start: _dateFormat.format(startWindow),
      end: ovulationDay,
      ovulationDay: ovulationDay,
    );
  }

  static String getCyclePhase(int cycleDay, [int averageCycleLength = 28]) {
    if (cycleDay <= 5) return 'menstrual';

    final follicularEnd = (10 * (averageCycleLength / 28)).round();
    final ovulatoryEnd = (14 * (averageCycleLength / 28)).round();

    if (cycleDay <= follicularEnd) return 'follicular';
    if (cycleDay <= ovulatoryEnd) return 'ovulatory';
    if (cycleDay <= 35) return 'luteal';
    return 'extended';
  }

  static String getPhaseDescription(String phase) {
    switch (phase.toLowerCase()) {
      case 'menstrual':
        return 'The period, or menstruation, is when the lining of the uterus sheds and leaves the body through vaginal bleeding. It typically lasts 3–7 days, but can vary widely. \n\nDuring this time, the body prepares for a potential pregnancy by thickening the uterine lining. If fertilization does not occur, hormone levels drop, and menstruation begins.';
      case 'follicular':
        return 'The follicular phase is the first part of the menstrual cycle, starting with the first day of your period and ending with ovulation. Energy levels start to rise with increasing estrogen. Good time for starting new projects and physical activity.';
      case 'ovulatory':
        return 'Ovulation is the release of an egg from the ovary. This is the peak fertility window, and it typically occurs around day 14 of your cycle.';
      case 'luteal':
        return 'The luteal phase is the second part of the menstrual cycle, lasting from ovulation until the start of your next period, and typically lasts about 12–14 days.\n\nDuring this time, the body prepares for a potential pregnancy by thickening the uterine lining. If fertilization does not occur, hormone levels drop, and menstruation begins.';
      case 'extended':
        return 'Your cycle is running longer than usual (past day 35). This can be normal occasionally, but if it happens often, consider tracking patterns and chatting with a healthcare provider.';
      default:
        return '';
    }
  }

  static String getPregnancyChance(int cycleDay, [int averageCycleLength = 28]) {
    final ovulationDay = averageCycleLength - 14;
    final fertilityStart = ovulationDay - 5;
    final fertilityEnd = ovulationDay + 1;

    if (cycleDay >= fertilityStart && cycleDay <= fertilityEnd) return 'high';
    if (cycleDay >= fertilityStart - 2 && cycleDay <= fertilityEnd + 2) return 'medium';
    return 'low';
  }

  static String getPregnancyChanceDescription(String chance) {
    switch (chance.toLowerCase()) {
      case 'high':
        return 'This is your fertile window when conception is most likely to occur. Ovulation typically happens during this time.';
      case 'medium':
        return 'There is a moderate chance of conception during this time as you approach or move away from your fertile window.';
      case 'low':
        return 'Conception is less likely during this time. This includes menstrual days and the later luteal phase of your cycle.';
      default:
        return '';
    }
  }

  static String getPossibleSymptoms(String phase) {
    switch (phase.toLowerCase()) {
      case 'menstrual':
        return 'Cramps, fatigue, mood swings, bloating, headaches, and lower back pain. Your energy and mood may be lower than usual.';
      case 'follicular':
        return 'Rising energy, improved mood, clearer skin, and increased motivation. You may feel more social and confident.';
      case 'ovulatory':
        return 'Peak energy, heightened sex drive, increased confidence, and possible mild cramping or spotting. You may feel your most attractive.';
      case 'luteal':
        return 'Bloating, mood swings, food cravings, fatigue, breast tenderness, and irritability. These PMS symptoms typically worsen as your period approaches.';
      case 'extended':
        return '';
      default:
        return '';
    }
  }

  static CycleInfo getCycleInfo(String startDate, {String? currentDate, int? cycleLength}) {
    final cycleDay = getCurrentCycleDay(startDate, currentDate);
    final avgCycleLength = cycleLength ?? 28;
    final phase = getCyclePhase(cycleDay, avgCycleLength);

    return CycleInfo(
      phase: phase,
      description: getPhaseDescription(phase),
      cycleDay: cycleDay,
      pregnancyChance: getPregnancyChance(cycleDay, avgCycleLength),
    );
  }

  static Map<String, Map<String, String>> generateFertilityForLoggedPeriods(
      List<String> periodStartDates, int userCycleLength) {
    final Map<String, Map<String, String>> fertilityDates = {};

    for (final startDate in periodStartDates) {
      final periodDate = DateTime.parse(startDate);
      final ovulationDate = periodDate.subtract(const Duration(days: 14));
      final ovulationDateString = _dateFormat.format(ovulationDate);

      final fertileStart = ovulationDate.subtract(const Duration(days: 5));
      final fertileEnd = ovulationDate.add(const Duration(days: 1));

      for (DateTime d = fertileStart;
          d.isBefore(fertileEnd.add(const Duration(days: 1)));
          d = d.add(const Duration(days: 1))) {
        final fertileDateString = _dateFormat.format(d);

        if (fertileDateString == ovulationDateString) {
          fertilityDates[fertileDateString] = {'type': 'ovulation'};
        } else {
          fertilityDates[fertileDateString] = {'type': 'fertile'};
        }
      }
    }

    return fertilityDates;
  }

  static Map<String, Map<String, String>> generatePredictedDates(
      String startDate, int userCycleLength, int userPeriodLength,
      [int numCycles = 3]) {
    final Map<String, Map<String, String>> predictedDates = {};

    for (int i = 0; i < numCycles; i++) {
      final baseDate = DateTime.parse(startDate);
      final nextPeriodDate = baseDate.add(Duration(days: userCycleLength * (i + 1)));

      final ovulationDate = nextPeriodDate.subtract(const Duration(days: 14));
      final ovulationDateString = _dateFormat.format(ovulationDate);

      final fertileStart = ovulationDate.subtract(const Duration(days: 5));
      final fertileEnd = ovulationDate.add(const Duration(days: 1));

      for (DateTime d = fertileStart;
          d.isBefore(fertileEnd.add(const Duration(days: 1)));
          d = d.add(const Duration(days: 1))) {
        final fertileDateString = _dateFormat.format(d);

        if (!predictedDates.containsKey(fertileDateString) ||
            predictedDates[fertileDateString]!['type'] != 'period') {
          if (fertileDateString == ovulationDateString) {
            predictedDates[fertileDateString] = {'type': 'ovulation'};
          } else {
            predictedDates[fertileDateString] = {'type': 'fertile'};
          }
        }
      }

      for (int j = 0; j < userPeriodLength; j++) {
        final periodDay = nextPeriodDate.add(Duration(days: j));
        final periodDayString = _dateFormat.format(periodDay);
        predictedDates[periodDayString] = {'type': 'period'};
      }
    }

    return predictedDates;
  }
}
