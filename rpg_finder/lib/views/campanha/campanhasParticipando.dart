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
        title: const Center(
          child: Text("Campanhas que estou participando"),
        ),
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
                                    width: 350,
                                    decoration: BoxDecoration(
                                        color: Colors.black54,
                                        border: Border.all(
                                            color: Colors.black,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    padding: EdgeInsets.all(12),
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 250,
                                          child: Row(children: [
                                            Container(
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 240,
                                                    child: Wrap(children: [
                                                      Text(
                                                        sessao['campanha-name']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ]),
                                                  ),
                                                  Text(
                                                    'Mestre: ' +
                                                        sessao['mestre-name']
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                        Container(
                                          width: 50,
                                          alignment: Alignment.centerRight,
                                          child: Row(children: [
                                            Icon(
                                              Icons.people,
                                              color: Color.fromARGB(
                                                  255, 169, 12, 255),
                                            ),
                                            Text(
                                              ' ${sessao['players-name'].length}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ]),
                                        ),
                                        Container(
                                          width: 20,
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Color.fromARGB(
                                                255, 169, 12, 255),
                                          ),
                                        ),
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
