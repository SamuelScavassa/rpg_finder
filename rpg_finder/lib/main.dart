import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rpg_finder/app.dart';

const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyBGAKc5kPyyG2l6f5CcW1nXy7_7SG7s0Aw",
    authDomain: "rpg-finder---trio-monstro.firebaseapp.com",
    projectId: "rpg-finder---trio-monstro",
    storageBucket: "rpg-finder---trio-monstro.appspot.com",
    messagingSenderId: "388955151320",
    appId: "1:388955151320:web:e40d5e3883b5d4c4d5b0ad",
    measurementId: "G-LQ8HD391G9");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(App());
}
