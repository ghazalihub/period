import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool checked;
  final VoidCallback onToggle;
  final String? text;
  final String? subText;

  const CustomCheckbox({
    super.key,
    required this.checked,
    required this.onToggle,
    this.text,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onToggle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: checked ? colors.primary : Colors.transparent,
                  border: Border.all(color: colors.primary, width: 2.5),
                  shape: BoxShape.circle,
                ),
                child: checked
                    ? Icon(Icons.check, size: 16, color: colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                text ?? '',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          if (subText != null) ...[
            const SizedBox(height: 5),
            Text(
              subText!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: colors.textSecondary,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
