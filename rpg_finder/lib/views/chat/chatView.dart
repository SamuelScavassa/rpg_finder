import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
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
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    campanha = widget.campanha;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat bolado do Samuel'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore
              .collection('chat')
              .orderBy('order', descending: true)
              .snapshots(),
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
                              Text(
                                msg['time'].toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 10),
                              ),
                            ]),
                      ))
                  .toList(),
            );
          }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Container(
          margin: EdgeInsets.all(5),
          width: 700,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white60),
            borderRadius: BorderRadius.circular(
              70,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: '...',
                    hintStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            bottomLeft: Radius.circular(70))),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                          bottomLeft: Radius.circular(70)),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Escreva algo 👌')),
                      );
                    } else {
                      DateTime tsdate = DateTime.now();
                      String datetime = tsdate.year.toString() +
                          "/" +
                          tsdate.month.toString() +
                          "/" +
                          tsdate.day.toString();

                      firestore.collection('chat').add({
                        'campanha': campanha,
                        'nome': auth.currentUser!.displayName,
                        'txt': controller.text,
                        'time': datetime,
                        'order': DateTime.now()
                      });
                      controller.text = '';
              
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
