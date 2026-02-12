import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FAB extends StatelessWidget {
  final VoidCallback onPress;
  final IconData icon;
  final double iconSize;
  final String? label;

  const FAB({
    super.key,
    required this.onPress,
    this.icon = Icons.add,
    this.iconSize = 32,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.white, size: iconSize),
          ),
          if (label != null) ...[
            const SizedBox(height: 6),
            // Original RN FAB didn't actually show the label in the code provided,
            // but QuickHealthSelector passes it. In RN code, label wasn't used in FAB.
            // But let's add it if needed.
          ],
        ],
      ),
    );
  }
}
