import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      'user': auth.currentUser!.uid
    });
    await firestore
        .collection('sessoes')
        .add({'campanha': campanha.id, 'mestre': auth.currentUser!.uid});
  } catch (e) {
    print(e);
  }
}

void enviarConvite(String idCampanha) async {
  try {
    var campanha = await firestore.collection('campanha').doc(idCampanha).get();
    if (campanha['players'] > 0) {
      firestore.collection('invites').add({
        'remetente': auth.currentUser!.uid,
        'campanha': idCampanha,
        'destinatario': campanha['user']
      });
    }
  } catch (e) {
    print(e);
  }
}

void aceitarConvite(String idConvite) async {
  var convite = await firestore.collection('invites').doc(idConvite).get();
  var campanha =
      await firestore.collection('campanhas').doc(convite['campanha']).get();
  var sessao = await firestore
      .collection('sessoes')
      .where('campanha', isEqualTo: campanha.id)
      .get();
  if (campanha['players'] > 0) {
    await firestore
        .collection('campanhas')
        .doc(campanha.id)
        .update({'players': (campanha['players'] - 1)});
    var py = campanha['players'];
    await firestore
        .collection('sessoes')
        .doc(sessao.docs.first.id)
        .update({'$py': convite['remetente']});
  }
}
