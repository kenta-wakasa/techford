import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final controller = TextEditingController();

  Future<void> createTodo() async {
    await todosReference.add(Todo(content: controller.text, createdAt: DateTime.now(), isDone: false));
    controller.clear();
  }

  @override
  void dispose() {
    super.dispose();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TODO'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Todo>>(
                  stream: todosReference.orderBy('createdAt', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    // nullチェックをする
                    if (data == null) {
                      // 何も表示しない
                      return const SizedBox.shrink();
                    }
                    // これ以降はdataがnullじゃないことが確定している。
                    final todoList = data.docs.map((e) => e.data()).toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: todoList.length,
                      itemBuilder: (context, index) {
                        final todo = todoList[index];
                        return ListTile(
                          key: Key(todo.createdAt.toString()),
                          title: Text(todo.content),
                          subtitle: Text(todo.createdAt.toString()),
                          leading: Checkbox(
                            value: todo.isDone,
                            onChanged: (value) async {
                              todo.reference?.update({'isDone': value});
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              todo.reference?.delete();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                height: 56,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (_) => setState(() {}),
                        controller: controller,
                        onFieldSubmitted: (_) => createTodo(),
                        decoration: InputDecoration(
                          hintText: 'やりたいことを入力',
                          hintStyle: const TextStyle(fontSize: 12, color: Colors.blue),
                          fillColor: Colors.blue[100],
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.blue[100]!,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.text.isEmpty ? null : () => createTodo(),
                      icon: Icon(
                        Icons.send,
                        color: controller.text.isEmpty ? Colors.grey : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final todosReference = FirebaseFirestore.instance.collection('todos').withConverter<Todo>(
      fromFirestore: (snapshot, _) => Todo.fromFirestore(snapshot),
      toFirestore: (todo, _) => todo.toMap(),
    );

class Todo {
  Todo({
    // { } この記号で囲むことで名前付き引数にできる
    required this.content, // required をつけると必須の引数にできる
    required this.createdAt,
    required this.isDone,
    this.reference,
  });

  /// やりたいことの中身
  final String content;

  /// 作成した日時
  final DateTime createdAt;

  /// 完了済みかどうか
  final bool isDone;

  final DocumentReference<Map<String, dynamic>>? reference;

  static Todo fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Data Not Found');
    }
    return Todo(
      isDone: data['isDone'] as bool,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      content: data['content'] as String,
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'createdAt': createdAt,
      'isDone': isDone,
    };
  }
}
