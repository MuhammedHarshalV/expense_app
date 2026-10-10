import 'dart:async';
import 'dart:developer';

import 'package:expense/controller/bottom_nav_controller/bottom_nav_controller.dart';
import 'package:expense/controller/create_clinics_controller/create_clinic_controller.dart';

import 'package:expense/presentation/screens/profile_screen/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceNavigationService {
  final SpeechToText speech = SpeechToText();

  BuildContext? _sheetContext;

  bool _isSheetOpen = false;
  bool _hasFinalResult = false;

  ValueNotifier<String>? _recognizedText;

  Future<void> startListening(BuildContext context, WidgetRef ref) async {
    try {
      _hasFinalResult = false;

      _recognizedText = ValueNotifier<String>('Say something...');

      final available = await speech.initialize(
        onStatus: (status) {
          log('Voice status: $status');

          // Speech stopped naturally
          if (status == 'done' || status == 'notListening') {
            if (!_hasFinalResult) {
              Future.delayed(const Duration(milliseconds: 300), () {
                _closeSheet();
              });
            }
          }
        },
        onError: (error) {
          log('Voice error: $error');

          if (_isSheetOpen) {
            _recognizedText?.value = 'Could not recognize voice';
          }

          Future.delayed(const Duration(milliseconds: 300), () {
            _closeSheet();
          });
        },
      );

      if (!available) {
        log('Speech recognition not available');
        return;
      }

      if (!context.mounted) return;

      // First open bottom sheet
      _showListeningSheet(context);

      // Small delay so bottom sheet is visible
      await Future.delayed(const Duration(milliseconds: 100));

      // Then start microphone
      await speech.listen(
        // ignore: deprecated_member_use
        listenFor: const Duration(seconds: 10),
        // ignore: deprecated_member_use
        pauseFor: const Duration(seconds: 3),
        // ignore: deprecated_member_use
        partialResults: true,

        onResult: (result) async {
          final text = result.recognizedWords.trim();

          log('Voice: $text | final: ${result.finalResult}');

          // IMPORTANT:
          // update bottom sheet for partial results also
          if (text.isNotEmpty && _isSheetOpen) {
            _recognizedText?.value = text;
          }

          if (!result.finalResult) {
            return;
          }

          if (text.isEmpty) {
            return;
          }

          _hasFinalResult = true;

          final command = text.toLowerCase();

          log('Final command: $command');

          // Give user some time to see final text
          //   await Future.delayed(const Duration(milliseconds: 700));

          await speech.stop();

          _closeSheet();

          // Small delay between closing sheet
          // and pushing new screen
          //  await Future.delayed(const Duration(milliseconds: 200));

          if (!context.mounted) return;

          _handleCommand(context, command, ref);
        },
      );
    } catch (e, stackTrace) {
      log('Speech initialization error: $e', stackTrace: stackTrace);

      _closeSheet();
    }
  }

  void _showListeningSheet(BuildContext context) {
    _isSheetOpen = true;

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      builder: (sheetContext) {
        _sheetContext = sheetContext;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
            child: ValueListenableBuilder<String>(
              valueListenable: _recognizedText!,
              builder: (context, text, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mic, size: 45, color: Colors.red),

                    const SizedBox(height: 12),

                    const Text(
                      'Listening...',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      _isSheetOpen = false;
      _sheetContext = null;

      if (speech.isListening) {
        speech.stop();
      }
    });
  }

  void _closeSheet() {
    if (!_isSheetOpen) return;

    final sheetContext = _sheetContext;

    if (sheetContext != null && sheetContext.mounted) {
      _isSheetOpen = false;

      Navigator.of(sheetContext).pop();
    }
  }

  Future<void> _handleCommand(
    BuildContext context,
    String command,
    WidgetRef ref,
  ) async {
    log('Handling command: $command');

    if (command.contains('profile')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    } else if (command.contains('history')) {
      ref.read(bottomNavProvider.notifier).changeIndex(2);
    } else if (command.contains('add clinic')) {
      await _addClinic(context, ref, command);
    } else {
      log('Unknown command: $command');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Command not recognized: $command')),
      );
    }
  }

  Future<void> stopListening() async {
    await speech.stop();

    _closeSheet();
  }

  Future<void> _addClinic(
    BuildContext context,
    WidgetRef ref,
    String command,
  ) async {
    final clinicName = _extractClinicName(command);

    final place = _extractPlace(command);

    log('Clinic name: $clinicName');
    log('Phone: $place');

    if (clinicName == null || clinicName.isEmpty) {
      return;
    }

    if (place == null) {
      return;
    }
    final controller = ref.read(createClinicProvider.notifier);

    controller.nameController.text = clinicName;
    controller.placeController.text = place;

    await controller.createClinicApi(context: null);
  }

  String? _extractClinicName(String command) {
    final match = RegExp(
      r'add clinic\s+(.+?)(?=\s+(?:place|location)\b|$)',
      caseSensitive: false,
    ).firstMatch(command);

    return match?.group(1)?.trim();
  }

  String? _extractPlace(String command) {
    final match = RegExp(
      r'(?:place|location)\s+(.+)$',
      caseSensitive: false,
    ).firstMatch(command);

    return match?.group(1)?.trim();
  }
}
