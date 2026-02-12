import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';

class LatePeriodInfoScreen extends StatelessWidget {
  const LatePeriodInfoScreen({super.key});

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
              child: Image.asset('assets/images/prediction.png', width: double.infinity, height: 200, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            Text('info.latePeriod.whatMeans.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('info.latePeriod.whatMeans.description'.tr()),
            const SizedBox(height: 32),
            Text('info.latePeriod.causes.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...['stress', 'weight', 'exercise', 'sleep', 'illness', 'medications', 'pcos', 'pregnancy', 'perimenopause'].map((cause) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18)),
                  Expanded(child: Text.rich(TextSpan(children: [
                    TextSpan(text: 'info.latePeriod.causes.${cause}Bold'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'info.latePeriod.causes.${cause}Suffix'.tr()),
                  ]))),
                ],
              ),
            )),
            const SizedBox(height: 32),
            Text('info.latePeriod.seeDoctor.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('info.latePeriod.seeDoctor.description'.tr()),
            const SizedBox(height: 32),
            Text('info.latePeriod.whatToDo.title'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...['pregnancy', 'stress', 'weight', 'sleep', 'track', 'patience'].map((item) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18)),
                  Expanded(child: Text('info.latePeriod.whatToDo.$item'.tr())),
                ],
              ),
            )),
            const SizedBox(height: 32),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'info.latePeriod.disclaimerBold'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' '),
              TextSpan(text: 'info.latePeriod.disclaimer'.tr()),
            ])),
            const SizedBox(height: 32),
            Text('info.latePeriod.references.title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('info.latePeriod.references.acog'.tr(), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
