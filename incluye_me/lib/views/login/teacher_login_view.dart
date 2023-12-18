import 'package:flutter/material.dart';
import 'package:incluye_me/globals/globals.dart';
import 'package:incluye_me/model/database_driver.dart';
import 'package:incluye_me/views/user_list.dart';

import '../../model/teacher.dart';

class TeacherLoginView extends StatefulWidget {
  const TeacherLoginView({super.key});

  @override
  _TeacherLoginViewState createState() => _TeacherLoginViewState();
}

// -----------------------------------------------------------------

class _TeacherLoginViewState extends State<TeacherLoginView> {
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

  Future<void> login(email) async {
    var teacherData = await dbDriver.requestDataFromPersonal(email);
    teacher = Teacher.fromJson(teacherData[0]['personal']!); //Convierte el usuario logueado en variable global

    _showSuccessDialog();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        /*Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserListPage(
                    userName: teacher!.getName(),
                    userSurname: teacher!.getSurnames(),
                  )),
        );*/
        Navigator.pushReplacementNamed(context, '/userList', arguments: {
          'userName': teacher!.getName(),
          'userSurname': teacher!.getSurnames(),
        });
      });
    });
  }

  // --------------------------
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
                const Icon(
                  Icons.supervised_user_circle_rounded,
                  size: 150,
                  color: Colors.blue,
                ),
                // --------------------------
                const SizedBox(height: 20),
                // --------------------------
                const Text(
                  '¡Bienvenido!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                // --------------------------
                const SizedBox(height: 25),
                // --------------------------
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
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
  // -----------------------------------------------------
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

  // ----------------------------------------------
  Future<void> _handleLogin() async {
    setState(() {
      _errorMessage = null;
      _passwordErrorMessage = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    var nombre;
    var apellido;

    await dbDriver?.requestDataFromPersonal(email).then((value) {
      nombre = value[0]['personal']?['nombre'];
      apellido = value[0]['personal']?['apellidos'];
    });

    await dbDriver?.verifyPassword(email, password).then((value) => {
      if (value == true)
        {
          login(email),
        }
      else
        {
          setState(() {
            _passwordErrorMessage =
            'Contraseña incorrecta o email no registrado';
          })
        }
    });
  }
}