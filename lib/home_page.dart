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
          title: const Text('Flutter Demo'),
        ),
        body: const SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageDisplayWidget(),
              TextFieldInputWidget(),
            ],
          ),
        ));
  }
}

class ImageDisplayWidget extends ConsumerWidget {
  const ImageDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(imagePickerProvider);

    return Container(
      margin: const EdgeInsets.all(20),
      child: SizedBox(
        height: 300,
        child: Row(
          children: images.isNotEmpty
              ? images
                  .map((e) => Container(
                        margin: const EdgeInsets.all(20),
                        child: Image.file(
                          e,
                          fit: BoxFit.cover,
                        ),
                      ))
                  .toList()
              : [const Icon(Icons.image, size: 100)],
        ),
      ),
    );
  }
}

class TextFieldInputWidget extends ConsumerWidget {
  const TextFieldInputWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Container(
          margin: const EdgeInsets.all(20),
          child: TextButton(
            onPressed: () => ref.read(imagePickerProvider.notifier).pickImage(),
            child: const Text('Pick Image'),
          )),
      TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'message',
        ),
        controller: ref.watch(messageControllerStateProvider),
      ),
      Container(
          margin: const EdgeInsets.all(20),
          child: TextButton(
              onPressed: () => {
                    getGeminiResponse(
                      ref.read(messageControllerStateProvider).text,
                      ref
                          .read(imagePickerProvider)
                          .map((e) => e.readAsBytesSync())
                          .toList(),
                    ).then((value) {
                      ref.read(responseControllerStateProvider).text = value;
                    })
                  },
              child: const Text('Update Text'))),
      TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'response',
        ),
        controller: ref.watch(responseControllerStateProvider),
      )
    ]);
  }
}
