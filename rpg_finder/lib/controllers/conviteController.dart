import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

void enviarConvite(String idCampanha, BuildContext context) async {
  try {
    var campanha = await firestore.collection('campanha').doc(idCampanha).get();
    if (campanha['user'] == auth.currentUser!.uid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            behavior: SnackBarBehavior.floating,
            elevation: 150.0,
            content: Text('Essa campanha é sua :-)')),
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
          SnackBar(
              behavior: SnackBarBehavior.floating,
              elevation: 150.0,
              content: Text('Convite envido!')),
        );
      }
    }
  } catch (e) {
    print(e);
  }
}

Future<bool> verificar(String user, String sessao) async {
  var result = await firestore.collection('sessoes').doc(sessao).get();
  List aux = result['players-id'];
  if (aux.contains(user)) {
    return false;
  }
  return true;
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
    if (await verificar(
        convite['remetente'].toString(), sessao.docs.first.id.toString())) {
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
              .update({'disable': false, 'players': 0});
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
    } else {
      await firestore.collection('invites').doc(idConvite).delete();
    }
  } catch (e) {
    print(e);
  }
}

void negarConvite(String idConvite) async {
  await firestore.collection('invites').doc(idConvite).delete();
}
