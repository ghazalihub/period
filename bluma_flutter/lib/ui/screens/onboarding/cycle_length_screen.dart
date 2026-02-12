import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/database_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/day_picker.dart';
import '../../widgets/custom_checkbox.dart';

class CycleLengthScreen extends ConsumerStatefulWidget {
  const CycleLengthScreen({super.key});

  @override
  ConsumerState<CycleLengthScreen> createState() => _CycleLengthScreenState();
}

class _CycleLengthScreenState extends ConsumerState<CycleLengthScreen> {
  int _cycleLength = 28;
  bool _dontKnow = false;

  Future<void> _handleNext() async {
    try {
      if (!_dontKnow) {
        final repo = ref.read(settingsRepositoryProvider);
        await repo.saveSetting('userCycleLength', _cycleLength.toString());
      }
      if (mounted) context.push('/onboarding/last-period');
    } catch (e) {
      if (mounted) context.push('/onboarding/last-period');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.panel,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: colors.textPrimary, size: 24),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(active: false),
            _buildDot(active: true),
            _buildDot(active: false),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'onboarding.cycleLength.title'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'onboarding.cycleLength.subtitle'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 32),
                  DayPicker(
                    value: _cycleLength,
                    min: 21,
                    max: 45,
                    disabled: _dontKnow,
                    onChange: (val) => setState(() => _cycleLength = val),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: CustomCheckbox(
                      checked: _dontKnow,
                      onToggle: () => setState(() => _dontKnow = !_dontKnow),
                      text: 'onboarding.cycleLength.checkboxText'.tr(),
                      subText: 'onboarding.cycleLength.checkboxSubtext'.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
              title: 'common.continue'.tr(),
              fullWidth: true,
              onPress: _handleNext,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool active}) {
    final colors = context.colors;
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? colors.primary : colors.neutral300,
      ),
    );
  }
}
