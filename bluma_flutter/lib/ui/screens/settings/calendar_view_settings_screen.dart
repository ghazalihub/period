import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/database_provider.dart';

class CalendarViewSettingsScreen extends ConsumerStatefulWidget {
  const CalendarViewSettingsScreen({super.key});

  @override
  ConsumerState<CalendarViewSettingsScreen> createState() => _CalendarViewSettingsScreenState();
}

class _CalendarViewSettingsScreenState extends ConsumerState<CalendarViewSettingsScreen> {
  bool _showOvulation = true;
  bool _showFuturePeriods = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    final ovulation = await repo.getSetting('show_ovulation');
    final future = await repo.getSetting('show_future_periods');

    setState(() {
      _showOvulation = ovulation != 'false';
      _showFuturePeriods = future != 'false';
      _isLoading = false;
    });
  }

  Future<void> _handleToggle(String key, bool value) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.saveSetting(key, value.toString());
    setState(() {
      if (key == 'show_ovulation') _showOvulation = value;
      if (key == 'show_future_periods') _showFuturePeriods = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('calendar.navigation.calendar'.tr()),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('calendar.view.displayOptions'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('calendar.view.showOvulation'.tr()),
                    value: _showOvulation,
                    onChanged: (val) => _handleToggle('show_ovulation', val),
                    activeColor: colors.primary,
                  ),
                  Divider(height: 1, color: colors.border, indent: 16),
                  SwitchListTile(
                    title: Text('calendar.view.showFuturePeriods'.tr()),
                    value: _showFuturePeriods,
                    onChanged: (val) => _handleToggle('show_future_periods', val),
                    activeColor: colors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('calendar.view.iconsShown'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  _buildLegendItem(context, 'calendar.legend.periodDays'.tr(), colors.accentPink, Colors.white, isPrediction: false),
                  _buildLegendItem(context, 'calendar.legend.futurePrediction'.tr(), colors.accentPinkLight, colors.accentPink, isPrediction: true, enabled: _showFuturePeriods),
                  _buildLegendItem(context, 'calendar.legend.ovulationDay'.tr(), colors.accentBlue, Colors.white, isOvulation: true, enabled: _showOvulation),
                  _buildLegendItem(context, 'calendar.legend.fertileWindow'.tr(), colors.accentBlue.withOpacity(0.3), colors.accentBlue, enabled: _showOvulation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color bgColor, Color textColor, {bool isPrediction = false, bool isOvulation = false, bool enabled = true}) {
    final colors = context.colors;
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: isOvulation ? Border.all(color: colors.accentBlue, width: 1.6) : null,
          ),
          alignment: Alignment.center,
          child: Text('1', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        ),
        title: Text(label),
      ),
    );
  }
}
