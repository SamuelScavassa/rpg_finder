import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_finder/controllers/campanhaController.dart';
import 'package:rpg_finder/views/chat/chatView.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesCampanhaParticipando extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> sessoes;

  const DetalhesCampanhaParticipando({
    Key? key,
    required this.sessoes,
  }) : super(key: key);

  @override
  State<DetalhesCampanhaParticipando> createState() =>
      _DetalhesCampanhaParticipandoState();
}

class _DetalhesCampanhaParticipandoState
    extends State<DetalhesCampanhaParticipando> {
  late final QueryDocumentSnapshot<Map<String, dynamic>> sessoes;
  late final FirebaseFirestore firestore;
  String? discordLink;

  void navigationDiscord(Uri discord) async {
    if (await canLaunchUrl(discord)) {
      await launchUrl(discord);
    } else {
      throw 'Não foi possível abrir o link $discord';
    }
  }

  void buscarDadosCampanha() async {
    final campanhaDoc =
        await firestore.collection('campanha').doc(sessoes['campanha']).get();

    setState(() {
      discordLink = campanhaDoc['discord'];
    });
  }

  @override
  void initState() {
    super.initState();
    sessoes = widget.sessoes;
    firestore = FirebaseFirestore.instance;
    buscarDadosCampanha();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes da campanha',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
              child: Center(
                child: Text(
                  '${sessoes['campanha-name']}',
                  style: const TextStyle(
                      fontSize: 25,
                      color: const Color.fromARGB(255, 251, 251, 251)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                'Nome do mestre: ${sessoes['mestre-name']}',
                style: TextStyle(
                    color: const Color.fromARGB(255, 251, 251, 251),
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Participantes:',
                style: TextStyle(
                    color: const Color.fromARGB(255, 251, 251, 251),
                    fontSize: 18),
              ),
            ),
            const SizedBox(height: 5),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: sessoes['players-name'].length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 0);
              },
              itemBuilder: (BuildContext context, int index) {
                final playerName = sessoes['players-name'][index];
                return ListTile(
                  title: Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromARGB(255, 169, 12, 255),
                    ),
                    child: Text(
                      playerName,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => popUpSairCampanha(
                    sessoes.id,
                    auth.currentUser!.uid.toString(),
                    auth.currentUser!.displayName!,
                    context),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red,
                  ),
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                ),
              ),
              GestureDetector(
                onTap: () => navigationDiscord(Uri.parse(discordLink!)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: Icon(
                    Icons.discord,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatView(campanha: sessoes['campanha'].toString()),
                    ),
                  )
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue,
                  ),
                  child: Icon(
                    Icons.message_outlined,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
