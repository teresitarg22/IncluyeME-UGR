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
        '/': (context) => const ClaseDropdownImage(),
        
      },
    );
  }
}

class ClaseDropdownImage extends StatefulWidget {
  const ClaseDropdownImage({super.key});

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
        backgroundColor:  Colors.blue, 
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

/*import 'package:flutter/material.dart';
import 'package:incluye_me/globals/globals.dart';
import 'package:incluye_me/model/aula.dart';
import 'package:incluye_me/views/login/student_password_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../model/aula.dart';

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
        '/': (context) => const teacherLoginView(),
      },
    );
  }
}

// -------------------------------------------------------------------

class teacherLoginView extends StatefulWidget {
  const teacherLoginView({Key? key}) : super(key: key);

  @override
  _StudentLoginViewState createState() => _StudentLoginViewState();
}

class _StudentLoginViewState extends State<teacherLoginView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    teacherList = [] ; 
    initializeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudiantes')),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          double buttonPadding = sizingInformation.isMobile ? 5.0 : 20.0;
          double childAspectRatio = sizingInformation.isMobile ? 1.0 : 1.59;

          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: teacherList!.length ~/ 6 + 1 ?? 1,
                  itemBuilder: (BuildContext context, int pageIndex) {
                    return GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(
                        sizingInformation.isMobile ? 40.0 : 50.0,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: sizingInformation.isMobile ? 2 : 3,
                        mainAxisSpacing:
                            sizingInformation.isMobile ? 25.0 : 25.0,
                        crossAxisSpacing:
                            sizingInformation.isMobile ? 25.0 : 25.0,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: teacherList!.length - pageIndex * 6,
                      itemBuilder: (BuildContext context, int index) {
                        TeacherTest estudiante = teacherList![index + pageIndex * 6];
                        return ElevatedButton(
                          onPressed: () {
                           
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(width: 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: buttonPadding,
                              vertical: 20,
                            ),
                          ),
                          //Image and text
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Image.memory(estudiante.foto), // La imagen del estudiante
                              Text(
                                estudiante.nombre, // Suponiendo que estudiante tiene un campo 'nombre'
                                style: TextStyle(
                                  color: Colors.white, // Color del texto
                                  fontSize: 16, // Tamaño del texto
                                  backgroundColor: Colors.black45, // Fondo del texto para mayor legibilidad
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: sizingInformation.isMobile ? 20.0 : 50.0,
                  left: sizingInformation.isMobile ? 20.0 : 80.0,
                  right: sizingInformation.isMobile ? 20.0 : 80.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> initializeList() async {
    var contenido = await dbDriver.request("Select * from personal");
    teacherList = TeacherTest.fromJsonList(contenido);
    setState(() {}); // Actualiza la interfaz de usuario una vez que los datos están listos
  }

}
*/
