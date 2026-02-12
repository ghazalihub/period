import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';

class PredictionInfoScreen extends StatelessWidget {
  const PredictionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.panel,
      appBar: AppBar(
        title: Text('info.prediction.title'.tr()), // Guessed key
        backgroundColor: colors.panel,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/images/prediction.png', width: double.infinity, height: 200, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            _buildSection(context, 'info.prediction.nextPeriod.title'.tr(), 'info.prediction.nextPeriod.description'.tr()),
            _buildSection(context, 'info.prediction.cycleLengthCalc.title'.tr(),
                '${'info.prediction.cycleLengthCalc.description'.tr()}\n\n${'info.prediction.cycleLengthCalc.weighting'.tr()}'),
            _buildSection(context, 'info.prediction.ovulation.title'.tr(),
                '${'info.prediction.ovulation.description'.tr()}\n\n${'info.prediction.ovulation.fertileWindow'.tr()}'),
            _buildSection(context, 'info.prediction.accuracy.title'.tr(), 'info.prediction.accuracy.description'.tr()),
            _buildSection(context, 'info.prediction.privacy.title'.tr(), 'info.prediction.privacy.description'.tr()),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'info.prediction.disclaimerPrefix'.tr()),
                    TextSpan(text: 'info.prediction.disclaimerBold'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'info.prediction.disclaimerSuffix'.tr()),
                  ],
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
