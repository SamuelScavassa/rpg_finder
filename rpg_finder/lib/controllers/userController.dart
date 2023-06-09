import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

Future<void> createUser(
    String name, String email, String senha, BuildContext context) async {
  try {
    FirebaseAuth user = FirebaseAuth.instance;
    await user.createUserWithEmailAndPassword(email: email, password: senha);
    await userLogin(email, senha);
    addNome(name);
    Navigator.of(context).popAndPushNamed("/feed");
  } catch (e) {
    print(e);
  }
}
Future<bool> checkUserEmail(String email) async {
  var verificarUsuario = await FirebaseFirestore.instance
      .collection("user")
      .where("Email", isEqualTo: email)
      .get();
  if (verificarUsuario.docs.isNotEmpty) {
    return false;
  }
  return true;
}

Future<bool> userLogin(String email, String senha) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: senha);
    return true;
  } catch (e) {
    return false;
  }
}

void addNome(String name) {
  if (auth.currentUser!.displayName == null) {
    auth.currentUser!.updateDisplayName(name);
  }
}

//
Future esqueceuSenha(BuildContext context, String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: Color.fromRGBO(30, 32, 33, 1),
              title: const Text(
                "Enviado o email",
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                "Cheque o seu e-mail ou caixa de spam",
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () =>
                        Navigator.of(context).popAndPushNamed('/login'),
                    child: const Text("Ok",
                        style: TextStyle(
                            color: Color.fromARGB(255, 169, 12, 255),
                            fontSize: 15)))
              ],
            ));
    // ignore: use_build_context_synchronously
  } catch (e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: Color.fromRGBO(30, 32, 33, 1),
              title: const Text(
                "Erro no email",
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                "Cheque se seu email está correto e verique a sua rede",
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK",
                        style: TextStyle(
                            color: Color.fromARGB(255, 169, 12, 255),
                            fontSize: 15)))
              ],
            ));

    return false;
  }
}
void popUpSairConta(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            backgroundColor: Color.fromRGBO(30, 32, 33, 1),
            title: const Text(
              "Sair da Conta",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Você desejar sair da campanha",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  auth.signOut();
                  Navigator.of(context).popAndPushNamed('/login');
                },
                child: const Text(
                  'Sair',
                  style: TextStyle(color: Color.fromARGB(255, 184, 95, 231)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ));
}
