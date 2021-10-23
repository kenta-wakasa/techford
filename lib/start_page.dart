import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample2/room_list_page.dart';
import 'package:sample2/login_page.dart';
import 'package:sample2/navigate_page.dart';
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
        children: [
          SizedBox(
            width: double.infinity,
          ),
          ElevatedButton(
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
                    return const TodoPage();
                  },
                ),
              );
            },
            child: const Text('TODOサンプル'),
          ),
          ElevatedButton(
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
                    return const RoomListPage();
                  },
                ),
              );
            },
            child: const Text('チャットサンプル'),
          ),
          ElevatedButton(
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
                    return const NavigatePage();
                  },
                ),
              );
            },
            child: const Text('ボトムナビゲーションバーサンプル'),
          ),
        ],
      ),
    );
  }
}
