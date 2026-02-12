import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget icon;
  final String? status; // 'normal', 'irregular'
  final String? type; // 'cycle', 'period'

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.status,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: type != null ? () {
        final path = type == 'cycle' ? '/info/cycle-length-info' : '/info/period-length-info';
        context.push(path);
      } : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: colors.surfaceVariant2,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: icon,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: colors.textPrimary, fontSize: 16),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (type != null)
                  Icon(Icons.info_outline, size: 20, color: colors.textSecondary),
                if (status != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        status == 'normal' ? Icons.check_circle : Icons.error_outline,
                        size: 20,
                        color: status == 'normal' ? colors.success : colors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status == 'normal' ? 'common.status.normal'.tr() : 'common.status.irregular'.tr(),
                        style: TextStyle(color: colors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
