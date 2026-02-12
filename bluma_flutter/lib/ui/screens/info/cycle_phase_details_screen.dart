import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/services/period_prediction_service.dart';
import '../widgets/custom_icons.dart';

class CyclePhaseDetailsScreen extends StatelessWidget {
  final int cycleDay;
  final int averageCycleLength;

  const CyclePhaseDetailsScreen({
    super.key,
    required this.cycleDay,
    required this.averageCycleLength,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentDate = DateTime.now();
    final cyclePhaseKey = PeriodPredictionService.getCyclePhase(cycleDay, averageCycleLength);
    final pregnancyChanceKey = PeriodPredictionService.getPregnancyChance(cycleDay, averageCycleLength);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(backgroundColor: colors.background, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(DateFormat.MMMMEEEEd(context.locale.toString()).format(currentDate), style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text('${'info.cyclePhase.cycleDay'.tr()} $cycleDay', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text(_getFormattedCycleStart(context), style: TextStyle(color: colors.textSecondary, fontSize: 16)),
            const SizedBox(height: 24),
            _buildInfoSection(
              context,
              CustomIcons.cycle(size: 32),
              'info.cyclePhase.cyclePhaseTitle'.tr(),
              'info.cyclePhase.phases.$cyclePhaseKey'.tr(),
              'info.cyclePhase.phaseDescriptions.$cyclePhaseKey'.tr(),
            ),
            _buildInfoSection(
              context,
              CustomIcons.leaf(size: 34),
              'info.cyclePhase.chanceToConceive'.tr(),
              'info.cyclePhase.pregnancyChance.$pregnancyChanceKey'.tr(),
              'info.cyclePhase.pregnancyChanceDescriptions.$pregnancyChanceKey'.tr(),
            ),
            if ('info.cyclePhase.symptoms.$cyclePhaseKey'.tr() != 'info.cyclePhase.symptoms.$cyclePhaseKey')
              _buildInfoSection(
                context,
                CustomIcons.symptoms(size: 34),
                'info.cyclePhase.possibleSymptoms'.tr(),
                null,
                'info.cyclePhase.symptoms.$cyclePhaseKey'.tr(),
              ),
          ],
        ),
      ),
    );
  }

  String _getFormattedCycleStart(BuildContext context) {
    if (cycleDay == 1) return 'info.cyclePhase.cycleStartedToday'.tr();
    final start = DateTime.now().subtract(Duration(days: cycleDay - 1));
    return '${'info.cyclePhase.cycleStartedOn'.tr()} ${DateFormat.MMMd(context.locale.toString()).format(start)}';
  }

  Widget _buildInfoSection(BuildContext context, Widget icon, String title, String? subtitle, String description) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 12),
              Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          Text(description, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
