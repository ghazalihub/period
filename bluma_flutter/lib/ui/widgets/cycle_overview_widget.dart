import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/date_utils.dart';
import '../domain/services/period_prediction_service.dart';
import 'dashed_circle.dart';
import 'link_button.dart';
import 'custom_button.dart';

class CycleOverviewWidget extends StatelessWidget {
  final DateTime currentDate;
  final bool isPeriodDay;
  final int periodDayNumber;
  final PredictionResult? prediction;
  final List<String> selectedDates;
  final int? currentCycleDay;
  final int averageCycleLength;

  const CycleOverviewWidget({
    super.key,
    required this.currentDate,
    required this.isPeriodDay,
    required this.periodDayNumber,
    this.prediction,
    required this.selectedDates,
    this.currentCycleDay,
    required this.averageCycleLength,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isPredictedPeriodDay = prediction?.days == 0;
    final isSpecialDay = isPeriodDay || isPredictedPeriodDay;
    final circleTextColor = isSpecialDay && isDark ? colors.black : colors.textPrimary;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            DashedCircle(
              size: 350,
              strokeWidth: 3,
              dashLength: 3,
              dashCount: 120,
              strokeColor: isSpecialDay ? colors.predictionCirclePeriodOuter : null,
            ),
            Container(
              width: 310,
              height: 310,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSpecialDay
                    ? colors.predictionCirclePeriodBackground
                    : colors.predictionCircleBackground,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppDateUtils.formatTodayShort(currentDate, context),
                    style: Theme.of(context).textTheme.bodyBold.copyWith(
                          color: circleTextColor,
                        ),
                  ),
                  const SizedBox(height: 20),
                  if (isPeriodDay) ...[
                    Text(
                      'home.period'.tr(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: circleTextColor,
                          ),
                    ),
                    Text(
                      'home.periodDay'.tr(namedArgs: {'number': '$periodDayNumber'}),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: circleTextColor,
                            fontSize: 48,
                            height: 1.2,
                          ),
                    ),
                  ] else if (prediction != null) ...[
                    if (prediction!.days > 0) ...[
                      Text(
                        'home.nextPeriodIn'.tr(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: circleTextColor,
                            ),
                      ),
                      Text(
                        'home.daysCount'.tr(plural: prediction!.days),
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: circleTextColor,
                              fontSize: 48,
                              height: 1.2,
                            ),
                      ),
                    ] else if (prediction!.days == 0) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'home.expectedToday'.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: circleTextColor,
                                height: 1.2,
                              ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'home.lateFor'.tr(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: circleTextColor,
                            ),
                      ),
                      Text(
                        'home.daysCount'.tr(plural: prediction!.days.abs()),
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: circleTextColor,
                              fontSize: 48,
                              height: 1.2,
                            ),
                      ),
                      LinkButton(
                        title: 'home.learnAboutLatePeriods'.tr(),
                        onPress: () => context.push('/info/late-period-info'),
                      ),
                    ],
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'home.noDataPrompt'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: circleTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 28 / 20,
                            ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  CustomButton(
                    title: (prediction != null && prediction!.days < 0) || prediction == null
                        ? 'home.logPeriod'.tr()
                        : 'home.logOrEdit'.tr(),
                    onPress: () => context.push('/edit-period'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
