import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/service_provider.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  bool _isLockEnabled = false;
  bool _isDeviceSecurityAvailable = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final authService = ref.read(authServiceProvider);
    final isAvailable = await authService.isDeviceSecurityAvailable();
    final isEnabled = await authService.isLockEnabled();

    setState(() {
      _isDeviceSecurityAvailable = isAvailable;
      _isLockEnabled = isEnabled;
      _isLoading = false;
    });
  }

  Future<void> _handleToggle(bool value) async {
    final authService = ref.read(authServiceProvider);
    if (value) {
      final success = await authService.authenticate();
      if (success) {
        await authService.setLockEnabled(true);
        setState(() => _isLockEnabled = true);
      }
    } else {
      await authService.setLockEnabled(false);
      setState(() => _isLockEnabled = false);
    }
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
        title: Text('settings.appLock'.tr()),
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
            child: ListTile(
              title: Text('settings.appLockSettings.unlockApp'.tr(), style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(
                _isDeviceSecurityAvailable
                    ? 'settings.appLockSettings.unlockDescription'.tr()
                    : 'settings.appLockSettings.noDeviceSecurityDescription'.tr(),
                style: TextStyle(color: colors.textSecondary),
              ),
              trailing: Switch(
                value: _isLockEnabled,
                onChanged: _isDeviceSecurityAvailable ? _handleToggle : null,
                activeColor: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
