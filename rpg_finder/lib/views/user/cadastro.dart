import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? name = '';
  String? email = '';
  String? senha = '';
  var formKey = GlobalKey<FormState>();

  void salvar(BuildContext context) async {
    var x = await testeEmail(context);
    if (x) {
      if (formKey.currentState!.validate()) {
        firestore
            .collection('user')
            .add({'Name': name, 'Email': email, 'Senha': senha});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tente outro email')),
      );
    }
  }

  Future<bool> testeEmail(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final verificarUsuario = await FirebaseFirestore.instance
          .collection("user")
          .where("Email", isEqualTo: email)
          .get();
      // Verificando se o email existe
      if (verificarUsuario.docs.isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  void login(BuildContext context) {
    Navigator.of(context).pushNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: "Nome",
                ),
                onChanged: (value) => name = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo obrigatório";
                  }

                  return null;
                },
              ),
              Container(
                height: 10,
              ),
              TextFormField(
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo obrigatório";
                  }
                  if (value.contains('@') == false) {
                    return "Insira um email válido";
                  }
                  return null;
                },
              ),
              Container(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) => senha = value,
                autofocus: true,
                obscureText: true,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: "Senha",
                ),
                onSaved: (value) => senha = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo obrigatório";
                  }
                  if (value.length < 6) {
                    return "Minímo 6 caracteres";
                  }
                  return null;
                },
              ),
              Container(
                height: 10,
              ),
              TextFormField(
                autofocus: true,
                obscureText: true,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: "Confirmação de senha",
                ),
                onSaved: (value) {},
                validator: (value) {
                  if (value != senha) {
                    return "Senhas diferentes";
                  }
                  return null;
                },
              ),
              Container(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => salvar(context),
                child: const Text("Cadastre-se"),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => login(context),
                child: const Text(
                  "Já possui uma conta? Faça login aqui",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
