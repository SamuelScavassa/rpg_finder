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
                  prefixIcon: Icon(Icons.people),
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
                height: 20,
              ),
              TextFormField(
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: "Email",
                  labelText: "Email",
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
                  prefixIcon: const Icon(Icons.lock),
                  labelText: "Senha",
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
                height: 20,
              ),
              TextFormField(
                autofocus: true,
                obscureText: true,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: "Confirmação",
                  prefixIcon: const Icon(Icons.lock),
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
                height: 20,
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
