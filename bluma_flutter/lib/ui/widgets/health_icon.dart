import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/health_constants.dart';

class HealthIcon extends StatelessWidget {
  final String type; // 'symptom', 'mood', 'flow', 'discharge', 'notes'
  final String itemId;
  final double size;

  const HealthIcon({
    super.key,
    required this.type,
    required this.itemId,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    if (type == 'notes') {
      return SvgPicture.asset('assets/icons/health/note.svg', width: size, height: size);
    }

    String? iconName;
    String folder = '';

    if (type == 'symptom') {
      iconName = symptoms.firstWhere((s) => s.id == itemId, orElse: () => symptoms[0]).icon;
      folder = 'symptoms';
    } else if (type == 'mood') {
      iconName = moods.firstWhere((m) => m.id == itemId, orElse: () => moods[0]).icon;
      folder = 'moods';
    } else if (type == 'flow') {
      iconName = flows.firstWhere((f) => f.id == itemId, orElse: () => flows[0]).icon;
      folder = 'flows';
    } else if (type == 'discharge') {
      iconName = discharges.firstWhere((d) => d.id == itemId, orElse: () => discharges[0]).icon;
      folder = 'discharge';
    }

    if (iconName != null) {
      final fileName = iconName.replaceAll(' ', '-');
      return SvgPicture.asset('assets/icons/health/$folder/$fileName.svg', width: size, height: size);
    }

    return SvgPicture.asset('assets/icons/health/symptoms/im-okay.svg', width: size, height: size);
  }
}
