import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


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

  void listaUsuarios(sessoes) {}

  void buscarDadosCampanha() async {
    final campanhaDoc =
        await firestore.collection('campanha').doc(sessoes['campanha']).get();

    setState(() {
      if (campanhaDoc.exists && campanhaDoc['players'] != null) {
        vagasDisponiveis = campanhaDoc['players'].toString();
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
                style: const TextStyle(fontSize: 20),
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
                  style: TextStyle(fontSize: 16),
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
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: GestureDetector(
                          onTap: () => null,
                          child: Icon(
                            Icons.highlight_remove_sharp,
                            color: Colors.red.shade700,
                          ),
                        ));
                  },
                ),
                Text("Vagas restantes: $vagasDisponiveis",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () => null,
                    child: Text("Apagar Campanha"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ))),
        ],
      ),
    );
  }
}
