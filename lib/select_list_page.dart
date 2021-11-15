import 'package:flutter/material.dart';

class SelectListPage extends StatefulWidget {
  const SelectListPage({Key? key}) : super(key: key);
  @override
  _SelectListPageState createState() => _SelectListPageState();
}

class _SelectListPageState extends State<SelectListPage> {
  final list = [
    '写真１',
    '写真2',
    '写真3',
    '写真4',
    '写真5',
  ];

  final selectedList = <String>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('リストから選択'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          final text = list[index];
          return InkWell(
            onTap: () {
              // すでに選択されている場合
              if (selectedList.contains(text)) {
                selectedList.remove(text);
              }
              // まだ選択されていない場合
              else {
                selectedList.add(text);
              }
              setState(() {});
            },
            child: Container(
              color: selectedList.contains(text) ? Colors.blue : null,
              alignment: Alignment.center,
              child: Text(text),
            ),
          );
        },
      ),
    );
  }
}
