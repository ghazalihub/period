import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/cycle_utils.dart';
import '../ui/widgets/custom_icons.dart';

class CycleDetailsScreen extends StatelessWidget {
  final String startDate;
  final String endDate;
  final int cycleLength;
  final int periodLength;
  final bool isCurrentCycle;

  const CycleDetailsScreen({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.cycleLength,
    required this.periodLength,
    required this.isCurrentCycle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cycleStatus = CycleUtils.getCycleStatus(cycleLength);
    final periodStatus = CycleUtils.getPeriodStatus(periodLength);

    final formattedStart = DateFormat.MMMd(context.locale.toString()).format(DateTime.parse(startDate));
    final formattedEnd = isCurrentCycle ? 'common.time.today'.tr() : DateFormat.MMMd(context.locale.toString()).format(DateTime.parse(endDate));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('stats.cycleDetails.title'.tr()),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (isCurrentCycle)
              _buildHeaderCard(context, [
                Text(
                  '${'stats.cycleHistory.currentCycle'.tr()}: $cycleLength ${cycleLength == 1 ? 'common.time.day'.tr() : 'common.time.days'.tr()}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text('$formattedStart - $formattedEnd', style: TextStyle(color: colors.textSecondary)),
                if (cycleLength > 35) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: colors.warningLight, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline, color: colors.warning),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(TextSpan(children: [
                                TextSpan(text: 'stats.cycleDetails.periodOverdueBefore'.tr()),
                                TextSpan(text: ' ${cycleLength - 35} ${cycleLength - 35 == 1 ? 'common.time.day'.tr() : 'common.time.days'.tr()} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: 'stats.cycleDetails.periodOverdueAfter'.tr()),
                              ])),
                              TextButton(
                                onPressed: () => context.push('/info/late-period-info'),
                                child: Text('stats.cycleDetails.learnAboutLatePeriod'.tr(), style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ])
            else ...[
              _buildHeaderCard(context, [
                Row(
                  children: [
                    CustomIcons.cycle(size: 32),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: 'stats.cycleDetails.cycleLastedBefore'.tr()),
                        TextSpan(text: ' $formattedStart ', style: const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: 'stats.cycleDetails.cycleLastedMiddle'.tr()),
                        TextSpan(text: ' $formattedEnd ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ])),
                    ),
                  ],
                ),
              ]),
              _buildDetailCard(
                context,
                title: 'stats.cycleHistory.cycleLength'.tr(),
                value: '$cycleLength ${cycleLength == 1 ? 'common.time.day'.tr() : 'common.time.days'.tr()}',
                status: cycleStatus,
                rangeText: cycleStatus == 'normal' ? 'stats.cycleDetails.cycleNormalRange'.tr() : 'stats.cycleDetails.cycleIrregularRange'.tr(),
                onTap: () => context.push('/info/cycle-length-info'),
              ),
              _buildDetailCard(
                context,
                title: 'stats.cycleHistory.periodLength'.tr(),
                value: '$periodLength ${periodLength == 1 ? 'common.time.day'.tr() : 'common.time.days'.tr()}',
                status: periodStatus,
                rangeText: periodStatus == 'normal' ? 'stats.cycleDetails.periodNormalRange'.tr() : 'stats.cycleDetails.periodIrregularRange'.tr(),
                onTap: () => context.push('/info/period-length-info'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, List<Widget> children) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildDetailCard(BuildContext context, {required String title, required String value, required String status, required String rangeText, required VoidCallback onTap}) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w500)),
                Icon(Icons.info_outline, size: 20, color: colors.textSecondary),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(status == 'normal' ? Icons.check_circle : Icons.error_outline, color: status == 'normal' ? colors.success : colors.warning, size: 20),
                    const SizedBox(width: 4),
                    Text(status == 'normal' ? 'common.status.normal'.tr() : 'common.status.irregular'.tr(), style: TextStyle(color: colors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(rangeText, style: TextStyle(color: colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
