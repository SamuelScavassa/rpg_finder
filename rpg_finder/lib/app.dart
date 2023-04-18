import 'package:flutter/material.dart';
import 'package:rpg_finder/views/campanha/feed.dart';
import 'package:rpg_finder/views/user/cadastro.dart';
import 'package:rpg_finder/views/user/home.dart';
import 'package:rpg_finder/views/user/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/cadastro': (context) => Cadastro(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/feed': (context) => Feed(),
      },
      initialRoute: '/login',
    );
  }
}
