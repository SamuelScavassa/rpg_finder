import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controllers/campanhaController.dart';
import '../../controllers/navigationController.dart';

class CampanhasParticipando extends StatefulWidget {
  const CampanhasParticipando({Key? key}) : super(key: key);

  @override
  State<CampanhasParticipando> createState() => _CampanhasParticipandoState();
}

class _CampanhasParticipandoState extends State<CampanhasParticipando> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campanhas que estou participando"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore
              .collection('sessoes')
              .where(
                'players-id',
                arrayContains: auth.currentUser!.uid.toString(),
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            var sessoes = snapshot.data!.docs;
            return ListView(
              children: sessoes
                  .map(
                    (sessao) => GestureDetector(
                      onTap: () => detalhesCampanhaPartcipando(
                          context, sessoes, sessoes.indexOf(sessao)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(children: [
                            Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          sessao['campanha-name'].toString(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Mestre: ' +
                                              sessao['mestre-name'].toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Seus companheiros:',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(3),
                                          width: 300,
                                          height:
                                              sessao['players-name'].length *
                                                  25,
                                          child: GridView.count(
                                              crossAxisCount: 2,
                                              children: List.generate(
                                                  sessao['players-name'].length,
                                                  (index) {
                                                return Text(
                                                  sessao['players-name'][index],
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                );
                                              })),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ]),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => createCampanha(context),
        child: const Icon(Icons.add),
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
                    onPressed: () => feed(context),
                    icon: const Icon(
                      Icons.home,
                      color: Colors.white,
                    )),
                const SizedBox(width: 80),
                IconButton(
                    onPressed: () =>
                        Navigator.of(context).popAndPushNamed('/user-home'),
                    icon: const Icon(
                      Icons.people,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
        //Legado
      ),
    );
  }
}
