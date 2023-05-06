import 'package:flutter/material.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
import 'package:rpg_finder/controllers/userController.dart';

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
      body: Column(children: [
        ElevatedButton(
          onPressed: () => navigationConvites(context),
          child: Text('Convites'),
        ),
        ElevatedButton(
          onPressed: () => navigationAtivas(context),
          child: Text('Campanhas ativas'),
        ),
        ElevatedButton(
          onPressed: () {
            auth.signOut();
            Navigator.of(context).popAndPushNamed('/login');
          },
          child: Text('Sair'),
        )
      ]),

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
