import 'package:flutter/material.dart';
import 'package:incluye_me/views/command_task_image.dart';
import '../controllers/usuario_controller.dart';
import 'sumary_page_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
  PageController _pageController = PageController(); // Controlador de la página
  int _currentPageIndex = 0; // Índice de la página actual

  @override
  void initState() {
    super.initState();
    loadClass();
  }

  Future<void> loadClass() async {
    if (aulas.isNotEmpty) return;
    for (var _class in await controlador.listaAulas()) {
      aulas.add(_class['aula']!['nombre'].toString());
    }
    setState(() {}); // Actualizar el estado después de cargar las aulas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selecciona una Clase',
          style: TextStyle(fontSize: 28),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 218, 129),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TaskCommandImage(clase: amount.keys.last);
            })).then((result) {
              amount.remove(amount.keys.last);
              if (result != null && result['clase'] != null) {
                setState(() {
                  Map<String, int> amount_aux = result['menu'];
                  amount[result['clase']] = amount_aux;
                  aulas.remove(result['clase']);
                  _selectedClase = aulas.isNotEmpty ? aulas[0] : null;

                  if (aulas.isEmpty) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SummaryPageImage(
                        amount: amount,
                      );
                    }));
                  }
                });
              } else if (result['devolver'] != null) {
                setState(() {
                  aulas.add(result['devolver']);
                  _selectedClase = aulas.isNotEmpty ? aulas[0] : null;
                });
              }
            });
          },
        ),
      ),
      body: aulas.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: aulas.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      _selectedClase = aulas[index];

                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TaskCommandImage(
                                  clase: _selectedClase,
                                );
                              })).then((result) {
                                if (result != null && result['clase'] != null) {
                                  setState(() {
                                    Map<String, int> amount_aux =
                                        result['menu'];
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
                                    } else {
                                      _pageController.animateToPage(
                                        index - 1 >= 0 ? index - 1 : 0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
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
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        if (_currentPageIndex > 0) {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        if (_currentPageIndex < aulas.length - 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
