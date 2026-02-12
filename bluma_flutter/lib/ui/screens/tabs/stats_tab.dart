import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/cycle_provider.dart';
import '../../../domain/services/period_prediction_service.dart';
import '../../../core/utils/cycle_utils.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/cycle_history.dart';
import '../../widgets/custom_icons.dart';
import '../../widgets/custom_button.dart';

class StatsTab extends ConsumerStatefulWidget {
  const StatsTab({super.key});

  @override
  ConsumerState<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends ConsumerState<StatsTab> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final periodDatesAsync = ref.watch(periodDatesProvider);
    final avgCycleLengthAsync = ref.watch(averageCycleLengthProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('common.navigation.stats'.tr(), style: TextStyle(color: colors.textPrimary, fontSize: 18)),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: periodDatesAsync.when(
        data: (dates) {
          final periods = PeriodPredictionService.groupDateIntoPeriods(dates);

          if (dates.isEmpty || periods.length < 2) {
            return _buildEmptyState(context);
          }

          return avgCycleLengthAsync.when(
            data: (avgCycle) {
              // Calculate average period length
              final avgPeriod = (periods.map((p) => p.length).reduce((a, b) => a + b) / periods.length).round();

              // Generate history
              final List<Map<String, dynamic>> history = [];
              final sortedPeriods = List<List<String>>.from(periods)..sort((a, b) => b.last.compareTo(a.last));

              for (int i = 0; i < sortedPeriods.length; i++) {
                final period = sortedPeriods[i];
                dynamic cycleLen;
                if (i == 0) {
                  cycleLen = 'stats.cycleHistory.inProgress'.tr();
                } else {
                  final currentStart = DateTime.parse(sortedPeriods[i].last);
                  final nextStart = DateTime.parse(sortedPeriods[i-1].last);
                  cycleLen = nextStart.difference(currentStart).inDays;
                }

                history.add({
                  'startDate': period.last,
                  'cycleLength': cycleLen,
                  'periodLength': period.length,
                });
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'stats.cycleStatistics'.tr(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    StatCard(
                      title: 'stats.averages.cycleLength'.tr(),
                      value: '$avgCycle ${'common.time.days'.tr()}',
                      icon: CustomIcons.cycle(size: 40),
                      status: CycleUtils.getCycleStatus(avgCycle),
                      type: 'cycle',
                    ),
                    const SizedBox(height: 12),
                    StatCard(
                      title: 'stats.averages.periodLength'.tr(),
                      value: '$avgPeriod ${'common.time.days'.tr()}',
                      icon: Icon(Icons.water_drop, size: 40, color: colors.icon),
                      status: CycleUtils.getPeriodStatus(avgPeriod),
                      type: 'period',
                    ),
                    const SizedBox(height: 24),
                    CycleHistory(cycles: history),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Text('Error: $e'),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Text('Error: $e'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/stats-icon.png', width: 120, height: 120),
          const SizedBox(height: 32),
          Text(
            'stats.emptyState.title'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'stats.emptyState.subtitle'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textSecondary, fontSize: 18),
          ),
          const SizedBox(height: 32),
          CustomButton(
            title: 'stats.emptyState.logPeriodButton'.tr(),
            fullWidth: true,
            onPress: () => context.push('/edit-period'),
          ),
        ],
      ),
    );
  }
}
