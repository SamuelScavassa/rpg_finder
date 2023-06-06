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
          'Detalhes da campanha ${sessoes['campanha-name'].toString().toLowerCase()}',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
            child: Center(
              child: Text(
                '${sessoes['campanha-name']}',
                style: const TextStyle(fontSize: 20, color: const Color.fromARGB(255, 251, 251, 251)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
            child: Text('Nome do mestre: ${sessoes['mestre-name']}', style: TextStyle(color: const Color.fromARGB(255, 251, 251, 251)),),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Participantes: ${sessoes['players-name'].join(",")}', style: TextStyle(color: const Color.fromARGB(255, 251, 251, 251)),),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () => navigationDiscord(Uri.parse(discordLink!)),
                child: const Text("Discord"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () => popUpSairCampanha(
                    sessoes.id,
                    auth.currentUser!.uid.toString(),
                    auth.currentUser!.displayName!,
                    context),
                child: Text("Sair"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 169, 12, 255),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatView(campanha: sessoes['campanha'].toString()),
                    ),
                  )
                },
                child: Icon(Icons.send),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 169, 12, 255),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
