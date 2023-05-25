import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//novos
import 'package:flutter/material.dart';
import 'package:rpg_finder/views/campanha/detailsCampanhaAtivas.dart';
import '../views/campanha/details-campanha.dart';
import '../views/campanha/detailsCampanhasParticipando.dart';
import '../views/campanha/resultadoPesquisa.dart';

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
