import 'package:flutter/material.dart';

class SampleGmailPage extends StatefulWidget {
  const SampleGmailPage({Key? key}) : super(key: key);

  @override
  _SampleGmailPageState createState() => _SampleGmailPageState();
}

class _SampleGmailPageState extends State<SampleGmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GmailアプリのUIを作りたい'),
      ),
    );
  }
}
