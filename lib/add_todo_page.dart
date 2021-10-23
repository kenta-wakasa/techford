import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('追加'),
      ),
      body: Column(
        children: [
          // Padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: TextFormField(
              controller: controller, // TextFormField の
            ),
          ),
          const SizedBox(height: 36),
          // SizedBoxで大きさを調整できる
          SizedBox(
            height: 40,
            width: 160,
            child: ElevatedButton(
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid == null) {
                  return;
                }
                // 新規のドキュメントを追加したい時は add
                await FirebaseFirestore.instance.collection('users').doc(uid).collection('todos').add(
                  {
                    // key  と value
                    'content': controller.text,
                  },
                );
                Navigator.of(context).pop();
              },
              child: const Text('追加'),
            ),
          ),
        ],
      ),
    );
  }
}