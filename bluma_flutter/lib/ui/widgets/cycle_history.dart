import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';

class CycleHistory extends StatelessWidget {
  final List<Map<String, dynamic>> cycles;

  const CycleHistory({super.key, required this.cycles});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (cycles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border(bottom: BorderSide(color: colors.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'stats.cycleHistory.title'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                '${cycles.length} ${'stats.cycleHistory.loggedCycles'.tr()}',
                style: TextStyle(color: colors.textSecondary),
              ),
            ],
          ),
        ),
        Container(
          color: colors.surface,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cycles.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: colors.border, indent: 16),
            itemBuilder: (context, index) {
              final cycle = cycles[index];
              final isCurrent = index == 0;
              final startDate = DateTime.parse(cycle['startDate']);
              final formattedStart = DateFormat.MMMd(context.locale.toString()).format(startDate);

              String displayLength;
              if (isCurrent) {
                final daysSoFar = DateTime.now().difference(startDate).inDays + 1;
                displayLength = 'stats.cycleHistory.days'.tr(plural: daysSoFar);
              } else {
                final length = cycle['cycleLength'];
                displayLength = length is int ? 'stats.cycleHistory.days'.tr(plural: length) : length.toString();
              }

              return InkWell(
                onTap: () {
                  // Navigate to cycle details
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCurrent ? '${'stats.cycleHistory.currentCycle'.tr()}: $displayLength' : displayLength,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$formattedStart - ${isCurrent ? 'common.time.today'.tr() : '...'}', // Simplified
                              style: TextStyle(color: colors.textSecondary, fontSize: 15),
                            ),
                            const SizedBox(height: 8),
                            _DayCircles(
                              totalDays: isCurrent ? DateTime.now().difference(startDate).inDays + 1 : (cycle['cycleLength'] is int ? cycle['cycleLength'] : 28),
                              periodDays: cycle['periodLength'],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 18, color: colors.textSecondary),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          height: 16,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
        ),
      ],
    );
  }
}

class _DayCircles extends StatelessWidget {
  final int totalDays;
  final int periodDays;

  const _DayCircles({required this.totalDays, required this.periodDays});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final int displayDays = totalDays.clamp(0, 40); // Limit display

    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: List.generate(displayDays, (i) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < periodDays ? colors.accentPink : colors.neutral100,
          ),
        );
      }),
    );
  }
}
