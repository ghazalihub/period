class CycleUtils {
  static String getCycleStatus(int cycleLength) {
    if (cycleLength >= 21 && cycleLength <= 35) return 'normal';
    return 'irregular';
  }

  static String getPeriodStatus(int periodLength) {
    if (periodLength >= 2 && periodLength <= 7) return 'normal';
    return 'irregular';
  }
}
