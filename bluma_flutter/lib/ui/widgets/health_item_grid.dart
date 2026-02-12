import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/health_constants.dart';
import '../../core/theme/app_colors.dart';
import 'health_icon.dart';

class HealthItemGrid extends StatelessWidget {
  final List<HealthItem> items;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;
  final String translationKey;
  final Color selectionColor;
  final double iconSize;
  final String type;

  const HealthItemGrid({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onToggle,
    required this.translationKey,
    required this.selectionColor,
    this.iconSize = 50,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedIds.contains(item.id);

        return GestureDetector(
          onTap: () => onToggle(item.id),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: selectionColor, width: 2) : null,
                    ),
                    alignment: Alignment.center,
                    child: HealthIcon(type: type, itemId: item.id, size: iconSize),
                  ),
                  if (isSelected)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: selectionColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.surface, width: 2),
                        ),
                        child: const Icon(Icons.check, size: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                '$translationKey.${item.id}'.tr(),
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 12, height: 1.2),
              ),
            ],
          ),
        );
      },
    );
  }
}
