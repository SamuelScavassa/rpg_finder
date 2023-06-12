import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_finder/controllers/campanhaController.dart';
import 'package:rpg_finder/views/chat/chatView.dart';
import '../../controllers/popUpsController.dart';

class DetalhesCampanhaAtivas extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> sessoes;

  const DetalhesCampanhaAtivas({
    Key? key,
    required this.sessoes,
  }) : super(key: key);

  @override
  State<DetalhesCampanhaAtivas> createState() => _DetalhesCampanhaAtivasState();
}

class _DetalhesCampanhaAtivasState extends State<DetalhesCampanhaAtivas> {
  late final QueryDocumentSnapshot<Map<String, dynamic>> sessoes;
  late final FirebaseFirestore firestore;
  String? vagasDisponiveis;
  var campanhaId;

  void listaUsuarios(sessoes) {}

  void buscarDadosCampanha() async {
    final campanhaDoc =
        await firestore.collection('campanha').doc(sessoes['campanha']).get();

    setState(() {
      if (campanhaDoc.exists && campanhaDoc['players'] != null) {
        vagasDisponiveis = campanhaDoc['players'].toString();
        campanhaId = campanhaDoc.id;
      } else {
        vagasDisponiveis = "0";
      }
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
      resizeToAvoidBottomInset: false,
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
                  style: const TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Participantes:',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 2),
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
                          title: Text(
                            playerName,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                          trailing: GestureDetector(
                            onTap: () => retirarUserCampanha(
                                sessoes.id,
                                sessoes['players-id'][index],
                                sessoes['players-name'][index],
                                context),
                            child: Icon(
                              Icons.highlight_remove_sharp,
                              color: Colors.purple.shade700,
                            ),
                          ));
                    },
                  ),
                  Text("Vagas restantes: $vagasDisponiveis",
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white)),
                ],
              ),
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
                onTap: () => popUpDeletarCampanha(context, sessoes.id),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red,
                  ),
                  child: Icon(
                    Icons.delete_outlined,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                ),
              ),
              GestureDetector(
                onTap: () => popUpAtualizarCampanha(
                    context, sessoes, campanhaId, sessoes.id),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: Icon(
                    Icons.upload_sharp,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                ),
              ),
              GestureDetector(
                onTap: () => popUpFinalizarCampanha(sessoes.id, context),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.purple,
                  ),
                  child: Icon(
                    Icons.archive,
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
