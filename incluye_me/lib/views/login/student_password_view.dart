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
  String nombre = "";

  // Constructor
  _LoginWithSymbolsState({required this.student}) {
    student = this.student;
    studentPassword= student.getPasswordAsList();
    nombre = student.nombre;
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
                          symbols[selectedSymbols[index]-1],
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




class LoginWithPassword extends StatefulWidget {

  // Variable estudiante
  Estudiante student;

  // Constructor
  LoginWithPassword({Key? key, required this.student}) : super(key: key);

  @override
  _LoginWithPasswordState createState() => _LoginWithPasswordState(student: student);
}

// -----------------------------------------------------------------------------------

class _LoginWithPasswordState extends State<LoginWithPassword> {
  // Variable estudiante

  Estudiante student;
  late String studentPassword;
  String nombre = "";


  // Constructor
  _LoginWithPasswordState({required this.student}) {
    student = this.student;
    studentPassword= student.contrasenia;
    nombre = student.nombre;
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  String? _passwordErrorMessage;

  // --------------------------
  @override
  void initState() {
    super.initState();

    _emailController.addListener(_clearEmailError);
    _passwordController.addListener(_clearPasswordError);
    _emailController.text = student.correo;
  }

  // --------------------------
  @override
  void dispose() {
    _emailController.removeListener(_clearEmailError);
    _passwordController.removeListener(_clearPasswordError);

    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // --------------------------
  void _clearEmailError() {
    if (_emailController.text.isNotEmpty && _errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  // --------------------------
  void _clearPasswordError() {
    if (_passwordController.text.isNotEmpty && _passwordErrorMessage != null) {
      setState(() {
        _passwordErrorMessage = null;
      });
    }
  }


  // ------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;

    // Determinar el fondo según el tamaño de la pantalla.
    String fondo = screenWidth > 600
        ? 'assets/fondo_login_horizontal.png' // Fondo para pantallas más grandes (horizontal)
        : 'assets/fondo_login_vertical.png'; // Fondo para pantallas más pequeñas (vertical)

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Profesores',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(fondo),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // --------------------------
                // Icono
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.memory(
                      student.foto,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // --------------------------
                const SizedBox(height: 20),
                // --------------------------
                Text(
                  "¡Bienvenid@ $nombre!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                // --------------------------
                const SizedBox(height: 25),
                // --------------------------
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                    errorText: _errorMessage,
                  ),
                ),
                // --------------------------
                const SizedBox(height: 16),
                // --------------------------
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _passwordErrorMessage,
                  ),
                ),
                // --------------------------
                const SizedBox(height: 24),
                // --------------------------
                ElevatedButton(
                  onPressed: () {
                    _handleLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Color del botón
                  ),
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white, // Color del texto a blanco
                    ),
                  ),
                ),
                // --------------------------
                TextButton(
                  onPressed: () {
                    // Acción para recuperar contraseña
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                        fontSize: 12, color: Color.fromARGB(255, 7, 90, 158)),
                  ),
                ),
                // --------------------------
                const SizedBox(height: 500),
                // --------------------------
              ],
            ),
          ),
        ),
      ),
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

  Future<void> _handleLogin() async {
    setState(() {
      _errorMessage = null;
      _passwordErrorMessage = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    print(password);
    print(studentPassword);


    if (password == studentPassword) {
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
    }
    else {
        setState(() {
          _passwordErrorMessage =
          'Contraseña incorrecta o email no registrado';});
    }
  }



}
