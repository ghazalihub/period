import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text('settings.privacyPolicy'.tr()),
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('settings.privacyPolicyScreen.title'.tr(), style: Theme.of(context).textTheme.headlineLarge),
            Text('${'settings.privacyPolicyScreen.lastUpdated'.tr()} ${DateFormat.yMd(context.locale.toString()).format(DateTime.now())}', style: TextStyle(color: colors.textSecondary)),
            const SizedBox(height: 8),
            Text('settings.privacyPolicyScreen.introduction.description'.tr()),
            const SizedBox(height: 24),
            _buildHeader('settings.privacyPolicyScreen.dataUse.title'.tr()),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'settings.privacyPolicyScreen.dataUse.descriptionPrefix'.tr()),
              TextSpan(text: 'settings.privacyPolicyScreen.dataUse.descriptionBold'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: 'settings.privacyPolicyScreen.dataUse.descriptionSuffix'.tr()),
            ])),
            ...['periodDates', 'cycleLength', 'symptoms', 'notes', 'settings'].map((item) => _buildListItem('settings.privacyPolicyScreen.dataUse.$item'.tr())),
            Text('settings.privacyPolicyScreen.dataUse.usage'.tr()),
            Text('settings.privacyPolicyScreen.dataUse.deletion'.tr()),
            const SizedBox(height: 24),
            _buildHeader('settings.privacyPolicyScreen.permissions.title'.tr()),
            Text('settings.privacyPolicyScreen.permissions.description'.tr()),
            ...['reminders', 'biometric'].map((p) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18)),
                  Expanded(child: Text.rich(TextSpan(children: [
                    TextSpan(text: 'settings.privacyPolicyScreen.permissions.$p'.tr()),
                    TextSpan(text: 'settings.privacyPolicyScreen.permissions.${p}Bold'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'settings.privacyPolicyScreen.permissions.${p}Suffix'.tr()),
                  ]))),
                ],
              ),
            )),
            Text('settings.privacyPolicyScreen.permissions.revoke'.tr()),
            const SizedBox(height: 24),
            _buildHeader('settings.privacyPolicyScreen.transparency.title'.tr()),
            Text('settings.privacyPolicyScreen.transparency.description'.tr()),
            ...['localStorage', 'noTransmission', 'noAnalytics', 'noAds'].map((item) => _buildListItem('settings.privacyPolicyScreen.transparency.$item'.tr())),
            Text('settings.privacyPolicyScreen.transparency.control'.tr()),
            const SizedBox(height: 40),
            Center(
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'settings.privacyPolicyScreen.footer.prefix'.tr()),
                  TextSpan(text: 'settings.privacyPolicyScreen.footer.email'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'settings.privacyPolicyScreen.footer.suffix'.tr()),
                ]),
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textSecondary),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
