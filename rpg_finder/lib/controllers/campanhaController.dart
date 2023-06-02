import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//novos
import 'package:flutter/material.dart';
import 'package:rpg_finder/views/campanha/detailsCampanhaAtivas.dart';
import '../views/campanha/details-campanha.dart';
import '../views/campanha/detailsCampanhasParticipando.dart';
import '../views/campanha/resultadoPesquisa.dart';
import 'navigationController.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

void salvarCampanha(String descricao, String discord, String name,
    int jogadores, List<String>? tags) async {
  try {
    var campanha = await firestore.collection('campanha').add({
      'descricao': descricao,
      'discord': discord,
      'nome': name,
      'players': jogadores,
      'tags': tags,
      'user': auth.currentUser!.uid,
      'disable': true
    });
    await firestore.collection('sessoes').add({
      'campanha-name': name,
      'campanha': campanha.id,
      'mestre': auth.currentUser!.uid,
      'mestre-name': auth.currentUser!.displayName.toString(),
      'players-id': [],
      'players-name': []
    });
  } catch (e) {
    print(e);
  }
}

void enviarConvite(String idCampanha, BuildContext context) async {
  try {
    var campanha = await firestore.collection('campanha').doc(idCampanha).get();
    if (campanha['user'] == auth.currentUser!.uid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Essa campanha é sua :-)')),
      );
    } else {
      if (campanha['players'] > 0) {
        firestore.collection('invites').add({
          'remetente': auth.currentUser!.uid,
          'campanha': idCampanha,
          'destinatario': campanha['user'],
          'nome-campanha': campanha['nome'],
          'nome-user': auth.currentUser!.displayName,
          'disable': false
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Convite envido!')),
        );
      }
    }
  } catch (e) {
    print(e);
  }
}

void aceitarConvite(String idConvite) async {
  try {
    List listaPlayers = [];
    List playersName = [];

    var convite = await firestore.collection('invites').doc(idConvite).get();
    var sessao = await firestore
        .collection('sessoes')
        .where('campanha', isEqualTo: convite['campanha'])
        .get();

    listaPlayers = sessao.docs.first['players-id'];
    playersName = sessao.docs.first['players-name'];

    var campanha =
        await firestore.collection('campanha').doc(convite['campanha']).get();
    var x = campanha['players'].toString();
    if (int.parse(x) > 0) {
      int atual = campanha['players'] - 1;
      if (atual == 0) {
        await firestore
            .collection('campanha')
            .doc(campanha.id)
            .update({'disable': false});
      } else {
        await firestore
            .collection('campanha')
            .doc(campanha.id)
            .update({'players': atual});
      }

      listaPlayers.add(convite['remetente']);
      playersName.add(convite['nome-user']);

      await firestore
          .collection('sessoes')
          .doc(sessao.docs.first.id)
          .update({'players-id': listaPlayers});
      await firestore
          .collection('sessoes')
          .doc(sessao.docs.first.id)
          .update({'players-name': playersName});

      await firestore.collection('invites').doc(idConvite).delete();
    }
  } catch (e) {
    print(e);
  }
}

void negarConvite(String idConvite) async {
  await firestore.collection('invites').doc(idConvite).delete();
}

//
void detalhesCampanha(BuildContext context, campanhas, index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetalhesCampanha(campanha: campanhas[index]),
    ),
  );
}

void detalhesCampanhaPartcipando(BuildContext context, sessoes, index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          DetalhesCampanhaParticipando(sessoes: sessoes[index]),
    ),
  );
}

void detalhesCampanhaAtivas(BuildContext context, sessoes, index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetalhesCampanhaAtivas(sessoes: sessoes[index]),
    ),
  );
}

void deletarCampanha(String idSessao, BuildContext context) async {
  try {
    var sess = await firestore.collection('sessoes').doc(idSessao).get();
    await firestore.collection('campanha').doc(sess['campanha']).delete();
    await firestore.collection('sessoes').doc(sess.id).delete();
    Navigator.of(context).pop();
  } catch (e) {}
}

void sairCampanha(
    String idSessao, String idUser, String nome, BuildContext context) async {
  try {
    var sess = await firestore.collection('sessoes').doc(idSessao).get();
    List nomes = await sess['players-name'];
    nomes.remove(nome);
    List ids = await sess['players-id'];
    ids.remove(idUser);
    await firestore.collection('sessoes').doc(idSessao).update({
      'players-name': nomes,
      'players-id': ids,
    });
    var campanha =
        await firestore.collection('campanha').doc(sess['campanha']).get();
    if (campanha['disable']) {
      await firestore
          .collection('campanha')
          .doc(sess['campanha'])
          .update({'players': FieldValue.increment(1)});
    } else {
      await firestore
          .collection('campanha')
          .doc(campanha.id)
          .update({'disable': true});
    }

    Navigator.of(context).pop();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao sair')),
    );
  }
}

void retirarUserCampanha(
    String idSessao, String idUser, String nome, BuildContext context) async {
  try {
    var sess = await firestore.collection('sessoes').doc(idSessao).get();
    var campanha =
        await firestore.collection('campanha').doc(sess['campanha']).get();
    List nomes = await sess['players-name'];
    nomes.remove(nome);
    List ids = await sess['players-id'];
    ids.remove(idUser);
    await firestore.collection('sessoes').doc(idSessao).update({
      'players-name': nomes,
      'players-id': ids,
    });
    if (campanha['disable']) {
      await firestore
          .collection('campanha')
          .doc(sess['campanha'])
          .update({'players': FieldValue.increment(1)});
    } else {
      await firestore
          .collection('campanha')
          .doc(campanha.id)
          .update({'disable': true});
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Player removido')),
    );
    Navigator.of(context).pop();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao remover :-(')),
    );
  }
}

Future<void> procurar(String pesquisa, BuildContext context) async {
  StreamController<QuerySnapshot<Map<String, dynamic>>> controller =
      StreamController<QuerySnapshot<Map<String, dynamic>>>();

  final query1 = await firestore
      .collection('campanha')
      .where('tags'.toLowerCase(), arrayContains: pesquisa.toLowerCase())
      .snapshots();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ResultadoPesquisa(campanha: query1),
    ),
  );
}

void atualizarCampanha(String nome, String descricao, String discord,
    int jogadores, campanhaId, sessoesId, tags) {
  final campanha = firestore.collection('campanha').doc(campanhaId);
  final sessoes = firestore.collection('sessoes').doc(sessoesId);

  sessoes.update({
    'campanha-name': nome,
  }).then((_) {
    // ignore: avoid_print
    print('sessoes atualizada com sucesso!');
  }).catchError((error) {
    print('Erro ao atualizar a sessoes: $error');
  });
  campanha.update({
    'tags': tags,
    'nome': nome,
    'descricao': descricao,
    'discord': discord,
    'players': jogadores,
  }).then((_) {
    print('Campanha atualizada com sucesso!');
  }).catchError((error) {
    print('Erro ao atualizar a campanha: $error');
  });
}

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
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Título da campanha',
                labelStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (value) => nome = value,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Descrição',
                labelStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (value) => descricao = value,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Link Discord',
                  labelStyle: TextStyle(color: Colors.white)),
              onChanged: (value) => discord = value,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Número de Jogadores',
                labelStyle: TextStyle(color: Colors.white),
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

void finalizarCampanha(String idSessao, BuildContext context) async {
  try {
    var sess = await firestore.collection('sessoes').doc(idSessao).get();
    await firestore
        .collection('campanha')
        .doc(sess['campanha'])
        .update({'disable': false});
    var sessao = await firestore.collection('sessoes').doc(sess.id).get();
    List ids = sessao['players-id'];
    ids.add(sessao['mestre']);
    await firestore.collection('finalizadas').add({
      'campanha-name': sessao['campanha-name'],
      'mestre-name': sessao['mestre-name'],
      'players-id': ids,
      'players-name': sessao['players-name']
    });
    await firestore.collection('sessoes').doc(sess.id).delete();
    Navigator.of(context).pop();
  } catch (e) {}
}



// PopUp Finalizar Campanha
/*void popUpFinalizarCampanha(BuildContext context, String idSessao) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            backgroundColor: Color.fromRGBO(30, 32, 33, 1),
            title: const Text("Apagar a campanha", style: TextStyle(color: Colors.white),),
            content: const Text("Você desejar apagar a campanha", style: TextStyle(color: Colors.white),),
            actions: <Widget>[
              TextButton(
                  onPressed: () => deletarCampanha(idSessao, context),
                  child: const Text("Ok")),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 169, 12, 255)),),
              ),
            ],
          ));
}*/

