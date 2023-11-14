import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<List<File>> pickImages(BuildContext context) async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage(imageQuality: 30);
  if (imageFiles.isNotEmpty) {
    // if (imageFiles.length > 6) {
    //   if (context.mounted) {
    //     showSnackbar(context, 'Maximum image limit is 6');
    //   }
    //   imageFiles.removeRange(6, imageFiles.length);
    // }
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
  }
  return images;
}

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final imageFile =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 30);
  if (imageFile != null) {
    return File(imageFile.path);
  }
  return null;
}
