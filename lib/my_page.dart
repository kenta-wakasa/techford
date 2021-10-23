import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample2/login_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  /// ここに選択した画像を格納する
  XFile? image;

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

  @override
  void initState() {
    super.initState();
    fetchImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('マイページ'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 32,
          ),

          // これで囲むとtap可能になる。
          if (image == null)
            InkWell(
              onTap: () async {
                // TODO(kenta-wakasa): ここに画像アップロード処理を書く
                // まずは画像を選択しないといけない

                final picker = ImagePicker(); // まずはインスタンスを作る。
                // ImageSource.gallery は保存された画像から選択
                // ImageSource.camera はその場でカメラを起動して撮影した画像を選択
                image = await picker.pickImage(source: ImageSource.gallery);
                setState(() {});
                final uid = FirebaseAuth.instance.currentUser!.uid;
                final ref = FirebaseStorage.instance.ref().child('users').child(uid);
                await ref.putFile(File(image!.path));
                final imageUrl = await ref.getDownloadURL(); // 実際に画像が配置されているURL
                await FirebaseFirestore.instance.collection('users').doc(uid).set(
                  {'imageUrl': imageUrl},
                  SetOptions(merge: true),
                );
              },
              child: imageUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl!),
                      radius: 50,
                    )
                  : const Icon(
                      Icons.face,
                      size: 100,
                    ),
            )
          else
            CircleAvatar(
              backgroundImage: FileImage(File(image!.path)),
              radius: 50,
            ),

          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) {
                  return const LoginPage();
                },
              ), (route) => true);
            },
            child: const Text('ログアウト'),
          ),
          // Image.file(
          //   File(image!.path),
          // ),
        ],
      ),
    );
  }
}
