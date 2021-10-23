import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.room,
  }) : super(key: key);
  final DocumentSnapshot<Map<String, dynamic>> room;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textEditingController = TextEditingController();
  final scrollController = ScrollController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.data()?['name'] ?? ''),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: widget.room.reference.collection('chats').orderBy('createdAt').snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (data == null) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }

              return Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.docs.map((e) {
                      if (e.data()['createdAt'] == null) {
                        return const SizedBox.shrink();
                      }
                      final createdAt = (e.data()['createdAt'] as Timestamp).toDate();
                      return Align(
                        alignment: e.data()['uid'] == uid ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (e.data()['uid'] == uid)
                                Text(
                                  '${createdAt.hour}:${createdAt.minute}',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              if (e.data()['uid'] == uid)
                                const SizedBox(
                                  width: 4,
                                ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                ),
                                child: Text(e.data()['text'] ?? ''),
                              ),
                              if (e.data()['uid'] != uid)
                                const SizedBox(
                                  width: 4,
                                ),
                              if (e.data()['uid'] != uid)
                                Text(
                                  '${createdAt.hour}:${createdAt.minute}',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          // 入力フォーム作成
          InputWidget(
            textEditingController: textEditingController,
            room: widget.room,
            scrollController: scrollController,
          ),
        ],
      ),
    );
  }
}

class InputWidget extends StatefulWidget {
  const InputWidget({
    Key? key,
    required this.textEditingController,
    required this.room,
    required this.scrollController,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final ScrollController scrollController;
  final DocumentSnapshot<Map<String, dynamic>> room;

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextFormField(
                autofocus: true,
                controller: widget.textEditingController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Colors.blue.withOpacity(0.1),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: widget.textEditingController.text.isEmpty
                ? null
                : () async {
                    // TODO(kenta-wakasa): チャット送信機能
                    await widget.room.reference.collection('chats').add(
                      {
                        'createdAt': FieldValue.serverTimestamp(),
                        'uid': uid,
                        'text': widget.textEditingController.text,
                      },
                    );
                    widget.textEditingController.clear();
                    if (mounted) {
                      setState(() {});
                    }
                  },
            color: Colors.blue,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
