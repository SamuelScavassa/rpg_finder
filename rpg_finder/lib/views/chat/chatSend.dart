import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
import 'package:rpg_finder/views/chat/chatView.dart';
import '../../controllers/campanhaController.dart';
import '../../controllers/campanhaController.dart';

class ChatSend extends StatefulWidget {
  final String campanha;
  const ChatSend({super.key, required this.campanha});

  @override
  State<ChatSend> createState() => _ChatSendState();
}

class _ChatSendState extends State<ChatSend> {
  late final String campanha;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    campanha = widget.campanha;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Text("Digite:"),
        TextField(
          controller: controller,
          minLines: 1,
          maxLength: 500,
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          firestore.collection('chat').add({
            'campanha': campanha,
            'nome': auth.currentUser!.displayName,
            'txt': controller.text,
            'time': Timestamp.now()
          });
          Navigator.of(context).pop();
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
