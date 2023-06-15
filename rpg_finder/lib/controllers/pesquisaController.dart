import 'dart:async';
import 'package:flutter/material.dart';
import '../views/campanha/resultadoPesquisa.dart';
import 'campanhaController.dart';

Future<void> procurar(String pesquisa, BuildContext context) async {
  pesquisa = pesquisa.toLowerCase();
  var x = pesquisa.split(' ');

  final query1 = await firestore
      .collection('campanha')
      .where('tags'.toLowerCase(), arrayContainsAny: x)
      .snapshots();

  await Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ResultadoPesquisa(campanha: query1),
    ),
  );
}
