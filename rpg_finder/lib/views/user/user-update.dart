import 'package:flutter/material.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
import 'package:rpg_finder/controllers/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key});

  @override
  State<UpdateUser> createState() => _UpdateUser();
}

class _UpdateUser extends State<UpdateUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atualizar Perfil"),
      ),
      body: Column(
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
                    backgroundImage: const AssetImage('images/dinossauro.jpg'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    auth.currentUser!.displayName.toString(), //.toLowerCase(),
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: const Color.fromARGB(40, 0, 0, 0),
          ),
        ],
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
