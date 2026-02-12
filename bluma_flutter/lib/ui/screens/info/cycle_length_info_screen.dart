import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';

class CycleLengthInfoScreen extends StatelessWidget {
  const CycleLengthInfoScreen({super.key});

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
              child: Image.asset('assets/images/cycle-info.png', width: double.infinity, height: 200, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            Text('info.cycleLength.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'info.cycleLength.definitionBold'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.cycleLength.definitionText'.tr()),
            ])),
            const SizedBox(height: 32),
            Text('info.cycleLength.normalRange.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'info.cycleLength.normalRange.acogPrefix'.tr()),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.cycleLength.normalRange.acogName'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: 'info.cycleLength.normalRange.acogSuffix'.tr()),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.cycleLength.normalRange.daysRange'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: '.'),
            ])),
            const SizedBox(height: 8),
            Text('info.cycleLength.normalRange.variation'.tr()),
            const SizedBox(height: 32),
            Text('info.cycleLength.irregular.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'info.cycleLength.irregular.descriptionPrefix'.tr()),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.cycleLength.irregular.daysRange'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.cycleLength.irregular.descriptionSuffix'.tr()),
            ])),
            const SizedBox(height: 8),
            ...['hormonal', 'stress', 'medical', 'pcos', 'weight', 'lifestage', 'postpartum'].map((cause) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18)),
                  Expanded(child: Text('info.cycleLength.irregular.causes.$cause'.tr())),
                ],
              ),
            )),
            const SizedBox(height: 16),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'info.cycleLength.irregular.dataNoteBold'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.cycleLength.irregular.dataNote'.tr()),
            ])),
            const SizedBox(height: 32),
            Text('info.cycleLength.seeDoctor.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('info.cycleLength.seeDoctor.description'.tr()),
            const SizedBox(height: 32),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'info.cycleLength.disclaimerBold'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.cycleLength.disclaimer'.tr()),
            ])),
            const SizedBox(height: 32),
            Text('info.cycleLength.references.title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('info.cycleLength.references.acog'.tr(), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
