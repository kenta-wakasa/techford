import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample2/add_room_page.dart';
import 'package:sample2/input_room_id_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<DocumentSnapshot<Map<String, dynamic>>> roomDocuments = [];
  Future<void> fetchChatRooms() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return;
    }
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userData = userDoc.data();
    if (userData == null) {
      return;
    }
    // null の場合は空のリストを返す。
    final roomReference = userData['rooms'] == null
        ? <DocumentReference<Map<String, dynamic>>>[]
        : List<DocumentReference<Map<String, dynamic>>>.from(userData['rooms']);

    // リファレンスを使って実データを取得する。
    roomDocuments = await Future.wait(roomReference.map((roomRef) => roomRef.get()).toList());

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ルーム一覧'),
      ),
      body: ListView(
        children: roomDocuments
            .map(
              (e) => ListTile(
                onTap: () async {
                  // TODO(kenta-wakasa): チャットルームに遷移
                  
                },
                title: Text(
                  e.data()?['name'] ?? '',
                ),
                
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TODO(kenta-wakasa): 新規でチャットルームを作るか、他のチャットルームに入るかを選択可能にしたい
          final result = await showCupertinoModalPopup<int>(
            context: context,
            builder: (context) {
              return CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () {
                        // ここを選択すると0を返す
                        Navigator.of(context).pop(0);
                      },
                      child: const Text('新規ルーム作成'),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        // ここを選択すると1を返す
                        Navigator.of(context).pop(1);
                      },
                      child: const Text('IDを入力してルームに参加'),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ));
            },
          );

          if (result == null) {
            return;
          }

          if (result == 0) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddRoomPage(),
              ),
            );
            return;
          }

          if (result == 1) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const InputRoomIDPage(),
              ),
            );

            return;
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
