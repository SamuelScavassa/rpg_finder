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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(30, 32, 33, 1),
        appBar: AppBar(
          title: const Text("Voltar",
              style: TextStyle(
                color: Colors.white,
              )),
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(30, 32, 33, 1),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Insira o enderço de email cadastrado: ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLines: 1,
                maxLength: 100,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.people_alt_rounded,
                    ),
                    prefixIconColor: Color.fromARGB(255, 169, 12, 255),
                    labelText: "E-mail",
                    floatingLabelStyle:
                        TextStyle(color: Color.fromARGB(255, 169, 12, 255)),
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
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
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 169, 12, 255))),
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
