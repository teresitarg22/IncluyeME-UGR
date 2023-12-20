import 'package:flutter/material.dart';
import 'package:incluye_me/globals/globals.dart';
import 'package:incluye_me/views/login/student_password_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../model/student.dart';

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
    studentList = [];
    initializeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudiantes')),
      body: studentList?.length == 0 ? Center(child: CircularProgressIndicator())  : ResponsiveBuilder(
        builder: (context, sizingInformation) {
          double buttonPadding = sizingInformation.isMobile ? 5.0 : 20.0;
          double childAspectRatio = sizingInformation.isMobile ? 1.0 : 1.59;

          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: studentList!.length ~/ 6 + 1 ?? 1,
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
                      itemCount: studentList!.length - pageIndex * 6,
                      itemBuilder: (BuildContext context, int index) {
                        Estudiante estudiante = studentList![index + pageIndex * 6];
                        return ElevatedButton(
                          onPressed: () {
                            _showLoginOptions(context, estudiante);
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
    var contenido = await dbDriver.request("Select * from estudiante");
    studentList = Estudiante.fromJsonList(contenido);
    setState(() {}); // Actualiza la interfaz de usuario una vez que los datos están listos
  }



  void _showLoginOptions(BuildContext context, Estudiante estudiante) {
    if (estudiante.sabeLeer) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Elegir Método de Ingreso'),
            content: Text('Selecciona tu método de ingreso preferido.'),
            actions: <Widget>[
              TextButton(
                child: Text('Símbolos'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginWithSymbols(student: estudiante),
                    ),
                  );
                },
              ),
              TextButton(
                child: Text('Contraseña'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginWithPassword(student: estudiante),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginWithSymbols(student: estudiante),
        ),
      );
    }
  }

}
