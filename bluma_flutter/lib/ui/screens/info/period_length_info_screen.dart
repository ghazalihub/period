import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';

class PeriodLengthInfoScreen extends StatelessWidget {
  const PeriodLengthInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.panel,
      appBar: AppBar(backgroundColor: colors.panel, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/images/period-info.png', width: double.infinity, height: 200, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            Text('info.periodLength.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'info.periodLength.definitionBold'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.periodLength.definitionText'.tr()),
            ])),
            const SizedBox(height: 32),
            Text('info.periodLength.normal.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'info.periodLength.normal.acogPrefix'.tr()),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.periodLength.normal.acogName'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: 'info.periodLength.normal.acogSuffix'.tr()),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.periodLength.normal.daysRange'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: '.'),
            ])),
            const SizedBox(height: 12),
            Text('info.periodLength.normal.variation'.tr()),
            const SizedBox(height: 32),
            Text('info.periodLength.irregular.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('info.periodLength.irregular.description'.tr()),
            const SizedBox(height: 12),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'info.periodLength.irregular.dataNoteBold'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.periodLength.irregular.dataNote'.tr()),
            ])),
            const SizedBox(height: 32),
            Text('info.periodLength.seeDoctor.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('info.periodLength.seeDoctor.description'.tr()),
            const SizedBox(height: 32),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'info.periodLength.disclaimerBold'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.periodLength.disclaimer'.tr()),
            ])),
            const SizedBox(height: 32),
            Text('info.periodLength.references.title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('info.periodLength.references.acog'.tr(), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
