import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rpg_finder/controllers/campanhaController.dart';

//o operador ternario

class DetalhesCampanha extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> campanha;

  const DetalhesCampanha({Key? key, required this.campanha}) : super(key: key);

  @override
  State<DetalhesCampanha> createState() => _DetalhesCampanha();
}

class _DetalhesCampanha extends State<DetalhesCampanha> {
  late final QueryDocumentSnapshot<Map<String, dynamic>> campanha;

  @override
  void initState() {
    super.initState();
    campanha = widget.campanha;
  }

  void enviar() {
    try {
      enviarConvite(campanha.id, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar o convite $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 32, 33, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 169, 12, 255),
        title: Text(
            'Detalhes da campanha ${campanha['nome'].toString().toLowerCase()}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text('${campanha['nome']}',
                    style: const TextStyle(fontSize: 20, color: Colors.white))),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
            child: Text(
              'Descrição: ${campanha['descricao']}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
            child: Text(
              'Vagas disponiveis: ${campanha['players']}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
            child: campanha['tags'] != null && campanha['tags'].isNotEmpty
                ? Text(
                    "Tags: ${campanha['tags'].join(",")} ",
                    style: const TextStyle(color: Colors.white),
                  )
                : const Text("Não tem tags essa campanha",
                    style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width + 10,
              child: ElevatedButton(
                onPressed: enviar,
                child: const Text("Juntar-se"),
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
