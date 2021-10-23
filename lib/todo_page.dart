import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample2/add_todo_page.dart';

import 'my_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // 型名 変数名 = 初期値
  List<QueryDocumentSnapshot<Map<String, dynamic>>> todoList = [];

  /// todosコレクションからすべてのドキュメントを取得する
  Future<void> fetchTodoList() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return;
    }
    // todos というコレクションに保存されているドキュメントをすべて取得する
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).collection('todos').get();
    todoList = snapshot.docs;
    if (mounted) {
      setState(() {}); // 画面を更新
    }
  }

  String? imageUrl;

  Future<void> fetchImageUrl() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    final data = snapshot.data();
    if (data == null) {
      return;
    }
    imageUrl = data['imageUrl'];
    if (mounted) {
      setState(() {});
    }
  }

  // 親のiitStateメソッドをオーバーライドしています。
  @override
  void initState() {
    super.initState(); // 親クラスの initStateを読んでいます。

    /// この関数の中はこのWidgetが生成されたときに一度だけ呼ばれる。
    fetchTodoList();
    fetchImageUrl();
  }

  static const title = 'TODO';

  @override
  Widget build(BuildContext context) {
    /// ここから下はUIのことを書いていく。
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          if (imageUrl == null)
            IconButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyPage(),
                  ),
                );
                fetchImageUrl();
              },
              icon: const Icon(Icons.face),
            )
          else
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyPage(),
                  ),
                );
                fetchImageUrl();
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl!),
                ),
              ),
            )
        ],
      ),
      body: ListView(
        children: todoList.map(
          // こいつは関数
          (todo) {
            return ListTile(
              title: Text(todo.data()['content']),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // TODO(kenta-wakasa): 削除処理
                  todoList.remove(todo);
                  setState(() {});
                  print(todo.reference.path);
                  todo.reference.delete();
                },
              ),
            );
          },
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // asyncキーワードをつけてあげると　await がつかえる。
          // TODO(kenta-wakasa): ここでTODOに追加していく処理を書く

          // 画面遷移
          // Future型の場合はawaitで待つと確定した値を取り出すことができる。
          await Navigator.of(context).push<String>(
            MaterialPageRoute(
              builder: (context) => AddTodoPage(), // アロー演算子で省略できる。
            ),
          );
          // 追加ページから戻ってきたら最新を取得してあげれば良い。
          await fetchTodoList();
          if (mounted) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
