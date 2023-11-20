import 'package:flutter/material.dart';
import 'command_task.dart';
import '../controllers/registro_controller.dart';
import 'summary_page.dart';

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
        '/': (context) => ClaseDropdown(),
        '/classroomChoose': (context) => ClaseDropdown(),
      },
    );
  }
}

class ClaseDropdown extends StatefulWidget {
  @override
  _ClaseDropdownState createState() => _ClaseDropdownState();
}

class _ClaseDropdownState extends State<ClaseDropdown> {
  String? _selectedClase;
  RegistroController controlador = RegistroController();
  List<String> _classList = [];
  Map<String, Map<String, int>> amount = {};

  Future<void> loadClass() async {
    if (_classList.isNotEmpty) return;
    for (var _class in await controlador.listaAulas()) {
      _classList.add(_class['aula']!['nombre'].toString());
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
            body: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Selecciona una Clase:',
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(height: 20),
                      DropdownButton<String>(
                        value: _selectedClase,
                        onChanged: (value) {
                          setState(() {
                            _selectedClase = value;
                          });
                        },
                        items: _classList.map((clase) {
                          return DropdownMenuItem<String>(
                            value: clase,
                            child: Container(
                              width: 300,
                              child: Text(
                                clase,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: MediaQuery.of(context).size.height / 2,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 50.0,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TaskCommand(
                          clase: _selectedClase,
                        );
                      })).then((result) {
                        // result es el dato que pasaste de vuelta desde TaskCommand
                        if (result != null) {
                          setState(() {
                            Map<String, int> amount_aux = result['menu'];

                            amount[result['clase']] = amount_aux;

                            _classList.remove(result['clase']);
                            _selectedClase =
                                _classList.isNotEmpty ? _classList[0] : null;

                            if (_classList.isEmpty) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SummaryPage(
                                  amount: amount,
                                );
                              }));
                            }
                          });
                        }
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  top: MediaQuery.of(context).size.height / 2,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 50.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
