import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/theme/app_colors.dart';
import '../providers/cycle_provider.dart';
import '../providers/database_provider.dart';
import '../domain/services/period_prediction_service.dart';
import '../ui/widgets/custom_button.dart';

class EditPeriodScreen extends ConsumerStatefulWidget {
  const EditPeriodScreen({super.key});

  @override
  ConsumerState<EditPeriodScreen> createState() => _EditPeriodScreenState();
}

class _EditPeriodScreenState extends ConsumerState<EditPeriodScreen> {
  final Set<String> _tempDates = {};
  int _userPeriodLength = 5;
  DateTime _focusedDay = DateTime.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final periodRepo = ref.read(periodRepositoryProvider);

    final lengthStr = await settingsRepo.getSetting('userPeriodLength');
    if (lengthStr != null) {
      _userPeriodLength = int.tryParse(lengthStr) ?? 5;
    }

    final dates = await periodRepo.getAllPeriodDates();
    setState(() {
      _tempDates.addAll(dates.map((e) => e.date));
    });
  }

  void _onDayPress(DateTime date) {
    if (date.isAfter(DateTime.now())) return;

    final dateStr = _dateFormat.format(date);
    setState(() {
      if (_tempDates.contains(dateStr)) {
        _tempDates.remove(dateStr);
      } else {
        // Logic from RN: if it's the start of a selection, add a range
        final prevDay = date.subtract(const Duration(days: 1));
        final prevDayStr = _dateFormat.format(prevDay);

        if (!_tempDates.contains(prevDayStr)) {
          for (int i = 0; i < _userPeriodLength; i++) {
            final d = date.add(Duration(days: i));
            if (!d.isAfter(DateTime.now())) {
              _tempDates.add(_dateFormat.format(d));
            }
          }
        } else {
          _tempDates.add(dateStr);
        }
      }
    });
  }

  Future<void> _handleSave() async {
    final periodRepo = ref.read(periodRepositoryProvider);
    await periodRepo.deleteAllPeriodDates();
    for (final date in _tempDates) {
      await periodRepo.addPeriodDate(date);
    }

    ref.refresh(periodDatesProvider);
    ref.refresh(cycleInfoProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('calendar.editPeriod.successMessage'.tr())),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.panel,
      appBar: AppBar(
        title: Text('calendar.editPeriod.title'.tr(), style: TextStyle(color: colors.textPrimary, fontSize: 18)),
        backgroundColor: colors.panel,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: _focusedDay,
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              onDaySelected: (selectedDay, focusedDay) {
                _onDayPress(selectedDay);
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final dayStr = _dateFormat.format(day);
                  if (_tempDates.contains(dayStr)) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.accentPink,
                        shape: BoxShape.circle,
                      ),
                      child: Text('${day.day}', style: const TextStyle(color: Colors.white)),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: 'common.buttons.cancel'.tr(),
                    variant: 'text',
                    onPress: () => context.pop(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    title: 'common.buttons.save'.tr(),
                    onPress: _handleSave,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
