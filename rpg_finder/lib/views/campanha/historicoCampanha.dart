import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rpg_finder/controllers/campanhaController.dart';
import '../../controllers/navigationController.dart';

class HistoricoCampanha extends StatefulWidget {
  const HistoricoCampanha({Key? key}) : super(key: key);

  @override
  State<HistoricoCampanha> createState() => _HistoricoCampanhaState();
}

class _HistoricoCampanhaState extends State<HistoricoCampanha> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context); //////////

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore
            .collection('finalizadas')
            .where(
              'players-id',
              arrayContains: auth.currentUser!.uid,
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
                  (sessao) => (GestureDetector(
                    onTap: () => popUpHistorico(
                        context,
                        sessao['campanha-name'],
                        sessao['mestre-name'],
                        sessao['players-name']),
                    child: Container(
                      width: deviceInfo.size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          border: Border.all(
                              color: Colors.black, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: const EdgeInsets.all(20),
                      margin: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: AlignmentDirectional.centerStart,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: deviceInfo.size.width * 0.6,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        sessao['campanha-name'],
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
                                  width: deviceInfo.size.width * 0.6,
                                  child: Wrap(
                                    children: <Text>[
                                      Text(
                                        "Mestre: ${sessao['mestre-name']}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(
                                              174, 255, 255, 255),
                                        ),
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: deviceInfo.size.width * 0.15,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.people,
                                      color: Color.fromARGB(255, 169, 12, 255),
                                    ),
                                    Text(
                                      ' ' +
                                          sessao['players-id']
                                              .length
                                              .toString(),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Color.fromARGB(255, 169, 12, 255),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                )
                .toList(),
          );
        },
      ),
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
