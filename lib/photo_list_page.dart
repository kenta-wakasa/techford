import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PhotoListPage extends StatefulWidget {
  const PhotoListPage({Key? key}) : super(key: key);

  @override
  _PhotoListPageState createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  XFile? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ギャラリー画像一覧を表示したい!'),
      ),
      body: Center(
        child: Column(
          children: [
            if (image != null) Image.file(File(image!.path)),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                image = await _picker.pickImage(source: ImageSource.gallery);
                print(image?.path);
                setState(() {});
              },
              child: const Text('写真を選択'),
            ),
          ],
        ),
      ),
    );
  }
}

// /data/user/0/com.example.sample2/cache/image_picker3090005006029457969.jpg
