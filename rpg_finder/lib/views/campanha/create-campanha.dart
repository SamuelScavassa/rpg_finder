import 'package:flutter/material.dart';

class CreateCampanha extends StatefulWidget {
  const CreateCampanha({super.key});

  @override
  State<CreateCampanha> createState() => _CreateCampanha();
}

class _CreateCampanha extends State<CreateCampanha> {
  void feed(BuildContext context) {
    Navigator.of(context).popAndPushNamed("/feed");
  }

  void user(BuildContext context) {
    Navigator.of(context).popAndPushNamed("/user-home");
  }
  /*
  void createCampanha(BuildContext context) {
    Navigator.of(context).popAndPushNamed("/create-campanha");
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criação de campanha")),
      body: Container(
        child: const Text("Crie sua campanha"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        child: const Icon(
          Icons.add,
          color: Colors.black54,
        ),
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
                    onPressed: () => user(context),
                    icon: const Icon(Icons.people))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
