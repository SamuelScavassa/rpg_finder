import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../controllers/userController.dart';
import '../../model/user.dart';
import 'package:rpg_finder/controllers/navigationController.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  bool visiPassword = true;

  var formKey = GlobalKey<FormState>();

  var senha = "";
  var email = "";

  void login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      var response = userLogin(email, senha);
      if (await response) {
        Navigator.of(context).popAndPushNamed('/feed');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no login')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          //padding: const EdgeInsets.all(16.0),
          key: formKey,
          child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    "images/Logo.png",
                    height: 100,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      maxLength: 100,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.people_alt_rounded,
                          ),
                          prefixIconColor: Color.fromARGB(255, 169, 12, 255),
                          labelText: "E-mail",
                          floatingLabelStyle: TextStyle(
                              color: Color.fromARGB(255, 169, 12, 255)),
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
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor: Color.fromARGB(255, 169, 12, 255),
                        suffixIconColor: Color.fromARGB(255, 169, 12, 255),
                        labelText: "Senha",
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        floatingLabelStyle:
                            TextStyle(color: Color.fromARGB(255, 169, 12, 255)),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        suffixIcon: GestureDetector(
                          child: Icon(visiPassword == true
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onTap: () {
                            setState(() {
                              visiPassword = !visiPassword;
                            });
                          },
                        ),
                        filled: true),
                    obscureText: visiPassword,
                    onChanged: (value) => senha = value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo de senha obrigatório.";
                      }
                      return null; // deu certo
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => navigationEsqueceuSenha(context),
                        child: const Text(
                          "Esqueceu a senha.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width + 10,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 169, 12, 255))),
                        onPressed: () => login(context),
                        child: const Text("Login"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => navigationCadastro(context),
                        child: const Text(
                          "Não tem conta? ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => navigationCadastro(context),
                        child: const Text(
                          "Crie Agora.",
                          style: TextStyle(
                              color: Color.fromARGB(255, 169, 12, 255)),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
