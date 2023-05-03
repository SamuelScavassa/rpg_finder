import 'package:flutter/material.dart';
import 'package:rpg_finder/views/campanha/feed.dart';
import 'package:rpg_finder/views/user/cadastro.dart';
import 'package:rpg_finder/views/user/esqueceuSenha.dart';
import 'package:rpg_finder/views/user/user-home.dart';
import 'package:rpg_finder/views/user/login.dart';
import 'package:rpg_finder/views/campanha/create-campanha.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/cadastro': (context) => Cadastro(),
        '/login': (context) => Login(),
        '/esqueceuSenha': (context) => EsqueceuSenha(),
        '/user-home': (context) => Home(),
        '/feed': (context) => Feed(),
        '/create-campanha': (context) => CreateCampanha(),
      },
      initialRoute: '/login',
    );
  }
}
