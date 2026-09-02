import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static Future<XFile?> pickImage({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();

    // Show options: Camera / Gallery
    return await showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () async {
                  final image = await picker.pickImage(
                    source: ImageSource.camera,
                    preferredCameraDevice: CameraDevice.front,
                    imageQuality: 85,
                    maxWidth: 1000,
                    maxHeight: 1000,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () async {
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                    maxWidth: 1000,
                    maxHeight: 1000,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, image);
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
