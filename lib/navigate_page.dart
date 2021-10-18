import 'package:flutter/material.dart';
import 'package:sample2/chat_page.dart';
import 'package:sample2/main.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({Key? key}) : super(key: key);

  @override
  _NavigatePageState createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  final pages = [
    TodoPage(),
    ChatPage(),
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          currentIndex = index;
          setState(() {});
        },
        currentIndex: currentIndex,
        items: const [
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
