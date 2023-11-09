import 'package:flutter/material.dart';
import 'package:incluye_me/model/pruebas_database.dart';
import 'package:incluye_me/views/user_list.dart';

class TeacherLoginView extends StatefulWidget {
  const TeacherLoginView({super.key});

  @override
  _TeacherLoginViewState createState() => _TeacherLoginViewState();
}

class _TeacherLoginViewState extends State<TeacherLoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  String? _passwordErrorMessage;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(_clearEmailError);
    _passwordController.addListener(_clearPasswordError);
  }

  @override
  void dispose() {
    _emailController.removeListener(_clearEmailError);
    _passwordController.removeListener(_clearPasswordError);

    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _clearEmailError() {
    if (_emailController.text.isNotEmpty && _errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  void _clearPasswordError() {
    if (_passwordController.text.isNotEmpty && _passwordErrorMessage != null) {
      setState(() {
        _passwordErrorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Profesores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Inicio de sesión',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: const OutlineInputBorder(),
                errorText: _passwordErrorMessage,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _handleLogin();
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Acción para recuperar contraseña
              },
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ],
        ),
      ),
    );
  }

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

    var nombre;
    var apellido;
    DataBaseDriver().connect().requestDataFromPersonal(email).then((value) {
      nombre = value[0]['personal']?['nombre'];
      apellido = value[0]['personal']?['apellidos'];
    });

    DataBaseDriver().connect().verifyPassword(email, password).then((value) => {
          if (value == true)
            {
              _showSuccessDialog(),
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pop(context);
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return UserListPage(
                      userName: nombre,
                      userSurname: apellido,
                    );
                  }));
                });
              })
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
