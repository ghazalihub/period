import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../ui/widgets/custom_button.dart';

class NotesEditorScreen extends StatefulWidget {
  final String initialNotes;

  const NotesEditorScreen({super.key, required this.initialNotes});

  @override
  State<NotesEditorScreen> createState() => _NotesEditorScreenState();
}

class _NotesEditorScreenState extends State<NotesEditorScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.panel,
      appBar: AppBar(
        title: Text('health.tracking.notes'.tr()),
        backgroundColor: colors.panel,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.pop(_controller.text),
            child: Text('common.buttons.done'.tr(), style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                maxLines: null,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'health.tracking.notesEditorPlaceholder'.tr(),
                  hintStyle: TextStyle(color: colors.placeholder),
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (value.text.trim().isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                child: CustomButton(
                  title: 'common.buttons.done'.tr(),
                  fullWidth: true,
                  onPress: () => context.pop(_controller.text),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
