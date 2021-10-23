import 'package:flutter/material.dart';
import 'package:sample2/chat_page.dart';
import 'package:sample2/todo_page.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({Key? key}) : super(key: key);

  @override
  _NavigatePageState createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {

  /// ボトムナビゲーションバーに割り当てる各ページ。
  final pages = [
    TodoPage(),
    ChatPage(),
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ボトムナビゲーションバーをタップすると、currentIndexが変更される。
      // currentIndex が 0 ならば、pages の 0 番目が画面に表示される。
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // ボトムナビゲーションバーをタップした時に実行される関数
        // indexにはタップした番号が入ってくる。
        // 番号は左から　0, 1, 2, ... と並んでいる。
        // 今回はその番号を currentIndex に代入するとことで、現在表示しているページ番号を管理している。
        onTap: (index) {
          currentIndex = index;
          setState(() {}); // setStateをよぶことを忘れずに
        },
        currentIndex: currentIndex,
        items: const [
          // ボトムナビゲーションバーのタップできるひとつひとつの要素
          BottomNavigationBarItem(
            label: 'TODO', 
            icon: Icon(
              Icons.list,
            ),
          ),
          BottomNavigationBarItem(
            label: 'chat',
            icon: Icon(
              Icons.chat,
            ),
          ),
        ],
      ),
    );
  }
}
