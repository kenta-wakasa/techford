import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample2/my_page.dart';
import 'package:sample2/navigate_page.dart';
import 'package:sample2/photo_list_page.dart';

// はじめに main 関数が実行されます
Future<void> main() async {
  // runAppを呼ぶ前に色々処理を行いたい時は初めにこれを書く必要がある。
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase の初期化。await をつけることで終わるまで待てる。
  await Firebase.initializeApp();

  // runApp のなかにかかれたWidgetがrootになります。
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // まずMaterialAppからはじめる。
    // いまはなんで必要なのかわからないと思うけど、特に気にしなくてOK
    return MaterialApp(
      // 三項演算子の説明
      // (trueかfalseになる条件式) ? trueのときに実行される : falseのときに実行される
      // home: PhotoListPage(),
      home: FirebaseAuth.instance.currentUser == null ? const LoginPage() : const NavigatePage(),
    );
  }
}

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

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // 型名 変数名 = 初期値
  List<QueryDocumentSnapshot<Map<String, dynamic>>> todoList = [];

  /// todosコレクションからすべてのドキュメントを取得する
  Future<void> fetchTodoList() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return;
    }
    // todos というコレクションに保存されているドキュメントをすべて取得する
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).collection('todos').get();
    todoList = snapshot.docs;
    setState(() {}); // 画面を更新
  }

  String? imageUrl;

  Future<void> fetchImageUrl() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    imageUrl = snapshot['imageUrl'];
    setState(() {});
  }

  // 親のiitStateメソッドをオーバーライドしています。
  @override
  void initState() {
    super.initState(); // 親クラスの initStateを読んでいます。

    /// この関数の中はこのWidgetが生成されたときに一度だけ呼ばれる。
    fetchTodoList();
    fetchImageUrl();
  }

  static const title = 'TODO';

  @override
  Widget build(BuildContext context) {
    /// ここから下はUIのことを書いていく。
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          if (imageUrl == null)
            IconButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyPage(),
                  ),
                );
                fetchImageUrl();
              },
              icon: const Icon(Icons.face),
            )
          else
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyPage(),
                  ),
                );
                fetchImageUrl();
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl!),
                ),
              ),
            )
        ],
      ),
      body: ListView(
        children: todoList.map(
          // こいつは関数
          (todo) {
            return ListTile(
              title: Text(todo['content']),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // TODO(kenta-wakasa): 削除処理
                  todoList.remove(todo);
                  print(todo.reference.path);
                  todo.reference.delete();
                  setState(() {});
                },
              ),
            );
          },
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // asyncキーワードをつけてあげると　await がつかえる。
          // TODO(kenta-wakasa): ここでTODOに追加していく処理を書く

          // 画面遷移
          // Future型の場合はawaitで待つと確定した値を取り出すことができる。
          await Navigator.of(context).push<String>(
            MaterialPageRoute(
              builder: (context) => AddTodoPage(), // アロー演算子で省略できる。
            ),
          );
          // 追加ページから戻ってきたら最新を取得してあげれば良い。
          fetchTodoList();
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

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

class FirestorePage extends StatefulWidget {
  const FirestorePage({Key? key}) : super(key: key);

  @override
  _FirestorePageState createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  String name = '名前はまだない';

  Future<void> fetchName() async {
    // tests というコレクションに保存されているドキュメントをすべて取得する
    final snapshot = await FirebaseFirestore.instance.collection('tests').get();
    name = snapshot.docs.first['name'];
    setState(() {}); // 画面を更新
  }

  @override
  void initState() {
    super.initState();
    // ここに書いた関数が最初に一度だけ実行される
    fetchName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          name,
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
