import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rpg_finder/controllers/campanhaController.dart';
import '../../controllers/navigationController.dart';

class CampanhasAtivas extends StatefulWidget {
  const CampanhasAtivas({Key? key}) : super(key: key);

  @override
  State<CampanhasAtivas> createState() => _CampanhasAtivasState();
}

class _CampanhasAtivasState extends State<CampanhasAtivas> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CAMPANHAS ATIVAS')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore
            .collection('sessoes')
            .where(
              'mestre',
              isEqualTo: auth.currentUser!.uid,
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
                      onTap: () => null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    sessao['campanha-name'].toString(),
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Participantes:',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: 300,
                                    height: 200,
                                    child: ListView(
                                        children: List.generate(
                                            sessao['players-name'].length,
                                            (index) {
                                      return Center(
                                        child: Text(
                                          sessao['players-name'][index],
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      );
                                    })),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ],
                      )),
                )
                .toList(),
          );
        },
      ),
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