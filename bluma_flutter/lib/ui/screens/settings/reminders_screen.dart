import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/service_provider.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  bool _beforePeriodEnabled = false;
  bool _dayOfPeriodEnabled = false;
  bool _latePeriodEnabled = false;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 10, minute: 0);
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notificationService = ref.read(notificationServiceProvider);
    final settings = await notificationService.getNotificationSettings();
    final prefs = await SharedPreferences.getInstance();

    final hour = int.tryParse(prefs.getString('notification_time_hour') ?? '10') ?? 10;
    final minute = int.tryParse(prefs.getString('notification_time_minute') ?? '0') ?? 0;

    setState(() {
      _beforePeriodEnabled = settings['beforePeriodEnabled']!;
      _dayOfPeriodEnabled = settings['dayOfPeriodEnabled']!;
      _latePeriodEnabled = settings['latePeriodEnabled']!;
      _notificationTime = TimeOfDay(hour: hour, minute: minute);
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    try {
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.saveNotificationSettings(
        _beforePeriodEnabled,
        _dayOfPeriodEnabled,
        _latePeriodEnabled,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_time_hour', _notificationTime.hour.toString());
      await prefs.setString('notification_time_minute', _notificationTime.minute.toString());
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('settings.reminders'.tr()),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildSwitchRow(
                  'settings.reminderSettings.beforePeriod'.tr(),
                  _beforePeriodEnabled,
                  (val) {
                    setState(() => _beforePeriodEnabled = val);
                    _saveSettings();
                  },
                ),
                _buildDivider(colors),
                _buildSwitchRow(
                  'settings.reminderSettings.dayOfPeriod'.tr(),
                  _dayOfPeriodEnabled,
                  (val) {
                    setState(() => _dayOfPeriodEnabled = val);
                    _saveSettings();
                  },
                ),
                _buildDivider(colors),
                _buildSwitchRow(
                  'settings.reminderSettings.latePeriod'.tr(),
                  _latePeriodEnabled,
                  (val) {
                    setState(() => _latePeriodEnabled = val);
                    _saveSettings();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text('settings.reminderSettings.reminderTime'.tr()),
              trailing: Text(
                _notificationTime.format(context),
                style: TextStyle(color: colors.primary, fontWeight: FontWeight.w500, fontSize: 16),
              ),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: _notificationTime);
                if (picked != null) {
                  setState(() => _notificationTime = picked);
                  _saveSettings();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    final colors = context.colors;
    return SwitchListTile(
      title: Text(label, style: const TextStyle(fontSize: 16)),
      value: value,
      onChanged: _isSaving ? null : onChanged,
      activeColor: colors.primary,
    );
  }

  Widget _buildDivider(AppColors colors) {
    return Divider(height: 1, color: colors.border, indent: 16);
  }
}
