import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rpg_finder/controllers/campanhaController.dart';

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
          Text('Nome da campanha: ${campanha['nome']}'),
          Text('Descrição: ${campanha['descricao']}'),
          Text('Jogadores: ${campanha['players']}'),
          Text('Tags: ${campanha['tags'].join(", ")}'),
          Text('Discord: ${campanha['discord']}'),
          ElevatedButton(
              onPressed: () => salvar(context), child: Text("Juntar-se")),
        ],
      ),
    );
  }
}
