import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class DayPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChange;
  final int min;
  final int max;
  final bool disabled;

  const DayPicker({
    super.key,
    required this.value,
    required this.onChange,
    required this.min,
    required this.max,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Opacity(
      opacity: disabled ? 0.38 : 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              context,
              Icons.remove,
              disabled ? null : () => onChange(value > min ? value - 1 : min),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 80,
              child: Column(
                children: [
                  Text(
                    '$value',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                  ),
                  Text(
                    'common.time.days'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 20,
                          color: colors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            _buildButton(
              context,
              Icons.add,
              disabled ? null : () => onChange(value < max ? value + 1 : max),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, VoidCallback? onPress) {
    final colors = context.colors;
    return Material(
      color: colors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPress,
        customBorder: const CircleBorder(),
        child: Container(
          width: 54,
          height: 54,
          alignment: Alignment.center,
          child: Icon(icon, color: colors.white, size: 32),
        ),
      ),
    );
  }
}
