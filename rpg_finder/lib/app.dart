import 'package:flutter/material.dart';
import 'package:rpg_finder/views/user/cadastro.dart';
import 'package:rpg_finder/views/user/home.dart';
import 'package:rpg_finder/views/user/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/cadastro': (context) => Cadastro(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
      },
      initialRoute: '/login',
    );
  }
}
