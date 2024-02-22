import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

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

  Future pickImage() async {
    final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final pickedFiles = await picker.pickMultiImage();

    state = pickedFiles.map((e) => File(e.path)).toList();
    // if (pickedFile != null) {
    //   state = File(pickedFile.path);
    // }
  }
}

Future<String> getGeminiResponse(List<Content> contents) async {
  final googleAiStudioApiKey = dotenv.get('GOOGLE_AI_STUDIO_API_KEY');
  final model =
      GenerativeModel(model: "gemini-pro-vision", apiKey: googleAiStudioApiKey);
  final response = await model.generateContent(contents);
  return response.text ?? "";
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(imagePickerProvider);
    Widget showImages() {
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
          ));
    }

    Widget showTextField() {
      return Column(children: [
        Container(
            margin: const EdgeInsets.all(20),
            child: TextButton(
              onPressed: () =>
                  ref.read(imagePickerProvider.notifier).pickImage(),
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
                      getGeminiResponse([
                        Content.multi([
                          TextPart("""
インスタグラムに投稿する際の効果的なキャプションを考えてください

- ポジティブで明るい文章にする
- 一文は短めにまとめる
- 改行や空白を適宜使う
- 適度に絵文字や特殊文字、記号を使用する
- 文章の下部にハッシュタグを追加する

以下に参考例を示します
---
@boss ファッションショーに行ってきました！！
超ビッグでワクワクするランウェイを超えた未来的なセットとカッコいいBOSSを表現する素晴らしいショーだったんだけど、
至るところに伝説のAIソフィアがいて、
自由に話しかけて良いよって言われたから
ニコニコのソフィアにウキウキで近寄ったら
めっちゃ嫌な顔された

何もしてないのに秒で嫌われたんだけど！！
将来AIに嫌われないように気を使う未来が来るのかな？笑
でも最後は機嫌なおして踊ってくれた。
ソフィア結構かまちょでうにょ
(9個目の動画の最後ニッコニコで踊ってるよw)

ちなみに2個目の動画の途中に出てくるパソコン仮装の人
ちゃんと仕事してる演出してんのうける
実際話してみるとめっちゃいい人なのもウケる

普段スーツとか着る機会ないけど
むっちゃ似合うやんって思って
今後挑戦してみよ🫶

人が多過ぎて
全員とは写真撮れなかったんだけど、
いつものチームBOSS友とも会えたし
新しい友達も出来て根暗とっても嬉しいです笑

#BeYourOwnBOSS
#BOSSMilanShow
#ad #adv
---
Rainy day pottery 🕯️☔️雨の日の陶芸。🫠
The goal is always important. But what is more important? The goal? Or enjoying the journey?🤍

結果も大切だけれど、それよりももっと大切な事は、過程を楽しむ事かな❔
---
料理も美味しいし映えるし値段もお手頃で可愛い中華のお店！
席のほとんどが荷物置きにスマホを置いて上から撮影できることで話題！

予約なしだと1時間半待ち！
人気すぎるから絶対に予約すべし！！

🏠フーフー飯店 FuFu Hanten
🚃錦糸町駅徒歩３分
🕐11:00〜23:00
☎️03-6658-5120
📍東京都墨田区錦糸4丁目1-7
                            """),
                          ...images.map((e) => DataPart(
                              "image/jpeg", File(e.path).readAsBytesSync())),
                          // DataPart("image/jpeg",
                          //     File(image!.path).readAsBytesSync()),
                          ...ref
                                  .watch(messageControllerStateProvider)
                                  .text
                                  .isEmpty
                              ? []
                              : [
                                  TextPart(
                                      "以下の情報を適切な形で含めてください:${ref.watch(messageControllerStateProvider).text}")
                                ],
                          // 位置情報を追加する？
                          // 時間情報を追加する？
                        ])
                      ]).then((value) {
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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              showImages(),
              showTextField(),
            ],
          ),
        ));
  }
}
