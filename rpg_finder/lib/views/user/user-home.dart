import 'package:flutter/material.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
import 'package:rpg_finder/controllers/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key});
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  void initState() {
    super.initState();
    getAvatarData();
  }

  /////////////////////////////////////
  String avatar = '';

  ///
  Future<void> getAvatarData() async {
    String userId = auth.currentUser!.uid;
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('usuario')
        .doc(userId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        avatar = docSnapshot.get('avatar');
      });
    } else {
      setState(() {
        avatar = 'images/avatar01.jpg';
      });
    }
  }

/////////////////////////////////////

  List corIcone = [255, 255, 255, 255]; //[255, 169, 12, 255];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Icon(Icons.person)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(14, 20, 7, 7),
                    width: 120,
                    height: 120,
                    child: CircleAvatar(
                      backgroundColor: Colors.purple.shade800,
                      backgroundImage: AssetImage('$avatar'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      auth.currentUser!.displayName
                          .toString(), //.toLowerCase(),
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
              onTap: () => navigationUpdateUser(context),
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
              onTap: () => popUpSairConta(context),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => createCampanha(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  color: Colors.white,
                  onPressed: () => feed(context),
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 80),
                IconButton(
                  onPressed: () => null,
                  icon: const Icon(
                    Icons.people,
                    color: Colors.black,
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
