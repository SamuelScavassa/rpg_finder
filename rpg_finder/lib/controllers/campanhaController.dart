import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rpg_finder/views/campanha/detailsCampanhaAtivas.dart';
import '../views/campanha/details-campanha.dart';
import '../views/campanha/detailsCampanhasParticipando.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

void salvarCampanha(String descricao, String discord, String name,
    int jogadores, List<String>? tags) async {
  try {
    var campanha = await firestore.collection('campanha').add({
      'descricao': descricao,
      'discord': 'https://$discord',
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
    var query = await firestore
        .collection('chat')
        .where('campanha', isEqualTo: sess['campanha'])
        .get();

    query.docs.forEach((element) {
      firestore.collection('chat').doc(element.id).delete();
    });
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
    var query = await firestore
        .collection('chat')
        .where('campanha', isEqualTo: sess['campanha'])
        .get();

    query.docs.forEach((element) {
      firestore.collection('chat').doc(element.id).delete();
    });
    Navigator.of(context).pop();
  } catch (e) {}
}
