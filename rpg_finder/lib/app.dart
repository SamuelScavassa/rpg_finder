import 'package:flutter/material.dart';
import 'package:rpg_finder/views/user/cadastro.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/cadastro': (context) => Cadastro(), 
      },
      initialRoute: '/cadastro',
    );
  }
}