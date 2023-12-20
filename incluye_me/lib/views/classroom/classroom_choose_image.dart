import 'package:flutter/material.dart';
import 'package:incluye_me/globals/globals.dart';
import 'package:incluye_me/model/aula.dart';
import 'package:incluye_me/views/command/command_task_image.dart';
import '../../controllers/user_controller.dart';
import '../command/sumary_page_image.dart';

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
        '/': (context) => const ClaseDropdownImage(taskID: 88),
      },
    );
  }
}

class ClaseDropdownImage extends StatefulWidget {
  final int taskID;

  const ClaseDropdownImage({super.key, required this.taskID});

  @override
  _ClaseDropdownImageState createState() => _ClaseDropdownImageState();
}

class _ClaseDropdownImageState extends State<ClaseDropdownImage> {
  String? _selectedClase;
  final Controller controlador = Controller();
  Map<String, Map<String, int>> amount = {};

  final PageController _pageController =
      PageController(); // Controlador de la página
  int _currentPageIndex = 0; // Índice de la página actual

  @override
  void initState() {
    super.initState();
    aulaList = [];
    loadClass();
  }

  Future<void> loadClass() async {
    var contenido = await dbDriver.request(
        "SELECT nombre_aula, foto FROM imparte_en, personal where imparte_en.nombre_personal = personal.nombre and imparte_en.apellidos_personal = personal.apellidos");
    //var contenido = await dbDriver.request("Select * from personal");
    aulaList = Aula.fromJsonList(contenido);
    setState(() {}); // Actualizar el estado después de cargar las aulas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selecciona una Clase',
          style: TextStyle(fontSize: 28),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TaskCommandImage(clase: amount.keys.last);
            })).then((result) {
              amount.remove(amount.keys.last);
              if (result != null && result['clase'] != null) {
                setState(() {
                  Map<String, int> amountAux = result['menu'];
                  amount[result['clase']] = amountAux;
                  aulaList!
                      .removeWhere((aula) => aula.nombre == result['clase']);
                  _selectedClase =
                      aulaList!.isNotEmpty ? aulaList![0].toString() : null;

                  if (aulaList!.isEmpty) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SummaryPageImage(
                        amount: amount,
                        taskID: widget.taskID,
                      );
                    }));
                  }
                });
              } else if (result['devolver'] != null) {
                setState(() {
                  aulaList!.add(result['devolver']);
                  _selectedClase =
                      aulaList!.isNotEmpty ? aulaList![0].toString() : null;
                });
              }
            });
          },
        ),
      ),
      body: aulaList!.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: aulaList!.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                        _selectedClase =
                            aulaList![index].toString(); // Move this line here
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      _selectedClase = aulaList![index].toString();
                      Aula aula = aulaList![index];

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
                                    Map<String, int> amountAux = result['menu'];
                                    amount[result['clase']] = amountAux;

                                    aulaList!.removeWhere((aula) =>
                                        aula.nombre == result['clase']);
                                    _selectedClase = aulaList!.isNotEmpty
                                        ? aulaList![0].toString()
                                        : null;

                                    if (aulaList!.isEmpty) {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return SummaryPageImage(
                                          amount: amount,
                                          taskID: widget.taskID,
                                        );
                                      }));
                                    } else {
                                      _pageController.animateToPage(
                                        index - 1 >= 0 ? index - 1 : 0,
                                        duration:
                                            const Duration(milliseconds: 500),
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Image.memory(aula.foto, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 8),
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
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        if (_currentPageIndex > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        if (_currentPageIndex < aulaList!.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
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
