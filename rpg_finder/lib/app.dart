import 'package:flutter/material.dart';
import 'package:rpg_finder/app_theme.dart';
import 'package:rpg_finder/views/campanha/campanhasAtivas.dart';
import 'package:rpg_finder/views/campanha/campanhasParticipando.dart';
import 'package:rpg_finder/views/campanha/convites.dart';
import 'package:rpg_finder/views/campanha/feed.dart';
import 'package:rpg_finder/views/campanha/historicoCampanha.dart';
import 'package:rpg_finder/views/user/cadastro.dart';
import 'package:rpg_finder/views/user/esqueceuSenha.dart';
import 'package:rpg_finder/views/user/user-home.dart';
import 'package:rpg_finder/views/user/login.dart';
import 'package:rpg_finder/views/user/user-update.dart';
import 'package:rpg_finder/views/campanha/create-campanha.dart';
import 'package:firebase_auth/firebase_auth.dart';

class App extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  AppTheme _appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    String route = '/feed';
    if (auth.currentUser == null) {
      route = '/login';
    }
    return MaterialApp(
      title: 'RPG Finder',
      theme: _appTheme.theme(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/cadastro': (context) => Cadastro(),
        '/login': (context) => Login(),
        '/esqueceuSenha': (context) => EsqueceuSenha(),
        '/user-home': (context) => Home(),
        '/feed': (context) => Feed(),
        '/create-campanha': (context) => CreateCampanha(),
        '/convites': (context) => Convites(),
        '/ativas': (context) => CampanhasAtivas(),
        '/participando': (context) => CampanhasParticipando(),
        '/historico': (context) => HistoricoCampanha(),
        '/user-update': (context) => UpdateUser(),
      },
      initialRoute: route,
    );
  }
}
