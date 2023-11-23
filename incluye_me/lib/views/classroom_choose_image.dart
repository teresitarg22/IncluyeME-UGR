import 'package:flutter/material.dart';
import 'package:incluye_me/views/command_task_image.dart';
import '../controllers/usuario_controller.dart';
import 'sumary_page_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String user = "";
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => ClaseDropdownImage(),
        '/classroomChoose': (context) => ClaseDropdownImage(),
      },
    );
  }
}

class ClaseDropdownImage extends StatefulWidget {
  @override
  _ClaseDropdownImageState createState() => _ClaseDropdownImageState();
}

class _ClaseDropdownImageState extends State<ClaseDropdownImage> {
  String? _selectedClase;
  final Controller controlador = Controller();
  List<String> aulas = [];
  Map<String, Map<String, int>> amount = {};
  //Map<String, File> fotos = {};

  @override
  void initState() {
    super.initState();
    //buscarAulas();
  }

  Future<void> loadClass() async {
    if (aulas.isNotEmpty) return;
    for (var _class in await controlador.listaAulas()) {
      aulas.add(_class['aula']!['nombre'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadClass(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          // Si algo sale mal...
          return Center(child: Text('Ha ocurrido un error!'));
        } else {
          // Cuando los datos están listos, muestra tu widget
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Selecciona una Clase',
                style: TextStyle(fontSize: 28),
              ),
              backgroundColor: const Color.fromARGB(255, 41, 218, 129),
            ),
            body: GridView.builder(
              padding: const EdgeInsets.all(60.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 32.0,
                crossAxisSpacing: 32.0,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index >= 0 && index < aulas.length) {
                  _selectedClase = aulas[index];
                }

                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (index >= 0 && index < aulas.length) {
                          _selectedClase = aulas[index];
                        }

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TaskCommandImage(
                            clase: _selectedClase,
                          );
                        })).then((result) {
                          if (result != null) {
                            setState(() {
                              Map<String, int> amount_aux = result['menu'];
                              amount[result['clase']] = amount_aux;
                              aulas.remove(result['clase']);

                              _selectedClase =
                                  aulas.isNotEmpty ? aulas[0] : null;

                              if (aulas.isEmpty) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SummaryPageImage(
                                    amount: amount,
                                  );
                                }));
                              }
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(width: 1.0),
                      ),
                      child: Image.asset('assets/aula.png'),
                    ),
                    SizedBox(height: 8),
                    Text(_selectedClase!),
                  ],
                );
              },
              itemCount: aulas.length,
            ),
          );
        }
      },
    );
  }
}
