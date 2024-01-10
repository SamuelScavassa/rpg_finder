import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart';

class AppTheme {
  Color primary = Color.fromARGB(255, 169, 12, 255);
  Color swatch = Color.fromARGB(255, 169, 12, 255);
  Color backgroundapp = Color.fromRGBO(30, 32, 33, 1);
  Color textwhite = Color.fromRGBO(255, 255, 255, 1);

  ThemeData theme() {
    return ThemeData(
      ////////////////////////////// teste
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundapp,
      appBarTheme: AppBarTheme(
        color: backgroundapp,
        elevation: 0.0, 
      ),
      bottomAppBarTheme: BottomAppBarTheme(color: swatch),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: swatch),
      //iconTheme: IconThemeData(color: )
      ///////////////////////////////
    );
  }

  BoxDecoration teste() {
    return const BoxDecoration();
  }

  TextStyle text1() {
    return const TextStyle(
      //fontSize: 10,
      color: Color.fromRGBO(255, 255, 255, 1),
    );
  }

//////////////////////////
/////////Fim///////////
/////////////////////////
}
