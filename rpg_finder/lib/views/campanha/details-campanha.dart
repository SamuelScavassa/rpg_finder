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
  Future<void> salvar(BuildContext context) async {
    try {
      enviarConvite(campanha.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido enviado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    campanha = widget.campanha;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
            child: Text(
              'Descrição: ${campanha['descricao']}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
            child: Text(
              'Vagas disponiveis: ${campanha['players']}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
            child: campanha['tags'] != null && campanha['tags'].isNotEmpty
                ? Text("Tags: ${campanha['tags'].join(",")} ")
                : const Text("Não tem tags essa campanha"),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width + 10,
              child: ElevatedButton(
                  onPressed: () => enviarConvite(campanha.id),
                  child: const Text("Juntar-se")),
            ),
          ),
        ],
      ),
    );
  }
}