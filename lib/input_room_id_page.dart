import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InputRoomIDPage extends StatefulWidget {
  const InputRoomIDPage({Key? key}) : super(key: key);

  @override
  _InputRoomIDPageState createState() => _InputRoomIDPageState();
}

class _InputRoomIDPageState extends State<InputRoomIDPage> {
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IDを入力してください'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: textEditingController.text.isEmpty
                  ? null
                  : () async {
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      final snapshot =
                          await FirebaseFirestore.instance.collection('rooms').doc(textEditingController.text).get();
                      final data = snapshot.data();
                      if (data?['name'] == null) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Text('エラー'),
                                content: Text(
                                  '入力されたIDのチャットルームは存在しませんでした。'
                                  'IDを見直してもう一度入力してください。',
                                ),
                              );
                            });
                        return;
                      }
                      await FirebaseFirestore.instance.collection('users').doc(uid).set(
                        {
                          'rooms': FieldValue.arrayUnion([snapshot.reference])
                        },
                        SetOptions(merge: true),
                      );
                      Navigator.of(context).pop();
                    },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.blue,
                primary: Colors.white,
                shape: const StadiumBorder(),
              ),
              child: const Text('参加'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          onChanged: (_) {
            setState(() {});
          },
          autofocus: true,
          controller: textEditingController,
        ),
      ),
    );
  }
}
