import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rpg_finder/controllers/campanhaController.dart';
import 'package:rpg_finder/controllers/navigationController.dart';

class Convites extends StatefulWidget {
  @override
  State<Convites> createState() => _Convites();
}

class _Convites extends State<Convites> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Icon(
            Icons.mail,
          ),
        ),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore
            .collection('invites')
            .where('destinatario', isEqualTo: auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var convites = snapshot.data!.docs;
          return ListView(
            children: convites
                .map((convite) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 250,
                          
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Column(
                              children: [
                                Text(
                                  convite['nome-campanha'].toString(),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Text(
                                  'User: ' + convite['nome-user'].toString(),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            padding: EdgeInsets.all(10),
                            width: 50,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: Icon(
                                      Icons.check,
                                      color: Color.fromARGB(255, 169, 12, 255),
                                    ),
                                    onTap: () => aceitarConvite(convite.id),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Color.fromARGB(255, 169, 12, 255),
                                    ),
                                    onTap: () => negarConvite(convite.id),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ))
                .toList(),
          );
        },
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
