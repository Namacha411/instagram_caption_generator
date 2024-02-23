import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<String> generateContent(String modelName, List<Content> contents) async {
  final googleAiStudioApiKey = dotenv.get('GOOGLE_AI_STUDIO_API_KEY');
  final model = GenerativeModel(model: modelName, apiKey: googleAiStudioApiKey);
  final response = await model.generateContent(contents);
  return response.text ?? "";
}

Future<String> getGeminiResponse(String info, List<Uint8List> images) async {
  const modelName = "gemini-pro-vision";
  final contents = [
    Content.multi([
      TextPart(prompt),
      ... info.isNotEmpty ? [TextPart("以下の情報を適切な形で含めてください:$info")] : [],
      ... images.map((e) => DataPart("image/jpeg", e)),
      ])
  ];
  return await generateContent(modelName, contents);
}

const prompt = """
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
イチゴの裏ごしスープと軽いコンポート
練乳のミルクキャラメルアイス添え

24日の土曜日ですが、キャンセルがでました。
箱根にお越し方、いかがでしょうか♪

#octobre #レストラン #ビストロノミー #ビストロ #箱根 #箱根フレンチ #オクトーブル #いちご #いちごスイーツ
---
枯れ草を焼き、新芽を育てる秋吉台の
春の風物詩です⛰️🌱

すごい車の数と人で、秋吉台家族旅行村から子どもを
ひとり肩ぐるま、もうひとりは抱っこで
坂道を登りながら到着しました😂

今年は特に風も吹いて良く焼けたようで、
大地が茶色から黒に変わっていくダイナミックな景観を
楽しみました😊

トトロも可愛かったです🤗✨

#山口県
#山口
#山口県美祢市
#美祢市
#秋吉台
#山口県観光
#山口旅行
#山口観光
#春
#観光
#旅行
#春の風物詩
#山焼き
#トトロ
#となりのトトロ
#秋吉台家族旅行村
#景観
#景色
#風景
#日本三大カルスト
#カルスト台地
#家族旅行
#旅行好きと繋がりたい
---
⛰野底マーペー山⛰
2024初登山～♬
・
…と言うかジャングル掻き分けながら進むトレッキングじゃね～🤭
・
途中険しい所もあるけど、1時間弱で登れるけぇ楽しい～♬
・
マーペー伝説切ないけど共感\u202A\u202A❤︎\u202C
美しい伝説と共に感動刻まれルン～🤩
・
大好きなマーペー⛰
また来るけんね～🥰
・
#野底岳 #マーペー #山 #山頂 #登山 #トレッキング #動画 #登山女子 #山好き #山登り #観光 #ジャングル #冒険 #絶景 #パワースポット #海 #大自然 #沖縄 #石垣島 #旅行 #観光地 #2024 #冬 #観光スポット #休日
""";
