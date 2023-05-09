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
          Column(children: [
            SizedBox(
              height: 10,
            ),
            Text(
              auth.currentUser!.displayName.toString(),
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => navigationConvites(context),
              child: Text('Convites'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => navigationAtivas(context),
              child: Text('Minhas campanhas'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => navigationParticipando(context),
              child: Text('Estou participando'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                auth.signOut();
                Navigator.of(context).popAndPushNamed('/login');
              },
              child: Text('Sair'),
            ),
          ]),
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
