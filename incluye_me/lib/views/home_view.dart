import 'package:flutter/material.dart';
import 'package:incluye_me/views/material/material_task.dart';
import 'package:incluye_me/views/register/student_register.dart';
import 'package:incluye_me/views/register/staff_register.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selección de Rol'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AlumnoRegistration()));
              },
              child: const Text('Estudiante'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfesorRegistration()));
              },
              child: const Text('Personal'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('LogIn'),
            ),
          ],
        ),
      ),
    );
  }
}
