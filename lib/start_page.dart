import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample2/room_list_page.dart';
import 'package:sample2/login_page.dart';
import 'package:sample2/navigate_page.dart';
import 'package:sample2/settings_page.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
        ],
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
