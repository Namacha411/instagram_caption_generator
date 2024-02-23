import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final messageControllerStateProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});

final responseControllerStateProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});

final imagePickerProvider =
    StateNotifierProvider<ImagePickerNotifier, List<File>>((ref) {
  return ImagePickerNotifier();
});

class ImagePickerNotifier extends StateNotifier<List<File>> {
  ImagePickerNotifier() : super([]);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    state = pickedFiles.map((e) => File(e.path)).toList();
  }
}