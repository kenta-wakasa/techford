import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveSample extends StatefulWidget {
  const HiveSample({Key? key}) : super(key: key);

  @override
  _HiveSampleState createState() => _HiveSampleState();
}

class _HiveSampleState extends State<HiveSample> {
  final controller = TextEditingController();

  // 初期化が完了したかを判定する
  bool isInitialized = false;

  Future<void> init() async {
    // まずはボックスを開く
    // memo のところは自由に名付けてOK
    await Hive.openBox('memo');
    isInitialized = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // ここで呼べば、初めに一回だけ実行される。
    init();
  }

  Future<void> addMemo() async {
    // TextFormFieldに入力されている文字列を取得
    final text = controller.text.trim();

    // isEmpty は textが空文字だったらtrueになるってやつです。
    if (text.isEmpty) {
      return;
    }

    // memoBoxに入力した文字列を追加
    await Hive.box('memo').add(text);

    // TextFormFieldの文字列をまっさらにする
    controller.clear();

    // 画面を再描画
    setState(() {});
  }

  // void getMemoList() {

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hiveサンプル'),
      ),
      body: SingleChildScrollView(
        // 三項演算子
        // 条件式 ? trueだったらこっち : falseだったらこっち
        child: isInitialized
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      // onChanged は何かテキストに変化があるたびに呼ばれる
                      onChanged: (_) {
                        setState(() {});
                      },
                      controller: controller,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.text.trim().isEmpty ? null : addMemo,
                    child: const Text('追加'),
                  ),
                  // リストの中にリストをいれるときに ... をつけなきゃいけない
                  ...Hive.box('memo')
                      .keys
                      .map(
                        (key) => Text(
                          Hive.box('memo').get(key),
                        ),
                      )
                      .toList()
                ],
              )
            : const Center(
                child: CupertinoActivityIndicator(),
              ),
      ),
    );
  }
}
