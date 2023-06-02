import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rpg_finder/controllers/navigationController.dart';
import '../../controllers/campanhaController.dart';

class ResultadoPesquisa extends StatefulWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> campanha;
  const ResultadoPesquisa({Key? key, required this.campanha}) : super(key: key);

  @override
  State<ResultadoPesquisa> createState() => _ResultadoPesquisaState();
}

class _ResultadoPesquisaState extends State<ResultadoPesquisa> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> campanha;

  TextEditingController pesquisa = TextEditingController();
  @override
  void initState() {
    super.initState();
    campanha = widget.campanha;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //inicio da pesquisa
        title: Container(
          width: 700,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white60),
            borderRadius: BorderRadius.circular(
              70,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: pesquisa,
                  decoration: InputDecoration(
                    hintText: 'Encontre seu RPG aqui',
                    hintStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            bottomLeft: Radius.circular(70))),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                          bottomLeft: Radius.circular(70)),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => procurar(pesquisa.text, context),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: campanha,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var campanhas = snapshot.data!.docs;
            return ListView(
              children: campanhas
                  .map(
                    (campanha) => (GestureDetector(
                      onTap: () => detalhesCampanha(
                          context, campanhas, campanhas.indexOf(campanha)),
                      child: Container(
                        width: 350,
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
                                    width: 250,
                                    child: Wrap(
                                      children: [
                                        Text(
                                          campanha['nome'],
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
                                    width: 250,
                                    child: Wrap(
                                      children: <Text>[
                                        Text(
                                          campanha['descricao'],
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
                              width: 55,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        color:
                                            Color.fromARGB(255, 169, 12, 255),
                                      ),
                                      Text(
                                        ' ' + campanha['players'].toString(),
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
          }),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => createCampanha(context),
        child: const Icon(Icons.add),
      ),

      //
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
