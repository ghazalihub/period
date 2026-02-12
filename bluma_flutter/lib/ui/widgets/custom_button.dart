import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final String variant; // 'contained', 'text', 'outlined'
  final bool fullWidth;
  final bool disabled;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPress,
    this.variant = 'contained',
    this.fullWidth = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    ButtonStyle buttonStyle;
    TextStyle textStyle;

    switch (variant) {
      case 'text':
        buttonStyle = TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        );
        textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: colors.primary,
            );
        break;
      case 'outlined':
        buttonStyle = OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        );
        textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: colors.primary,
            );
        break;
      case 'contained':
      default:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        );
        textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: colors.white,
            );
        break;
    }

    Widget button;
    if (variant == 'text') {
      button = TextButton(onPressed: disabled ? null : onPress, style: buttonStyle, child: Text(title, style: textStyle));
    } else if (variant == 'outlined') {
      button = OutlinedButton(onPressed: disabled ? null : onPress, style: buttonStyle, child: Text(title, style: textStyle));
    } else {
      button = ElevatedButton(onPressed: disabled ? null : onPress, style: buttonStyle, child: Text(title, style: textStyle));
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
