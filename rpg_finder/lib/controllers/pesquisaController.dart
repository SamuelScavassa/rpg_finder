import 'dart:async';
import 'package:flutter/material.dart';
import '../views/campanha/resultadoPesquisa.dart';
import 'campanhaController.dart';

Future<void> procurar(String pesquisa, BuildContext context) async {

  
  var x = pesquisa.split(' ');

  final query1 = await firestore
      .collection('campanha')
      .where('tags'.toLowerCase(), arrayContainsAny: x)
      .snapshots();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ResultadoPesquisa(campanha: query1),
    ),
  );
}
