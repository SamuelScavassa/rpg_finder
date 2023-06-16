import 'package:flutter/material.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
import 'package:rpg_finder/controllers/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key});

  @override
  State<UpdateUser> createState() => _UpdateUser();
}

class _UpdateUser extends State<UpdateUser> {
  String name = auth.currentUser!.displayName.toString();
  String email = auth.currentUser!.email.toString();
  String selectedImage = 'images/avatar01.jpg';
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getAvatarData();
  }

  /////////////////////////////////////////
////////////////////////////////////////////
  Future<void> salvar(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      updateUser(name!, email!, selectedImage!, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tente outro email')),
      );
    }
  }

  //////////////////////////////////////////

  Future<void> getAvatarData() async {
    String userId = auth.currentUser!.uid;
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('usuario')
        .doc(userId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        selectedImage = docSnapshot.get('avatar');
      });
    } else {
      setState(() {
        selectedImage = 'images/avatar01.jpg';
      });
    }
  }

  void showImageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromRGBO(
              30, 32, 33, 1), // Defina a cor de fundo desejada aqui
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selecione a foto de perfil',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.maxFinite,
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImage = 'images/avatar01.jpg';
                          });
                          Navigator.pop(context);
                        },
                        child: Image.asset('images/avatar01.jpg'),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImage = 'images/avatar02.jpg';
                          });
                          Navigator.pop(context);
                        },
                        child: Image.asset('images/avatar02.jpg'),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImage = 'images/avatar03.jpg';
                          });
                          Navigator.pop(context);
                        },
                        child: Image.asset('images/avatar03.jpg'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atualizar Perfil"),
      ),
      body: SingleChildScrollView(
        ////////////////////////////
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showImageSelectionDialog();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.purple.shade800,
                    backgroundImage: AssetImage(selectedImage),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    initialValue: name,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) => name = value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo obrigatório";
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    initialValue: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) => email = value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo obrigatório";
                      }
                      if (value.contains('@') == false) {
                        return "Insira um email válido";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 169, 12, 255))),
                  onPressed: () => salvar(context),
                  child: Text('Atualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
      /////////////////////////////////
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
                  onPressed: () => user(context),
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
