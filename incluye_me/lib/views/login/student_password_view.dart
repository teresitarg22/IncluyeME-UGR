import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:incluye_me/globals/globals.dart';
import 'package:incluye_me/views/login/student_login_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../model/student.dart';
import '../student/student_tasks.dart';

class LoginWithSymbols extends StatefulWidget {

  // Variable estudiante
  Estudiante student;

  // Constructor
  LoginWithSymbols({Key? key, required this.student}) : super(key: key);

  @override
  _LoginWithSymbolsState createState() => _LoginWithSymbolsState(student: student);
}

// -----------------------------------------------------------------------------------

class _LoginWithSymbolsState extends State<LoginWithSymbols> {
  // Variable estudiante
  Estudiante student;
  late List<int> studentPassword;

  // Constructor
  _LoginWithSymbolsState({required this.student}) {
    student = this.student;
    studentPassword= student.getPasswordAsList();
  }

  List<int> selectedSymbols = []; // Guarda los indices de los símbolos seleccionados
  final List<String> symbols =
      List.generate(9, (index) => 'assets/symbol$index.png');

  // Combinación correcta de símbolos


  // ------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona 3 símbolos'),
      ),
      body: ResponsiveBuilder(builder: (context, sizingInformation) {
        return Column(
          children: [
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 40.0,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: sizingInformation.isMobile ? 3 : 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: sizingInformation.isMobile ? 1.0 : 3.1,
                ),
                itemCount: symbols.length,
                itemBuilder: (context, index) {
                  // ------------------------------------------------------------------------------------
                  // Procedo a poner etiquetas a cada símbolo de la contraseña.
                  // Lo hacemos para que se lea correctamente con herramientas como VoiceOver / Talkback
                  // ignore: unused_local_variable
                  String label;
                  switch (index) {
                    case 0:
                      label = 'Balón';
                      break;
                    case 1:
                      label = 'Casa';
                      break;
                    case 2:
                      label = 'Teléfono';
                      break;
                    case 3:
                      label = 'Silla';
                      break;
                    case 4:
                      label = 'Reloj';
                      break;
                    case 5:
                      label = 'Raqueta';
                      break;
                    case 6:
                      label = 'Oso';
                      break;
                    case 7:
                      label = 'Hamburguesa';
                      break;
                    case 8:
                      label = 'Martillo';
                      break;
                    default:
                      label = 'Símbolo desconocido';
                  }

                  // ------------------------------------------------------------------------------------
                  return Semantics(
                    label: 'Descripción del símbolo $index',
                    child: InkWell(
                      onTap: () {
                        if (selectedSymbols.length < 3) {
                          setState(() {
                            selectedSymbols.add(index + 1);
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Image.asset(symbols[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
            // ---------------------------------------------------------------
            Container(
              height: 1.5,
              color: Colors.blue, // Línea azul de separación.
            ),
            // ----------------------------
            const SizedBox(height: 15),
            // ----------------------------
            Container(
              padding: const EdgeInsets.only(bottom: 16.0),
              height: 250,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) {
                      if (index < selectedSymbols.length) {
                        return Image.asset(
                          symbols[selectedSymbols[index]],
                          height: 80,
                          width: 80,
                        );
                      } else {
                        return const Icon(Icons.remove,
                            size: 50, color: Colors.red);
                      }
                    }),
                  ),
                  // ----------------------------
                  const SizedBox(height: 15),
                  // ----------------------------
                  Container(
                    height: 1.5,
                    color: Colors.blue, // Línea azul de separación.
                  ),
                  // ----------------------------
                  const SizedBox(height: 40),
                  // ----------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ----------------------------------------
                      // Botón para aceptar la acción
                      ElevatedButton(
                        onPressed: () {
                          if (selectedSymbols.length == 3 &&
                              selectedSymbols[0] == studentPassword[0] &&
                              selectedSymbols[1] == studentPassword[1] &&
                              selectedSymbols[2] == studentPassword[2]) {
                            _showSuccessDialog();
                            student_global = student;
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pop(context);
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return StudentTasks(
                                    userName: student.nombre,
                                    userSurname: student.apellidos,
                                  );
                                }));
                              });
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title:
                                    const Text('Inicio de sesión incorrecto'),
                                content:
                                    const Text('Por favor, intenta de nuevo.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Aceptar'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 105, 187, 255),
                          padding: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: SizedBox(
                          width: 70,
                          child: Image.asset(
                            'assets/sí.png',
                            semanticLabel: 'Aceptar',
                          ),
                        ),
                      ),
                      // -------------------------------------------------
                      const SizedBox(width: 70),
                      // ----------------------------------------
                      // Botón para denegar la acción
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedSymbols.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 105, 187, 255),
                          padding: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: SizedBox(
                          width: 70,
                          child: Image.asset(
                            'assets/no.png',
                            semanticLabel: 'Borrar selección',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // ------------------------------------------------------------------------

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // El usuario debe tocar el botón para cerrar el diálogo.
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Inicio de sesión'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Redirigiendo...'),
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}
