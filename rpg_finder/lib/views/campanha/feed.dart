import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
import '../../controllers/campanhaController.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController pesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /////////////

/////////////////////
    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 32, 33, 1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 169, 12, 255),
        title: TextField(
          controller: pesquisa,
          decoration: const InputDecoration(
            hintText: 'Encontre seu RPG aqui',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => procurar(pesquisa.text, context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore
              .collection('campanha')
              .where('disable', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var campanhas = snapshot.data!.docs;
            return ListView(
              children: campanhas
                  .map(
                    (campanha) => (GestureDetector(
                      onTap: () => detalhesCampanha(
                          context, campanhas, campanhas.indexOf(campanha)),
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: AlignmentDirectional.centerStart,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Wrap(
                                      children: [
                                        Text(
                                          campanha['nome'],
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  174, 255, 255, 255)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    child: Wrap(
                                      children: <Text>[
                                        Text(
                                          campanha['descricao'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                174, 255, 255, 255),
                                          ),
                                          maxLines: 3,
                                        ),
                                        Text(
                                          " ...",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.people),
                            Text(
                              campanha['players'].toString(),
                              style: const TextStyle(
                                  fontSize: 30, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )),
                  )
                  .toList(),
            );
          }),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 169, 12, 255),
        onPressed: () => createCampanha(context),
        child: const Icon(Icons.add),
      ),

      //
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
                    onPressed: () => null,
                    icon: const Icon(
                      Icons.home,
                      color: Colors.white,
                    )),
                const SizedBox(width: 80),
                IconButton(
                    onPressed: () => user(context),
                    icon: const Icon(Icons.people))
              ],
            ),
          ),
        ),
        //Legado
        /*
        backgroundColor: Colors.blue,
        currentIndex: 0,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          /*BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: "Pesquisa"),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Adicionar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Usuário',
          ),
        ],
        onTap: (pagina) {},
      */
      ),
    );
  }
}