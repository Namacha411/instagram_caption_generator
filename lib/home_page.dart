import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:instagram_caption/provider.dart';
import 'package:instagram_caption/utils.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram caption generator'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageDisplayWidget(),
            TextFieldInputWidget(),
          ],
        ),
      ),
    );
  }
}

class ImageTile extends StatelessWidget {
  final Uint8List imageBytes;

  const ImageTile({
    super.key,
    required this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Image.memory(
        imageBytes,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ImageDisplayWidget extends ConsumerWidget {
  const ImageDisplayWidget({super.key});

  Widget buildImageList(List<Uint8List> images) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: images.isNotEmpty
          ? images.map((e) => ImageTile(imageBytes: e)).toList()
          : [const Icon(Icons.image, size: 100)],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(imagePickerProvider);
    final scrollController = ScrollController();

    return Container(
      margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: SizedBox(
        height: 300,
        child: Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            child: buildImageList(images),
          ),
        ),
      ),
    );
  }
}

class TextFieldInputWidget extends ConsumerWidget {
  const TextFieldInputWidget({super.key});

  Future<void> handleCaptionGeneration(WidgetRef ref) async {
    ref.read(responseControllerStateProvider).text = "Loading...";
    await getGeminiResponse(
      ref.read(messageControllerStateProvider).text,
      ref.read(imagePickerProvider)
    ).then((response) =>
        ref.read(responseControllerStateProvider).text = response);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(50),
      child: Column(children: [
        TextButton(
          onPressed: () => ref.read(imagePickerProvider.notifier).pickImage(),
          child: const Text('画像を選択する'),
        ),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'message',
          ),
          controller: ref.watch(messageControllerStateProvider),
        ),
        TextButton(
            onPressed: () => handleCaptionGeneration(ref),
            child: const Text('キャプションを生成する')),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'response',
          ),
          controller: ref.watch(responseControllerStateProvider),
        ),
      ]),
    );
  }
}
