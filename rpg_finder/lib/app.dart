import 'package:flutter/material.dart';
import 'package:rpg_finder/views/campanha/convites.dart';
import 'package:rpg_finder/views/campanha/feed.dart';
import 'package:rpg_finder/views/user/cadastro.dart';
import 'package:rpg_finder/views/user/esqueceuSenha.dart';
import 'package:rpg_finder/views/user/user-home.dart';
import 'package:rpg_finder/views/user/login.dart';
import 'package:rpg_finder/views/campanha/create-campanha.dart';
import 'package:firebase_auth/firebase_auth.dart';

class App extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String route = '/feed';
    if (auth.currentUser == null) {
      route = '/login';
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/cadastro': (context) => Cadastro(),
        '/login': (context) => Login(),
        '/esqueceuSenha': (context) => EsqueceuSenha(),
        '/user-home': (context) => Home(),
        '/feed': (context) => Feed(),
        '/create-campanha': (context) => CreateCampanha(),
        '/convites': (context) => Convites(),
      },
      initialRoute: route,
    );
  }
}
