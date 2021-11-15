import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSample extends StatefulWidget {
  const SharedPreferencesSample({Key? key}) : super(key: key);

  @override
  _SharedPreferencesSampleState createState() => _SharedPreferencesSampleState();
}

class _SharedPreferencesSampleState extends State<SharedPreferencesSample> {
  /// インスタンスが生成されるまではnullになっていることに注意
  SharedPreferences? pref;

  Future<void> init() async {
    /// SharedPreferencesを使うにはまずインスタンスを作る必要がある。
    /// Future型で返ってくるので、awaitとすることを忘れないようにしよう。
    pref = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  /// 変数名の前に get とつけると、関数のあとの()を省略できる
  /// なのでこの関数を何も省力せずに書くと以下のようになる。
  /// ```dart
  /// String name() {
  ///   return pref?.getString('name') ?? '名前はまだない';
  /// }
  /// ```
  String get name => pref?.getString('name') ?? '名前はまだない';

  /// ?? という記号の説明。
  ///
  /// ?? は 左側がnullだった場合には右側を使うことを表す。
  /// たとえば  `final name = null ?? 'hoge'` だったら
  /// nameにはhogeが代入される。
  /// numberというkeyには何も保存されていないかもしれないのでその場合
  /// pref?.getString('number')　は null を返す。
  /// null だった場合は'未入力'という文字列を返すことにしている。
  String get number => pref?.getString('number') ?? '未入力';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences'),
      ),

      /// prefがnullの間は、インジケーターまわるだけにする。
      /// nullじゃなくなったら、画面に入力項目を表示。
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: double.infinity),
            InkWell(
              onTap: () async {
                /// ダイアログがStringをpopしてそれをresultが受け取る
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('名前を変更'),
                    content: TextFormField(
                      autofocus: true,
                      onFieldSubmitted: (value) {
                        Navigator.of(context).pop(value);
                      },
                    ),
                  ),
                );

                /// ダイアログは何もpopしないかもしれないのでその場合は
                /// resultがnullになる。
                /// nullだとその後の処理をやらないようにしたいのでreturnする。
                if (result == null) {
                  return;
                }
                await pref?.setString('name', result);
                if (mounted) {
                  setState(() {});
                }
              },
              child: Text(
                '名前： $name',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            InkWell(
              onTap: () async {
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('学籍番号を変更'),
                    content: TextFormField(
                      // 数字だけを入力可能にする
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      autofocus: true,

                      /// 入力フィールドの完了ボタンを押すとこの関数が呼ばれる。
                      /// その時点で入力されている文字列がvalueに入る。
                      /// valueをpopして上で書いたresult変数に代入している。
                      onFieldSubmitted: (value) {
                        Navigator.of(context).pop(value);
                      },
                    ),
                  ),
                );
                if (result == null) {
                  return;
                }
                await pref?.setString('number', result);
                setState(() {});
              },
              child: Text(
                '学籍番号： $number',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
