import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
import 'package:rpg_finder/views/chat/chatSend.dart';
import '../../controllers/campanhaController.dart';
import '../../controllers/campanhaController.dart';

class ChatView extends StatefulWidget {
  final String campanha;
  const ChatView({super.key, required this.campanha});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final String campanha;

  @override
  void initState() {
    super.initState();
    campanha = widget.campanha;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore.collection('chat').orderBy('time', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var msgs = snapshot.data!.docs
                .where((element) => element['campanha'] == campanha);
            return ListView(
              reverse: true,
              children: msgs
                  .map((msg) => Container(
                        width: 300,
                        alignment: AlignmentDirectional.bottomStart,
                        padding: EdgeInsets.all(20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${msg['nome']}:',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 30),
                              ),
                              Text(
                                msg['txt'],
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 20),
                              ),
                            ]),
                      ))
                  .toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatSend(campanha: campanha.toString()),
            ),
          )
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
