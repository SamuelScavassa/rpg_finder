import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

void createUser(String name, String email, String senha) {
  firestore
      .collection('user')
      .add({'Name': name, 'Email': email, 'Senha': senha});
}

Future<bool> checkUserEmail(String email) async
{
  var verificarUsuario = await FirebaseFirestore.instance
          .collection("user")
          .where("Email", isEqualTo: email)
          .get();
  if(verificarUsuario.docs.isNotEmpty){
    return false;
  }
  return true;
}