import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample2/create_user_page.dart';
import 'package:sample2/grid_in_card.dart';
import 'package:sample2/hive_sample.dart';
import 'package:sample2/login_page.dart';
import 'package:sample2/navigate_page.dart';
import 'package:sample2/room_list_page.dart';
import 'package:sample2/select_list_page.dart';
import 'package:sample2/settings_page.dart';
import 'package:sample2/todo_list_page.dart';
import 'package:sample2/todo_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サンプルアプリ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(width: double.infinity),
              ElevatedButtonToPush(
                label: 'TODOサンプル',
                page: TodoPage(),
              ),
              ElevatedButtonToPush(
                label: 'チャットサンプル',
                page: RoomListPage(),
              ),
              ElevatedButtonToPush(
                label: 'ボトムナビゲーションバーサンプル',
                page: NavigatePage(),
              ),
              ElevatedButtonToPush(
                label: '設定機能サンプル',
                page: SettingsPage(),
              ),
              ElevatedButtonToPush(
                label: 'Hiveサンプル',
                page: HiveSample(),
              ),
              ElevatedButtonToPush(
                label: 'リストから複数選択する場合どうする？',
                page: SelectListPage(),
              ),
              ElevatedButtonToPush(
                label: 'Cardの中でGrid表示',
                page: GridInCard(),
              ),
              ElevatedButtonToPush(
                label: '新規ユーザー登録',
                page: CreateUserPage(),
              ),
              ElevatedButtonToPush(
                label: 'TODOリストでクラスの説明',
                page: TodoListPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ElevatedButtonToPush extends StatelessWidget {
  const ElevatedButtonToPush({
    Key? key,
    required this.label,
    required this.page,
  }) : super(key: key);

  final String label;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (FirebaseAuth.instance.currentUser == null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const LoginPage();
              },
            ),
          );
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return page;
            },
          ),
        );
      },
      child: Text(label),
    );
  }
}
