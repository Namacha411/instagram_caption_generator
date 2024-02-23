import 'dart:typed_data';

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
    StateNotifierProvider<ImagePickerNotifier, List<Uint8List>>((ref) {
  return ImagePickerNotifier();
});

class ImagePickerNotifier extends StateNotifier<List<Uint8List>> {
  ImagePickerNotifier() : super([]);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 50);
    state = await Future.wait(pickedFiles.map((e) => e.readAsBytes()));
  }
}
