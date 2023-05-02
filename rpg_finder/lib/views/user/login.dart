import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../controllers/userController.dart';
import '../../model/user.dart';

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

  void cadastro(BuildContext context) {
    Navigator.of(context).popAndPushNamed("/cadastro");
  }

  void login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (formKey.currentState!.validate()) {
        var response = userLogin(email, senha);
        if (await response) {
          Navigator.of(context).popAndPushNamed('/feed');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        //padding: const EdgeInsets.all(16.0),
        key: formKey,
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.login,
                  size: 100,
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextFormField(
                    maxLines: 1,
                    maxLength: 100,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.people_alt_rounded),
                        labelText: "E-mail",
                        hintText: "E-mail",
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
                ),
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: "Senha",
                      hintText: "Senha",
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
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
                      onTap: () => cadastro(context),
                      child: const Text(
                        "Esqueceu a senha.",
                        style: TextStyle(color: Colors.black87),
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
                      onTap: () => cadastro(context),
                      child: const Text(
                        "Não tem conta? ",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => cadastro(context),
                      child: const Text(
                        "Crie Agora.",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
