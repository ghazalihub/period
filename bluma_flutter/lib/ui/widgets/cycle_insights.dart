import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../domain/services/period_prediction_service.dart';
import 'custom_icons.dart';

class CycleInsights extends StatelessWidget {
  final int? currentCycleDay;
  final int averageCycleLength;

  const CycleInsights({
    super.key,
    this.currentCycleDay,
    required this.averageCycleLength,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'home.cycleInsights.todaysInsights'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colors.textPrimary,
                    ),
              ),
            ),
            IconButton(
              onPressed: currentCycleDay == null
                  ? null
                  : () => context.push(
                        '/info/cycle-phase-details?cycleDay=$currentCycleDay&averageCycleLength=$averageCycleLength',
                      ),
              icon: Icon(
                Icons.chevron_right,
                color: currentCycleDay != null ? colors.textPrimary : colors.neutral200,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (currentCycleDay != null)
          Row(
            children: [
              _buildInsightCard(
                context,
                CustomIcons.calendar(size: 28),
                'home.cycleInsights.cycleDay'.tr(),
                '$currentCycleDay',
              ),
              const SizedBox(width: 8),
              _buildInsightCard(
                context,
                CustomIcons.cycle(size: 28),
                'home.cycleInsights.cyclePhase'.tr(),
                'home.cycleInsights.${PeriodPredictionService.getCyclePhase(currentCycleDay!, averageCycleLength)}'.tr(),
              ),
              const SizedBox(width: 8),
              _buildInsightCard(
                context,
                CustomIcons.leaf(size: 28),
                'home.cycleInsights.chanceToConceive'.tr(),
                'home.cycleInsights.${PeriodPredictionService.getPregnancyChance(currentCycleDay!, averageCycleLength)}'.tr(),
              ),
            ],
          )
        else
          Text(
            'home.cycleInsights.emptyState'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textPrimary,
                ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInsightCard(
    BuildContext context,
    Widget icon,
    String label,
    String value,
  ) {
    final colors = context.colors;

    return Expanded(
      child: GestureDetector(
        onTap: currentCycleDay == null
            ? null
            : () => context.push(
                  '/info/cycle-phase-details?cycleDay=$currentCycleDay&averageCycleLength=$averageCycleLength',
                ),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: colors.insightCardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.insightCardBorder, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant2,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: icon,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.textPrimary,
                            fontSize: 15,
                            height: 1.2,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant2,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
