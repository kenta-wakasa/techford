import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// null です
  String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Column(
        children: [
          Item(
            label: 'ラベルです',
            content: name,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    title: Text('タイトル'),
                    content: Text('本文'),
                  );
                },
              );
            },
          ),
          Item(
            label: 'ラベル2',
            content: 'ほげ',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    title: Text('タイトル'),
                    content: Text('本文'),
                  );
                },
              );
            },
          ),
          Item(
            label: 'ラベルです',
            content: name,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    title: Text('タイトル'),
                    content: Text('本文'),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.label,
    required this.content,
    required this.onTap,
  }) : super(key: key);
  final String label;
  final dynamic content;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            Text(label),
            Text(
              content is String ? content : 'Stringじゃないよ',
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}
