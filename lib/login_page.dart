
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample2/todo_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // TODO(kenta-wakasa): ログイン処理実装

            // signIn メソッドを呼ぶだけでGoogle SignInのポップアップが出る。
            GoogleSignInAccount? googleUser;
            try {
              googleUser = await GoogleSignIn().signIn();
            } catch (e) {
              print(e);
              return;
            }

            // もしユーザーがログインせずにキャンセルしたら、ここで関数を終了する。
            if (googleUser == null) {
              return;
            }

            // credentialを取得するために必要なaccessTokenとidTokenがほしい。その情報は .authentication で取り出せる。
            final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

            // 上で手に入れたgoogleAuthをつかってcredentialをつくる。
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken,
            );
            // 最終的にcredentialでFirebaseAuthとGoogleAuthを連携させる。
            await FirebaseAuth.instance.signInWithCredential(credential);

            // ログインに成功したらTodoPageに遷移する
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const TodoPage(),
              ),
            );
          },
          child: const Text('ログイン'),
        ),
      ),
    );
  }
}