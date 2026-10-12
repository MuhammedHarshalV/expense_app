import 'package:expense/controller/profile_screen_controller/profile_controller.dart';
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
    final profileState = ref.watch(profileProvider);
    final controller = TextEditingController(text: initialValue);

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: "Notche",
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
      content: TextField(
        controller: controller,
        style: TextStyle(
          fontFamily: "Notche",
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        autofocus: true,
        maxLines: null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
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
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: AppColors.appWhite,
          ),
          child: profileState.isUpdate == true
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.appWhite,
                    strokeWidth: 2,
                  ),
                )
              : Text(saveText),
        ),
      ],
    );
  }
}
