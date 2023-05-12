import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

Future<void> createUser(String name, String email, String senha) async {
  try {
    FirebaseAuth user = FirebaseAuth.instance;
    await user.createUserWithEmailAndPassword(email: email, password: senha);
    await userLogin(email, senha);
    addNome(name);
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
              title: Text("Enviado o email"),
              content: Text("Cheque o seu e-mail ou caixa de spam"),
              actions: <Widget>[
                TextButton(
                    onPressed: () =>
                        Navigator.of(context).popAndPushNamed('/login'),
                    child: Text("Ok"))
              ],
            ));

    // ignore: use_build_context_synchronously
  } catch (e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Erro no email"),
              content:
                  Text("Cheque se seu email está correto e verique a sua rede"),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Ok"))
              ],
            ));

    return false;
  }
}


