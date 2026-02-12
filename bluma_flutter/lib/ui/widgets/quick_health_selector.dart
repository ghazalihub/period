import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/database_provider.dart';
import '../../data/database/app_database.dart';
import '../../core/constants/health_constants.dart';
import 'fab.dart';

class QuickHealthSelector extends ConsumerWidget {
  final String? selectedDate;

  const QuickHealthSelector({super.key, this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final dateToUse = selectedDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now());

    final healthLogsAsync = ref.watch(healthLogsProvider(dateToUse));

    return healthLogsAsync.when(
      data: (logs) {
        if (logs.isEmpty) {
          return GestureDetector(
            onTap: () => context.push(
              selectedDate != null ? '/health-tracking?date=$selectedDate' : '/health-tracking',
            ),
            child: Row(
              children: [
                FAB(onPress: () {}, icon: Icons.add),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null && selectedDate != DateFormat('yyyy-MM-dd').format(DateTime.now())
                        ? 'health.quickHealthSelector.noSymptomsThisDate'.tr()
                        : 'health.quickHealthSelector.noSymptomsToday'.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.placeholder,
                        ),
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          height: 90,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FAB(
                onPress: () => context.push(
                  selectedDate != null ? '/health-tracking?date=$selectedDate' : '/health-tracking',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: logs.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 0),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return _HealthLogItem(log: log, selectedDate: selectedDate);
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }
}

final healthLogsProvider = FutureProvider.family<List<HealthLog>, String>((ref, date) async {
  final repo = ref.watch(healthRepositoryProvider);
  return repo.getHealthLogsByDate(date);
});

class _HealthLogItem extends StatelessWidget {
  final HealthLog log;
  final String? selectedDate;

  const _HealthLogItem({required this.log, this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = _getIconComponent(log);
    final text = _getDisplayText(log);

    return GestureDetector(
      onTap: () {
        final Map<String, String> params = {};
        if (selectedDate != null) params['date'] = selectedDate!;

        switch (log.type) {
          case 'notes': params['scrollTo'] = 'notes'; break;
          case 'symptom': params['scrollTo'] = 'symptoms'; break;
          case 'mood': params['scrollTo'] = 'moods'; break;
          case 'discharge': params['scrollTo'] = 'discharge'; break;
          case 'flow': params['scrollTo'] = 'flow'; break;
        }

        context.push(Uri(path: '/health-tracking', queryParameters: params).toString());
      },
      child: Container(
        width: 80,
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              width: 54,
              height: 54,
              child: Center(child: icon),
            ),
            const SizedBox(height: 6),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 12,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconComponent(HealthLog log) {
    if (log.type == 'notes') {
      return SvgPicture.asset('assets/icons/health/note.svg', width: 54, height: 54);
    }

    String? iconName;
    String folder = '';

    if (log.type == 'symptom') {
      iconName = symptoms.firstWhere((s) => s.id == log.itemId, orElse: () => symptoms[0]).icon;
      folder = 'symptoms';
    } else if (log.type == 'mood') {
      iconName = moods.firstWhere((m) => m.id == log.itemId, orElse: () => moods[0]).icon;
      folder = 'moods';
    } else if (log.type == 'flow') {
      iconName = flows.firstWhere((f) => f.id == log.itemId, orElse: () => flows[0]).icon;
      folder = 'flows';
    } else if (log.type == 'discharge') {
      iconName = discharges.firstWhere((d) => d.id == log.itemId, orElse: () => discharges[0]).icon;
      folder = 'discharge';
    }

    if (iconName != null) {
      // Handle potential space in icon names like 'hot flashes' -> 'hot-flashes'
      final fileName = iconName.replaceAll(' ', '-');
      return SvgPicture.asset('assets/icons/health/$folder/$fileName.svg', width: 54, height: 54);
    }

    return SvgPicture.asset('assets/icons/health/symptoms/im-okay.svg', width: 54, height: 54);
  }

  String _getDisplayText(HealthLog log) {
    if (log.type == 'notes') {
      return 'health.quickHealthSelector.note'.tr();
    }

    if (log.type == 'symptom') {
      return 'health.symptoms.${log.itemId}'.tr();
    } else if (log.type == 'mood') {
      return 'health.moods.${log.itemId}'.tr();
    } else if (log.type == 'flow') {
      return 'health.flows.${log.itemId}'.tr();
    } else if (log.type == 'discharge') {
      return 'health.discharge.${log.itemId}'.tr();
    }

    return log.itemId;
  }
}
