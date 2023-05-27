import 'package:flutter/material.dart';
import 'package:rpg_finder/controllers/userController.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  String? name = '';
  String? email = '';
  String? senha = '';
  var formKey = GlobalKey<FormState>();

  Future<void> salvar(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      createUser(name!, email!, senha!, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tente outro email')),
      );
    }
  }

  void login(BuildContext context) {
    Navigator.of(context).popAndPushNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 32, 33, 1),
      body: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.checklist_rounded,
                size: 100,
                color: Color.fromARGB(255, 169, 12, 255),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                maxLines: 1,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.people,
                    ),
                    prefixIconColor: Color.fromARGB(255, 169, 12, 255),
                    labelText: "Nome",
                    floatingLabelStyle:
                        TextStyle(color: Color.fromARGB(255, 169, 12, 255)),
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    )),
                onChanged: (value) => name = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo obrigatório";
                  }

                  return null;
                },
              ),
              Container(
                height: 20,
              ),
              TextFormField(
                maxLines: 1,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email,
                    ),
                    prefixIconColor: Color.fromARGB(255, 169, 12, 255),
                    labelText: "Email",
                    floatingLabelStyle:
                        TextStyle(color: Color.fromARGB(255, 169, 12, 255)),
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    )),
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
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    prefixIconColor: Color.fromARGB(255, 169, 12, 255),
                    labelText: "Senha",
                    floatingLabelStyle:
                        TextStyle(color: Color.fromARGB(255, 169, 12, 255)),
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    )),
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
                height: 20,
              ),
              TextFormField(
                autofocus: true,
                obscureText: true,
                maxLines: 1,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    prefixIconColor: Color.fromARGB(255, 169, 12, 255),
                    labelText: "Confirme sua senha",
                    floatingLabelStyle:
                        TextStyle(color: Color.fromARGB(255, 169, 12, 255)),
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    )),
                onSaved: (value) {},
                validator: (value) {
                  if (value != senha) {
                    return "Senhas diferentes";
                  }
                  return null;
                },
              ),
              Container(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => salvar(context),
                child: const Text("Cadastre-se"),
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 169, 12, 255))),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => login(context),
                child: const Text(
                  "Já possui uma conta? Faça login aqui",
                  style: TextStyle(color: Color.fromARGB(255, 169, 12, 255)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
