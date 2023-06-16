import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'campanhaController.dart';
import 'navigationController.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

void popUpAtualizarCampanha(
    BuildContext context, sessoes, campanhaId, sessoesId) async {
  var campanhaRef = firestore.collection('campanha').doc(campanhaId);
  var campanhaDoc = await campanhaRef.get();

  var campanha = campanhaDoc.data() as Map<String, dynamic>;

  // ignore: use_build_context_synchronously
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String nome = sessoes['campanha-name'].toString();
      String descricao = campanha['descricao'].toString();
      String discord = campanha['discord'].toString();
      int jogadores = campanha['players'];
      List<dynamic> tags = campanha['tags'].toList();

      return AlertDialog(
        backgroundColor: Color.fromRGBO(30, 32, 33, 1),
        title: const Text(
          'Atualizar Campanha',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                       TextFormField(
              maxLines: 1,
              maxLength: 30,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Título da campanha',
                labelStyle: TextStyle(color: Colors.white),
                counter: Offstage(),
              ),
              onChanged: (value) => nome = value,
            ),
            TextFormField(
              minLines: 1,
              maxLength: 250,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Descrição',
                labelStyle: TextStyle(color: Colors.white),
                counter: Offstage(),
              ),
              onChanged: (value) => descricao = value,
            ),
            TextFormField(
              maxLines: 1,
              maxLength: 30,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Link Discord',
                labelStyle: TextStyle(color: Colors.white),
                counter: Offstage(),
              ),
              onChanged: (value) => discord = value,
            ),
            TextFormField(
              maxLines: 1,
              maxLength: 2,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Número de Jogadores',
                labelStyle: TextStyle(color: Colors.white),
                counter: Offstage(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => jogadores = int.tryParse(value) ?? 0,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color.fromARGB(255, 169, 12, 255)),
            ),
          ),
          TextButton(
            onPressed: () {
              tags[0] = nome;
              atualizarCampanha(nome, descricao, discord, jogadores, campanhaId,
                  sessoesId, tags);
              navigationAtivas(context);
            },
            child: const Text(
              'Atualizar',
              style: TextStyle(color: Color.fromARGB(255, 169, 12, 255)),
            ),
          ),
        ],
      );
    },
  );
}

void popUpDeletarCampanha(BuildContext context, String idSessao) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            backgroundColor: Color.fromRGBO(30, 32, 33, 1),
            title: const Text(
              "Apagar a campanha",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Você desejar apagar a campanha",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => deletarCampanha(idSessao, context),
                child: const Text(
                  'Apagar',
                  style: TextStyle(color: Color.fromARGB(255, 184, 95, 231)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ));
}

void popUpFinalizarCampanha(String idSessao, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            backgroundColor: Color.fromRGBO(30, 32, 33, 1),
            title: const Text(
              "Finalizar a campanha",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Você desejar finalizar a campanha",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => finalizarCampanha(idSessao, context),
                child: const Text(
                  'Finalizar',
                  style: TextStyle(color: Color.fromARGB(255, 184, 95, 231)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ));
}

void popUpSairCampanha(
    String idSessao, String idUser, String nome, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            backgroundColor: Color.fromRGBO(30, 32, 33, 1),
            title: const Text(
              "Sair da campanha",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Você desejar sair da campanha",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => sairCampanha(idSessao, idUser, nome, context),
                child: const Text(
                  'Sair',
                  style: TextStyle(color: Color.fromARGB(255, 184, 95, 231)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ));
}

void popUpHistorico(
    BuildContext context, String nome, String mestre, List<dynamic> players) {
  final x = players.toString().replaceAll('[', ' ');
  final nomes = x.toString().replaceAll(']', ' ');
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            backgroundColor: Color.fromRGBO(30, 32, 33, 1),
            title: const Text(
              "Campanha",
              style: TextStyle(color: Colors.white),
            ),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "$nome",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "Mestre: $mestre",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'Players: ${nomes}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Voltar',
                  style: TextStyle(color: Color.fromARGB(255, 169, 12, 255)),
                ),
              ),
            ],
          ));
}
