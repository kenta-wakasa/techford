import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sample2/start_page.dart';

// はじめに main 関数が実行されます
Future<void> main() async {
  // runAppを呼ぶ前に色々処理を行いたい時は初めにこれを書く必要がある。
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase の初期化。await をつけることで終わるまで待てる。
  await Firebase.initializeApp();
  // await MobileAds.instance.initialize(); // 追加

  // runApp のなかにかかれたWidgetがrootになります。
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // まずMaterialAppからはじめる。
    // いまはなんで必要なのかわからないと思うけど、特に気にしなくてOK
    return const MaterialApp(
      home: StartPage(),
    );
  }
}

class FirestorePage extends StatefulWidget {
  const FirestorePage({Key? key}) : super(key: key);

  @override
  _FirestorePageState createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  String name = '名前はまだない';

  Future<void> fetchName() async {
    // tests というコレクションに保存されているドキュメントをすべて取得する
    final snapshot = await FirebaseFirestore.instance.collection('tests').get();
    name = snapshot.docs.first['name'];
    setState(() {}); // 画面を更新
  }

  @override
  void initState() {
    super.initState();
    // ここに書いた関数が最初に一度だけ実行される
    fetchName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          name,
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
