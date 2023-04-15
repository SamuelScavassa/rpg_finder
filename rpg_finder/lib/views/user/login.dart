import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:email_validator/email_validator.dart';
// ignore: unused_import
import 'package:rpg_finder/user/cadastro.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool visiPassword = true;
  var formKey = GlobalKey<FormState>();
  var senha = "";
  var email = "";

  void cadastro(BuildContext context) {
    Navigator.of(context).pushNamed("/cadastro");
  }

  void login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        //Aqui e quero pegar o campo no banco que tem o enail iqual que foi passado
        final verificarUsuario = await FirebaseFirestore.instance
            .collection("user")
            .where("Email", isEqualTo: email)
            .get();
        // Verificando se o email existe
        if (verificarUsuario.docs.isEmpty) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email Incorreto')),
          );
        }
        //Verificando se a senha está correta se tiver vai para a tela principal(home)
        final dadoUsuario = verificarUsuario.docs.first;
        if (dadoUsuario['Senha'] == senha) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).popAndPushNamed("/home");
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Senha incorreta.')),
          );
        }
      } // tratanto caso acha algum erro
      catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro no login')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login '),
      ),
      body: Form(
        //padding: const EdgeInsets.all(16.0),
        key: formKey,
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  maxLines: 1,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.people_alt_rounded),
                    hintText: "Digite o seu email",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  onChanged: (value) => email = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Campo de Email Obrigatorio.";
                    } else if (!EmailValidator.validate(value)) {
                      return "Digite um email valido";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: "Digite sua Senha",
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      suffixIcon: GestureDetector(
                        child: Icon(visiPassword == true
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onTap: () {
                          setState(() {
                            visiPassword = !visiPassword;
                          });
                        },
                      )),
                  obscureText: visiPassword,
                  onChanged: (value) => senha = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Campo de senha obrigatorio.";
                    }
                    return null; // deu certo
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => login(context),
                  child: const Text("Login"),
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () => cadastro(context),
                  child: const Text(
                    "Não tem cadastro? Crie Agora",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
