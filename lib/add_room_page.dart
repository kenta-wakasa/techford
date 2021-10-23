import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddRoomPage extends StatefulWidget {
  const AddRoomPage({Key? key}) : super(key: key);

  @override
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final textEditingController = TextEditingController();

  final textList = [
    'コピペしたデータA',
    'コピペしたデータB',
    'コピペしたデータC',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ルーム追加'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: textEditingController.text.isEmpty
                  ? null
                  : () async {
                      // TODO(kenta-wakasa): ルームの追加
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      final reference = await FirebaseFirestore.instance.collection('rooms').add(
                        {
                          'name': textEditingController.text,
                        },
                        

                      );
                      await FirebaseFirestore.instance.collection('users').doc(uid).set(
                        {
                          'rooms': FieldValue.arrayUnion([reference])
                        },
                        SetOptions(merge: true),
                      );
                      Navigator.of(context).pop();
                    },
              child: const Text('作成'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.blue,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: textEditingController,
              decoration: const InputDecoration(
                hintText: 'ルーム名',
                border: InputBorder.none,
                filled: true,
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
