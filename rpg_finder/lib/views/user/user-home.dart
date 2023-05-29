import 'package:flutter/material.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
import 'package:rpg_finder/controllers/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  List corIcone = [255, 255, 255, 255]; //[255, 169, 12, 255];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 32, 33, 1),
      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: Color.fromARGB(255, 169, 12, 255),
      ),
      body: Column(
        children: [
          //imagem vou colocar uma imagem aleatoria no a seats para tentar ajustar
          // o tamanho da imagem

          Container(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(14, 20, 7, 7),
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    backgroundColor: Colors.purple.shade800,
                    backgroundImage: const AssetImage('images/dinossauro.jpg'),
                    /*child: IconButton(
                        onPressed: () {
                          ///
                        },
                        icon: Icon(Icons.camera_alt),
                      )*/
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    auth.currentUser!.displayName.toString().toLowerCase(),
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: const Color.fromARGB(40, 0, 0, 0),
          ),
          GestureDetector(
            onTap: () => navigationConvites(context),
            child: Container(
              padding: EdgeInsets.fromLTRB(35, 20, 2, 7),
              alignment: AlignmentDirectional.bottomStart,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                    child: Icon(
                      Icons.messenger_sharp,
                      color: Color.fromARGB(
                          corIcone[0], corIcone[1], corIcone[2], corIcone[3]),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Convites",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Aqui mostra quem enviou convite para \nacessar a sua campanha",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          /*Aquie é a onde vai ficar todas as opções do usuario */
          GestureDetector(
            onTap: () => navigationAtivas(context),
            child: Container(
              padding: EdgeInsets.fromLTRB(35, 20, 2, 7),
              alignment: AlignmentDirectional.bottomStart,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                    child: Icon(
                      Icons.history_edu,
                      color: Color.fromARGB(
                          corIcone[0], corIcone[1], corIcone[2], corIcone[3]),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Minhas campanhas",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Aqui mostra as campanhas que você criou",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => navigationParticipando(context),
            child: Container(
              padding: EdgeInsets.fromLTRB(35, 20, 2, 7),
              alignment: AlignmentDirectional.bottomStart,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                    child: Icon(
                      Icons.campaign,
                      color: Color.fromARGB(
                          corIcone[0], corIcone[1], corIcone[2], corIcone[3]),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Estou participando",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Aqui mostrara a campanhas que você \nestá participando",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => null,
            child: Container(
              padding: EdgeInsets.fromLTRB(35, 20, 2, 7),
              alignment: AlignmentDirectional.bottomStart,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                    child: Icon(
                      Icons.update_sharp,
                      color: Color.fromARGB(
                          corIcone[0], corIcone[1], corIcone[2], corIcone[3]),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Atualizar o seus Dados",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Aqui você pode alterar o seu nome e foto",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).popAndPushNamed('/historico'),
            child: Container(
              padding: EdgeInsets.fromLTRB(35, 20, 2, 7),
              alignment: AlignmentDirectional.bottomStart,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                    child: Icon(
                      Icons.collections_bookmark,
                      color: Color.fromARGB(
                          corIcone[0], corIcone[1], corIcone[2], corIcone[3]),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Histórico",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Aqui você pode ver a campanhas que\n você já participou",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              auth.signOut();
              Navigator.of(context).popAndPushNamed('/login');
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(35, 20, 2, 7),
              alignment: AlignmentDirectional.bottomStart,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                    child: Icon(
                      Icons.exit_to_app,
                      color: Color.fromARGB(
                          corIcone[0], corIcone[1], corIcone[2], corIcone[3]),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sair",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Sair da sua conta?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 169, 12, 255),
        onPressed: () => createCampanha(context),
        child: const Icon(
          Icons.add,
          color: Colors.black54,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Color.fromARGB(255, 169, 12, 255),
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  color: Colors.black54,
                  onPressed: () => feed(context),
                  icon: const Icon(
                    Icons.home,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 80),
                IconButton(
                  onPressed: () => null,
                  icon: const Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
