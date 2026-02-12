import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class LinkButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final IconData iconName;
  final double iconSize;
  final bool showIcon;
  final double? fontSize;

  const LinkButton({
    super.key,
    required this.title,
    required this.onPress,
    this.iconName = Icons.chevron_right,
    this.iconSize = 16,
    this.showIcon = true,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyBold.copyWith(
                    color: colors.primary,
                    fontSize: fontSize,
                  ),
            ),
            if (showIcon) ...[
              const SizedBox(width: 2),
              Icon(
                iconName,
                size: iconSize,
                color: colors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
