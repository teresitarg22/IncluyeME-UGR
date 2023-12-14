import 'package:flutter/material.dart';
import 'package:incluye_me/views/task_asign.dart';
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
        '/': (context) => ClaseDropdown(taskID: 88),
      },
    );
  }
}

class ClaseList extends StatelessWidget {
  final List<String> classList;
  final Function(String) onClassSelected;

  ClaseList({required this.classList, required this.onClassSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Selecciona una Clase:',
          style: TextStyle(fontSize: 25),
        ),
        SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          itemCount: classList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  onClassSelected(classList[index]);
                },
                child: Text(
                  classList[index],
                  style: TextStyle(fontSize: 26),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ClaseDropdown extends StatefulWidget {
  final int taskID;

  const ClaseDropdown({super.key, required this.taskID});

  @override
  _ClaseDropdownState createState() => _ClaseDropdownState();
}

class _ClaseDropdownState extends State<ClaseDropdown> {
  String? _selectedClase;
  RegistroController controlador = RegistroController();
  List<String> _classList = [];
  Map<String, Map<String, Map<String, int>>> amount = {};
  Map<String, int> menus = {};

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
              backgroundColor: Colors.blue,
            ),
            body: Stack(
              children: [
                Center(
                  child: _classList.isEmpty
                      ? Text('No hay clases disponibles')
                      : ClaseList(
                          classList: _classList, 
                          onClassSelected: (selectedClase) {
                            setState(() {
                              _selectedClase = selectedClase;
                              
                              if (_selectedClase == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(
                                        hours: 24), // Duración indefinida
                                    content: Text(
                                      'Es necesario seleccionar una clase',
                                      textAlign: TextAlign.center,
                                      // Centra el texto
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize:
                                              30), // Aumenta el tamaño del texto
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar(); // Oculta el SnackBar cuando se selecciona una clase
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return TaskCommand(
                                    clase: _selectedClase,
                                  );
                                })).then((result) {
                                  // result es el dato que pasaste de vuelta desde TaskCommand
                                  if (result != null) {
                                    if (result['clase'] != null) {
                                      setState(() {
                                        Map<String, int> amount_aux =
                                            result['menu'];
                                        Map<String, Map<String, int>>
                                            amount_aux2 = {};
                                        for (var key in amount_aux.keys) {
                                          amount_aux2[key] =
                                              result['specialOptions'];
                                          menus[result['clase']] =
                                              amount_aux[key]!;
                                        }

                                        amount[result['clase']] = amount_aux2;

                                        _classList.remove(result['clase']);
                                        _selectedClase = _classList.isNotEmpty
                                            ? _classList[0]
                                            : null;

                                        if (_classList.isEmpty) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return SummaryPage(
                                              amount: amount,
                                              menus: menus,
                                              taskID: widget.taskID,
                                            );
                                          }));
                                        }
                                      });
                                    } else if (result['devolver'] != null) {
                                      setState(() {
                                        if (!_classList
                                            .contains(result['devolver'])) {
                                          _classList.add(result['devolver']);
                                        }
                                        _selectedClase = _classList.isNotEmpty
                                            ? _classList[0]
                                            : null;
                                      });
                                    }
                                  }
                                });
                              }
                            });
                          },
                        ),
                ),
                Positioned(
                  left: 0,
                  top: MediaQuery.of(context).size.height / 1.5,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 50.0,
                    onPressed: () {
                      // Resto del código al presionar el botón izquierdo
                      if (amount.isNotEmpty) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TaskCommand(
                              clase: amount.keys.last,
                              menus: menus,
                              specialOptions: amount[amount.keys.last]![
                                  amount[amount.keys.last]!.keys.last]!);
                        })).then((result) {
                          // result es el dato que pasaste de vuelta desde TaskCommand
                          amount.remove(amount.keys.last);
                          if (result != null) {
                            if (result['clase'] != null) {
                              setState(() {
                                Map<String, int> amount_aux = result['menu'];
                                Map<String, Map<String, int>> amount_aux2 = {};
                                for (var key in amount_aux.keys) {
                                  amount_aux2[key] = result['specialOptions'];
                                  menus[result['clase']] = amount_aux[key]!;
                                }

                                amount[result['clase']] = amount_aux2;

                                _classList.remove(result['clase']);
                                _selectedClase = _classList.isNotEmpty
                                    ? _classList[0]
                                    : null;

                                if (_classList.isEmpty) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SummaryPage(
                                      amount: amount,
                                      menus: menus,
                                      taskID: widget.taskID,
                                    );
                                  }));
                                }
                              });
                            } else if (result['devolver'] != null) {
                              setState(() {
                                if (!_classList.contains(result['devolver'])) {
                                  _classList.add(result['devolver']);
                                }
                                _selectedClase = _classList.isNotEmpty
                                    ? _classList[0]
                                    : null;
                              });
                            }
                          }
                        });
                      }
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
