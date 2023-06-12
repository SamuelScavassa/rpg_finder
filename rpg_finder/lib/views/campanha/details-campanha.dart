import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../controllers/conviteController.dart';
import '../../controllers/navigationController.dart';

class DetalhesCampanha extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> campanha;

  const DetalhesCampanha({Key? key, required this.campanha}) : super(key: key);

  @override
  State<DetalhesCampanha> createState() => _DetalhesCampanha();
}

class _DetalhesCampanha extends State<DetalhesCampanha> {
  late final QueryDocumentSnapshot<Map<String, dynamic>> campanha;

  @override
  void initState() {
    super.initState();
    campanha = widget.campanha;
  }

  void enviar() {
    try {
      enviarConvite(campanha.id, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating,
            elevation: 150.0,content: Text('Erro ao enviar o convite $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(30, 32, 33, 1),
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text('Detalhes da campanha'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: Text('${campanha['nome']}',
                      style:
                          const TextStyle(fontSize: 25, color: Colors.white))),
            ),
            const SizedBox(height: 5),
            Center(
              child: Container(
                margin: EdgeInsets.all(20),
                width: deviceInfo.size.width * 0.8,
                padding: EdgeInsets.all(20),
                child: Wrap(children: [
                  Text(
                    '${campanha['descricao']}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ]),
              ),
            ),
            Container(
              height: 55,
              width: double.infinity,
              child: campanha['tags'] != null && campanha['tags'].isNotEmpty
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(12),
                      itemCount: campanha['tags'].length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 15,
                        );
                      },
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color.fromARGB(255, 169, 12, 255),
                            ),
                            padding:
                                EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
                            child: Text(
                              campanha['tags'][index].toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ));
                      },
                    )
                  : const Text("Não tem tags essa campanha",
                      style: const TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: deviceInfo.size.width * 0.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                  child: Text(
                    'Vagas disponiveis: ${campanha['players']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: GestureDetector(
                        onTap: enviar,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid)),
                            child: Text(
                              "Juntar-se",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      )),
                ),
                SizedBox(
                  height: deviceInfo.size.height * 0.2,
                )
              ],
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 169, 12, 255),
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
                    onPressed: () => null,
                    icon: const Icon(
                      Icons.home,
                      color: Colors.black,
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
