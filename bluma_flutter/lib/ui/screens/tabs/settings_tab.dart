import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/service_provider.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('settings.navigation.settings'.tr(), style: TextStyle(color: colors.textPrimary, fontSize: 18)),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              color: colors.surface,
              child: Column(
                children: [
                  _buildSettingRow(
                    context,
                    icon: Icons.alarm_outlined,
                    label: 'settings.reminders'.tr(),
                    onTap: () => context.push('/settings/reminders'),
                  ),
                  _buildDivider(colors),
                  _buildSettingRow(
                    context,
                    icon: Icons.lock_outline,
                    label: 'settings.appLock'.tr(),
                    onTap: () => context.push('/settings/app-lock'),
                  ),
                  _buildDivider(colors),
                  _buildSettingRow(
                    context,
                    icon: Icons.description_outlined,
                    label: 'settings.privacyPolicy'.tr(),
                    onTap: () => context.push('/settings/privacy-policy'),
                  ),
                  _buildDivider(colors),
                  _buildSettingRow(
                    context,
                    icon: Icons.info_outline,
                    label: 'settings.about'.tr(),
                    onTap: () => context.push('/settings/about'),
                  ),
                  _buildDivider(colors),
                  _buildSettingRow(
                    context,
                    icon: Icons.color_palette_outlined,
                    label: 'settings.theme'.tr(),
                    value: 'settings.themeOptions.system'.tr(), // Simplified
                    onTap: () => _showThemeSelection(context),
                  ),
                ],
              ),
            ),
            Container(
              color: colors.surface,
              child: _buildSettingRow(
                context,
                icon: Icons.delete_outline,
                label: 'settings.deleteData'.tr(),
                color: colors.error,
                onTap: () => _confirmDeleteData(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
    Color? color,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;
    final textColor = color ?? colors.textPrimary;

    return ListTile(
      leading: Icon(icon, color: color ?? colors.neutral200),
      title: Text(label, style: TextStyle(color: textColor, fontSize: 17)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(value, style: TextStyle(color: colors.textSecondary, fontSize: 17)),
          Icon(Icons.chevron_right, color: color ?? colors.textPrimary),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(AppColors colors) {
    return Divider(height: 1, color: colors.border, indent: 56);
  }

  void _showThemeSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.themeModal.title'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text('settings.themeOptions.system'.tr()), onTap: () => Navigator.pop(context)),
            ListTile(title: Text('settings.themeOptions.light'.tr()), onTap: () => Navigator.pop(context)),
            ListTile(title: Text('settings.themeOptions.dark'.tr()), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteData(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.deleteDataConfirm.title'.tr()),
        content: Text('settings.deleteDataConfirm.message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('settings.deleteDataConfirm.cancel'.tr()),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(dataDeletionServiceProvider).deleteAllUserData();
              if (context.mounted) {
                Navigator.pop(context);
                context.go('/onboarding');
              }
            },
            child: Text('settings.deleteDataConfirm.delete'.tr(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
