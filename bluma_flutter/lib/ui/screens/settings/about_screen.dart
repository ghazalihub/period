import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const String githubUrl = 'https://github.com/blumaHQ/bluma-app';
    const String gplUrl = 'https://www.gnu.org/licenses/gpl-3.0.en.html';

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text('settings.about'.tr()),
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('settings.aboutScreen.title'.tr(), style: Theme.of(context).textTheme.headlineLarge),
            Text('${'settings.aboutScreen.versionLabel'.tr()} 1.0.0', style: TextStyle(color: colors.textSecondary)),
            const SizedBox(height: 8),
            Text('settings.aboutScreen.whatIs.description'.tr()),
            const SizedBox(height: 24),
            _buildSection(context, Icons.calendar_today_outlined, 'settings.aboutScreen.features.title'.tr(), [
              'periodTracking', 'predictions', 'symptomsTracking', 'statistics', 'insights', 'reminders', 'lock', 'theme'
            ].map((f) => 'settings.aboutScreen.features.$f'.tr()).toList()),
            _buildSection(context, Icons.shield_outlined, 'settings.aboutScreen.privacyFirst.title'.tr(), [
              'local', 'noTransmission', 'noTracking', 'noAds', 'noAccount'
            ].map((p) => 'settings.aboutScreen.privacyFirst.$p'.tr()).toList(),
            description: 'settings.aboutScreen.privacyFirst.description'.tr()),
            _buildSectionTitle(context, Icons.description_outlined, 'settings.aboutScreen.openSource.title'.tr()),
            Text.rich(TextSpan(children: [
              TextSpan(text: 'settings.aboutScreen.openSource.description'.tr()),
              WidgetSpan(child: GestureDetector(
                onTap: () => launchUrl(Uri.parse(gplUrl)),
                child: Text(' GNU GPL v3', style: TextStyle(color: colors.primary, decoration: TextDecoration.underline)),
              )),
              const TextSpan(text: '.'),
            ])),
            const SizedBox(height: 8),
            Text('settings.aboutScreen.openSource.warranty'.tr()),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => launchUrl(Uri.parse(githubUrl)),
              child: Text('settings.aboutScreen.openSource.viewSource'.tr(), style: TextStyle(color: colors.primary, decoration: TextDecoration.underline)),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, Icons.person_outline, 'settings.aboutScreen.developer.title'.tr()),
            Text('settings.aboutScreen.developer.description'.tr()),
            const SizedBox(height: 24),
            _buildSectionTitle(context, Icons.code, 'settings.aboutScreen.technical.title'.tr()),
            Text('settings.aboutScreen.technical.description'.tr()),
            ...['framework', 'database', 'encryption', 'architecture', 'language', 'platform'].map((item) {
              final fullText = 'settings.aboutScreen.technical.$item'.tr();
              final colonIndex = fullText.indexOf(':');
              if (colonIndex == -1) return Text('• $fullText');
              final label = fullText.substring(0, colonIndex + 1);
              final value = fullText.substring(colonIndex + 1);
              return Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text.rich(TextSpan(children: [
                  const TextSpan(text: '• '),
                  TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value),
                ])),
              );
            }),
            const SizedBox(height: 40),
            Center(
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'settings.aboutScreen.footer.prefix'.tr()),
                  TextSpan(text: 'settings.aboutScreen.footer.email'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'settings.aboutScreen.footer.suffix'.tr()),
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

  Widget _buildSection(BuildContext context, IconData icon, String title, List<String> items, {String? description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, icon, title),
          if (description != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(description)),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 18)),
                Expanded(child: Text(item)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, IconData icon, String title) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: colors.accentPink, size: 24),
          const SizedBox(width: 12),
          Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
