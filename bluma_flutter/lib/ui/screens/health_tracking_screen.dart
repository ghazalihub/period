import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../providers/database_provider.dart';
import '../core/constants/health_constants.dart';
import '../ui/widgets/date_navigator.dart';
import '../ui/widgets/health_item_grid.dart';
import '../ui/widgets/custom_button.dart';
import 'notes_editor_screen.dart';

class HealthTrackingScreen extends ConsumerStatefulWidget {
  final String? initialDate;
  final String? scrollTo;

  const HealthTrackingScreen({super.key, this.initialDate, this.scrollTo});

  @override
  ConsumerState<HealthTrackingScreen> createState() => _HealthTrackingScreenState();
}

class _HealthTrackingScreenState extends ConsumerState<HealthTrackingScreen> {
  late String _selectedDate;
  final Set<String> _selectedSymptoms = {};
  final Set<String> _selectedMoods = {};
  final Set<String> _selectedFlows = {};
  final Set<String> _selectedDischarges = {};
  String _notes = '';

  Set<String> _originalSymptoms = {};
  Set<String> _originalMoods = {};
  Set<String> _originalFlows = {};
  Set<String> _originalDischarges = {};
  String _originalNotes = '';

  bool _isPeriodDate = false;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? _dateFormat.format(DateTime.now());
    _loadData();
  }

  Future<void> _loadData() async {
    final healthRepo = ref.read(healthRepositoryProvider);
    final periodRepo = ref.read(periodRepositoryProvider);

    // Check if it's period date
    final dates = await periodRepo.getAllPeriodDates();
    _isPeriodDate = dates.any((e) => e.date == _selectedDate);

    final logs = await healthRepo.getHealthLogsByDate(_selectedDate);

    setState(() {
      _selectedSymptoms.clear();
      _selectedMoods.clear();
      _selectedFlows.clear();
      _selectedDischarges.clear();
      _notes = '';

      for (final log in logs) {
        if (log.type == 'symptom') _selectedSymptoms.add(log.itemId);
        else if (log.type == 'mood') _selectedMoods.add(log.itemId);
        else if (log.type == 'flow') _selectedFlows.add(log.itemId);
        else if (log.type == 'discharge') _selectedDischarges.add(log.itemId);
        else if (log.type == 'notes') _notes = log.name ?? '';
      }

      _originalSymptoms = Set.from(_selectedSymptoms);
      _originalMoods = Set.from(_selectedMoods);
      _originalFlows = Set.from(_selectedFlows);
      _originalDischarges = Set.from(_selectedDischarges);
      _originalNotes = _notes;
    });
  }

  bool _hasChanges() {
    return !SetEquality().equals(_selectedSymptoms, _originalSymptoms) ||
        !SetEquality().equals(_selectedMoods, _originalMoods) ||
        !SetEquality().equals(_selectedFlows, _originalFlows) ||
        !SetEquality().equals(_selectedDischarges, _originalDischarges) ||
        _notes != _originalNotes;
  }

  Future<void> _saveChanges() async {
    final healthRepo = ref.read(healthRepositoryProvider);
    // Delete existing
    final existing = await healthRepo.getHealthLogsByDate(_selectedDate);
    for (final log in existing) {
      await healthRepo.removeHealthLog(date: _selectedDate, type: log.type, itemId: log.itemId);
    }

    for (final id in _selectedSymptoms) {
      await healthRepo.addHealthLog(date: _selectedDate, type: 'symptom', itemId: id);
    }
    for (final id in _selectedMoods) {
      await healthRepo.addHealthLog(date: _selectedDate, type: 'mood', itemId: id);
    }
    for (final id in _selectedFlows) {
      await healthRepo.addHealthLog(date: _selectedDate, type: 'flow', itemId: id);
    }
    for (final id in _selectedDischarges) {
      await healthRepo.addHealthLog(date: _selectedDate, type: 'discharge', itemId: id);
    }
    if (_notes.isNotEmpty) {
      await healthRepo.addHealthLog(date: _selectedDate, type: 'notes', itemId: 'notes', name: _notes);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('health.tracking.successMessage'.tr())));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('health.quickHealthSelector.title'.tr(), style: TextStyle(color: colors.textPrimary, fontSize: 18)),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          DateNavigator(
            selectedDate: _selectedDate,
            onDateChange: (date) {
              setState(() => _selectedDate = date);
              _loadData();
            },
            maxDate: _dateFormat.format(DateTime.now()),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isPeriodDate) ...[
                    _buildSectionTitle('health.tracking.flow'),
                    HealthItemGrid(
                      items: flows,
                      selectedIds: _selectedFlows,
                      onToggle: (id) => setState(() => _selectedFlows.contains(id) ? _selectedFlows.remove(id) : _selectedFlows.add(id)),
                      translationKey: 'health.flows',
                      selectionColor: SelectionColors.flow,
                      type: 'flow',
                    ),
                    const SizedBox(height: 24),
                  ],
                  _buildSectionTitle('health.tracking.symptoms'),
                  HealthItemGrid(
                    items: symptoms,
                    selectedIds: _selectedSymptoms,
                    onToggle: (id) => setState(() => _selectedSymptoms.contains(id) ? _selectedSymptoms.remove(id) : _selectedSymptoms.add(id)),
                    translationKey: 'health.symptoms',
                    selectionColor: SelectionColors.symptom,
                    type: 'symptom',
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('health.tracking.moods'),
                  HealthItemGrid(
                    items: moods,
                    selectedIds: _selectedMoods,
                    onToggle: (id) => setState(() => _selectedMoods.contains(id) ? _selectedMoods.remove(id) : _selectedMoods.add(id)),
                    translationKey: 'health.moods',
                    selectionColor: SelectionColors.mood,
                    type: 'mood',
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('health.tracking.discharge'),
                  HealthItemGrid(
                    items: discharges,
                    selectedIds: _selectedDischarges,
                    onToggle: (id) => setState(() => _selectedDischarges.contains(id) ? _selectedDischarges.remove(id) : _selectedDischarges.add(id)),
                    translationKey: 'health.discharge',
                    selectionColor: SelectionColors.discharge,
                    type: 'discharge',
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('health.tracking.notes', trailing: Row(
                    children: [
                      if (_notes.isNotEmpty)
                        IconButton(icon: Icon(Icons.delete_outline, color: colors.neutral400), onPressed: () => setState(() => _notes = '')),
                      IconButton(icon: Icon(Icons.edit_outlined, color: colors.neutral400), onPressed: _openNotesEditor),
                    ],
                  )),
                  GestureDetector(
                    onTap: _openNotesEditor,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _notes.isNotEmpty ? _notes : 'health.tracking.notesPlaceholder'.tr(),
                        style: TextStyle(color: _notes.isNotEmpty ? colors.textPrimary : colors.placeholder, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _hasChanges()
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                title: 'common.buttons.save'.tr(),
                fullWidth: true,
                onPress: _saveChanges,
              ),
            )
          : null,
    );
  }

  Widget _buildSectionTitle(String key, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  void _openNotesEditor() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => NotesEditorScreen(initialNotes: _notes)),
    );
    if (result != null) {
      setState(() => _notes = result);
    }
  }
}

class SetEquality {
  bool equals(Set a, Set b) {
    if (a.length != b.length) return false;
    return a.every((e) => b.contains(e));
  }
}
