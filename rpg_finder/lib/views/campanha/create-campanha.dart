import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rpg_finder/controllers/campanhaController.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateCampanha extends StatefulWidget {
  const CreateCampanha({super.key});

  @override
  State<CreateCampanha> createState() => _CreateCampanha();
}

//////////////////////////////
class _CreateCampanha extends State<CreateCampanha> {
  late double _distanceToField;
  late TextfieldTagsController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

///////////////////////////////////////////
  void feed(BuildContext context) {
    Navigator.of(context).popAndPushNamed("/feed");
  }

  void user(BuildContext context) {
    Navigator.of(context).popAndPushNamed("/user-home");
  }

  ////////////////////////////////////////////
  /*
  void createCampanha(BuildContext context) {
    Navigator.of(context).popAndPushNamed("/create-campanha");
  }*/
/////////////////////////////////

  List<String> Tags = [];
  String name = '';
  int jogadores = 0;
  String descricao = '';
  String discord = '';
  var formKey = GlobalKey<FormState>();
/////////////////////////////////
  void save(BuildContext context) {
    Tags = _controller.getTags!.toList();
    print(Tags);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      
      
      salvarCampanha(descricao, discord, name, jogadores, _controller.getTags);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campanha criada com sucesso')),
      );
      Navigator.of(context).popAndPushNamed("/feed");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao criar campanha')),
      );
    }
  }

///////////////////////////////////

/////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x5E2C82),
      appBar: AppBar(title: const Text("Criação de campanha")),
      body: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ////////Nome da campanha
              TextFormField(
                maxLines: 1,
                maxLength: 100,
                decoration: const InputDecoration(
                  icon: Icon(Icons.create_sharp),
                  labelText: "Nome da campanha",
                  hintText: "Digite o nome da campanha",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                onChanged: (value) => name = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo Obrigatorio.";
                  }
                  return null;
                },
              ),
              ////////Descrição da campanha
              TextFormField(
                minLines: 1,
                maxLines: 5,
                maxLength: 250,
                decoration: const InputDecoration(
                  icon: Icon(Icons.description),
                  labelText: "Descrição da campanha",
                  hintText: "Descrição da campanha",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                onChanged: (value) => descricao = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo Obrigatorio.";
                  }
                  return null;
                },
              ),
              ////////////////
              ////////Link Discord
              TextFormField(
                maxLines: 1,
                maxLength: 30,
                decoration: const InputDecoration(
                  icon: Icon(Icons.discord),
                  labelText: "Link Discord",
                  hintText: "Link Discord",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                onChanged: (value) => discord = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo Obrigatorio.";
                  }
                  return null;
                },
              ),
              ////////////////
              ////////Numero players
              TextFormField(
                maxLines: 1,
                maxLength: 2,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  icon: Icon(Icons.people),
                  labelText: "Numero de jogadores",
                  hintText: "Numero de jogadores",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                onChanged: (value) => jogadores = int.parse(value),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo Obrigatorio.";
                  }
                  return null;
                },
              ),
              ////////////////
              ///////Campo de tags
              TextFieldTags(
                textfieldTagsController: _controller,
                initialTags: Tags,
                textSeparators: const [' ', ','],
                letterCase: LetterCase.normal,
                validator: (String tag) {
                  if (tag.isEmpty) {
                    return 'No, please just no';
                  } else if (_controller.getTags!.contains(tag)) {
                    return 'Tag já inserida';
                  }
                  return null;
                },
                inputfieldBuilder:
                    (context, tec, fn, error, onChanged, onSubmitted) {
                  return ((context, sc, tags, onTagDelete) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: tec,
                        focusNode: fn,
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 74, 137, 92),
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 74, 137, 92),
                              width: 3.0,
                            ),
                          ),
                          helperText: '',
                          helperStyle: const TextStyle(
                            color: Color.fromARGB(255, 74, 137, 92),
                          ),
                          labelText: "Tags",
                          hintText: _controller.hasTags
                              ? ''
                              : "Adicione Tags de busca",
                          errorText: error,
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: _distanceToField * 0.74),
                          prefixIcon: tags.isNotEmpty
                              ? SingleChildScrollView(
                                  controller: sc,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: tags.map((String tag) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Color.fromARGB(255, 74, 137, 92),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              '#$tag',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              onTagDelete(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                                )
                              : null,
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      ),
                    );
                  });
                },
              ),

              ////////////////
              ///////////////
              ElevatedButton(
                onPressed: () => save(context),
                child: const Text("Criar campanha"),
              ),
              ////////////////
            ],
          ),
        ),
      ),
      //////////////////////////////////////////////
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

////////////////////////////////
