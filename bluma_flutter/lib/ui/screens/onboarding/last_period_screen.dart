import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/database_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_checkbox.dart';

class LastPeriodScreen extends ConsumerStatefulWidget {
  const LastPeriodScreen({super.key});

  @override
  ConsumerState<LastPeriodScreen> createState() => _LastPeriodScreenState();
}

class _LastPeriodScreenState extends ConsumerState<LastPeriodScreen> {
  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now();
  bool _dontKnow = false;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _handleNext() async {
    try {
      if (!_dontKnow && _selectedDate != null) {
        final periodRepo = ref.read(periodRepositoryProvider);
        final settingsRepo = ref.read(settingsRepositoryProvider);

        final startDateStr = _dateFormat.format(_selectedDate!);
        await periodRepo.addPeriodDate(startDateStr);

        final periodLengthStr = await settingsRepo.getSetting('userPeriodLength');
        final periodLength = int.tryParse(periodLengthStr ?? '5') ?? 5;

        for (int i = 1; i < periodLength; i++) {
          final nextDate = _selectedDate!.add(Duration(days: i));
          await periodRepo.addPeriodDate(_dateFormat.format(nextDate));
        }
      }

      final settingsRepo = ref.read(settingsRepositoryProvider);
      await settingsRepo.saveSetting('onboardingCompleted', 'true');

      if (mounted) context.push('/onboarding/success');
    } catch (e) {
      if (mounted) context.push('/onboarding/success');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.panel,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: colors.textPrimary, size: 24),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(active: false),
            _buildDot(active: false),
            _buildDot(active: true),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'onboarding.lastPeriod.title'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'onboarding.lastPeriod.subtitle'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 32),
                  Opacity(
                    opacity: _dontKnow ? 0.38 : 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.now().subtract(const Duration(days: 180)),
                        lastDay: DateTime.now(),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                        onDaySelected: _dontKnow
                            ? null
                            : (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDate = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                              },
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
                        ),
                        calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          defaultTextStyle: TextStyle(color: colors.textPrimary),
                          weekendTextStyle: TextStyle(color: colors.textPrimary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: CustomCheckbox(
                      checked: _dontKnow,
                      onToggle: () {
                        setState(() {
                          _dontKnow = !_dontKnow;
                          if (_dontKnow) _selectedDate = null;
                        });
                      },
                      text: 'onboarding.lastPeriod.checkboxText'.tr(),
                    ),
                  ),
                  if (_dontKnow) ...[
                    const SizedBox(height: 12),
                    Text(
                      'onboarding.lastPeriod.checkboxSubtext'.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
              title: 'common.continue'.tr(),
              fullWidth: true,
              disabled: !_dontKnow && _selectedDate == null,
              onPress: _handleNext,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool active}) {
    final colors = context.colors;
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? colors.primary : colors.neutral300,
      ),
    );
  }
}
