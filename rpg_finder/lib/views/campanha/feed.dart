import 'dart:html';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rpg_finder/controllers/navigationController.dart';

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
      appBar: AppBar(
        title: TextField(
          controller: pesquisa,
          decoration: const InputDecoration(
            hintText: 'Encontre seu RPG aqui',
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore
              .collection('campanha')
              //.where('finished', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            var campanhas = snapshot.data!.docs;
            return ListView(
              children: campanhas
                  .map(
                    (campanha) => (GestureDetector(
                      onTap: () {},
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
                                          ),
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
                                          style: TextStyle(fontSize: 15),
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
                              style: const TextStyle(fontSize: 30),
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
        onPressed: () => createCampanha(context),
        child: const Icon(Icons.add),
      ),
      //
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
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
                      color: Colors.black54,
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
