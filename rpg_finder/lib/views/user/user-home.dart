import 'package:flutter/material.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
import 'package:rpg_finder/controllers/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      body: Center(
          child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(
                width: 150,
                height: 150,
                child: CircleAvatar(
                    backgroundColor: Colors.brown.shade800,
                    backgroundImage: AssetImage(''),
                    child: IconButton(
                      onPressed: () {
                        ///
                      },
                      icon: Icon(Icons.camera_alt),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                auth.currentUser!.displayName.toString(),
                style: TextStyle(fontSize: 30),
              ),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => navigationConvites(context),
                child: Text('Convites'),
              ),
              const SizedBox(width: 30), // Espaçamento horizontal de 20 pixels
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => navigationAtivas(context),
                child: const Text('Minhas campanhas'),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => navigationParticipando(context),
                  child: const Text('Estou participando'),
                ),
                const SizedBox(width: 30), // Espaçame
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => null,
                  child: const Text('Atualizar Dados'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  auth.signOut();
                  Navigator.of(context).popAndPushNamed('/login');
                },
                child: const Text('Sair'),
              ),
            ],
          )
        ],
      )),

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
                    onPressed: () => feed(context),
                    icon: const Icon(Icons.home)),
                const SizedBox(width: 80),
                IconButton(
                    onPressed: () => null,
                    icon: const Icon(
                      Icons.people,
                      color: Colors.black54,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
