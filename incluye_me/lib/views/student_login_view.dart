import 'package:flutter/material.dart';
import 'package:incluye_me/views/student_password_view.dart';
// import '../controllers/usuario_controller.dart';
// import 'dart:typed_data';

// -------------------------------------------------------------------

class StudentLoginView extends StatefulWidget {
  const StudentLoginView({Key? key}) : super(key: key);

  @override
  _StudentLoginViewState createState() => _StudentLoginViewState();
}

class _StudentLoginViewState extends State<StudentLoginView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudiantes')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (BuildContext context, int pageIndex) {
                return GridView.builder(
                  padding: const EdgeInsets.all(60.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 32.0,
                    crossAxisSpacing: 32.0,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginWithSymbols(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(width: 1.0),
                      ),
                      child: Image.asset('assets/usuario_sin_foto.png'),
                    );
                  },
                  itemCount: 6, // Vamos a mostrar 6 alumnos por página.
                );
              },
            ),
          ),
          // -------------------------------------------------------
          Padding(
            padding:
                const EdgeInsets.only(bottom: 50.0, left: 80.0, right: 80.0),
            child: Row(
              children: [
                // ----------------------------------
                // Desplazarse a la página anterior (solo habilitar si no estás en la primera página).
                if (_pageController.hasClients && _pageController.page != 0)
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
                // ----------------------------------
                // Desplazarse a la página siguiente.
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
      ),
    );
  }
}


// class StudentLoginView extends StatefulWidget {
//   const StudentLoginView({Key? key}) : super(key: key);

//   @override
//   _StudentLoginViewState createState() => _StudentLoginViewState();
// }

// // -------------------------------------------------------------------

// class _StudentLoginViewState extends State<StudentLoginView> {
//   late PageController _pageController;
//   final Controller controlador = Controller();
//   var estudiantes = [];

//   // ----------------------------------------------
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: 0);
//   }

//   // ----------------------------------------------
//   Future<void> initEstudiantes() async {
//     estudiantes = await controlador.listaEstudiantes();
//   }

//   // ----------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Estudiantes')),
//       body: Column(
//         children: [
//           Expanded(
//             child: PageView.builder(
//               controller: _pageController,
//               scrollDirection: Axis.horizontal,
//               itemCount: 6,
//               itemBuilder: (BuildContext context, int pageIndex) {
//                 return GridView.builder(
//                   padding: const EdgeInsets.all(60.0),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 32.0,
//                     crossAxisSpacing: 32.0,
//                     childAspectRatio: 1.0,
//                   ),
//                   itemBuilder: (BuildContext context, int index) {
//                     // ---------------------------------------------------------------------
//                     // Verifica si hay estudiantes suficientes antes de acceder al índice
//                     if (index < estudiantes.length) {
//                       var estudiante = estudiantes[index];
//                       var foto = estudiante['foto'] as Uint8List? ??
//                           Uint8List.fromList([]);
//                       var nombre =
//                           '${estudiante['nombre']} ${estudiante['apellidos']}';
//                       return ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const LoginWithSymbols(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           side: const BorderSide(width: 1.0),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.memory(Uint8List.fromList(foto)),
//                             const SizedBox(height: 8.0),
//                             Text(nombre),
//                           ],
//                         ),
//                       );
//                     }
//                   },
//                   itemCount: 6, // Vamos a mostrar 6 alumnos por página.
//                 );
//               },
//             ),
//           ),
//           // -------------------------------------------------------
//           Padding(
//             padding:
//                 const EdgeInsets.only(bottom: 50.0, left: 80.0, right: 80.0),
//             child: Row(
//               children: [
//                 // ----------------------------------
//                 // Desplazarse a la página anterior (solo habilitar si no estás en la primera página).
//                 if (_pageController.hasClients && _pageController.page != 0)
//                   Expanded(
//                     child: Align(
//                       alignment: Alignment.bottomLeft,
//                       child: IconButton(
//                         onPressed: () {
//                           _pageController.previousPage(
//                             duration: const Duration(milliseconds: 500),
//                             curve: Curves.ease,
//                           );
//                         },
//                         icon: const Icon(Icons.arrow_back),
//                       ),
//                     ),
//                   ),
//                 // ----------------------------------
//                 // Desplazarse a la página siguiente.
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: IconButton(
//                       onPressed: () {
//                         _pageController.nextPage(
//                           duration: const Duration(milliseconds: 500),
//                           curve: Curves.ease,
//                         );
//                       },
//                       icon: const Icon(Icons.arrow_forward),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
