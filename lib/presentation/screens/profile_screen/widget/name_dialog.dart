
import 'package:expense/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditTextDialog extends ConsumerWidget {
  final String title;
  final String hintText;
  final String initialValue;
  final String saveText;
  final void Function(String value) onSave;

  const EditTextDialog({
    super.key,
    required this.title,
    required this.onSave,
    this.hintText = '',
    this.initialValue = '',
    this.saveText = 'Save',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: initialValue);

    return AlertDialog(
      title: Center(child: Text(title)),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final value = controller.text.trim();

            if (value.isEmpty) return;

            onSave(value);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: AppColors.appWhite,
          ),
          child: Text(saveText),
        ),
      ],
    );
  }
}
