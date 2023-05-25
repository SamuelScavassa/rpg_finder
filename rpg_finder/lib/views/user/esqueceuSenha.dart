import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rpg_finder/views/user/login.dart';

import '../../controllers/userController.dart';

class EsqueceuSenha extends StatefulWidget {
  const EsqueceuSenha({super.key});

  @override
  State<EsqueceuSenha> createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha> {
  String email = "";
/*
  void salvar(BuildContext context) {
    try {
      esqueceuSenha(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Confirmação enviado para o email: $email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar o email $e')),
      );
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Teste")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                maxLines: 1,
                maxLength: 100,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.people_alt_rounded),
                    labelText: "E-mail",
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    filled: true),
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo de email obrigatório.";
                  } /*else if (!EmailValidator.validate(value)) {
                          return "Digite um email valido";
                        }*/
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width + 10,
                  child: ElevatedButton(
                    onPressed: () => esqueceuSenha(context, email),
                    child: const Text("Enviar"),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
