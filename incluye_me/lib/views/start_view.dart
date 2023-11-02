import 'package:flutter/material.dart';
import 'package:incluye_me/views/student_login_view.dart';
import 'teacher_login_view.dart';

class StartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Esta es la AppBar
        title: Text('Bienvenido a Incluye-Me 💚💚💚'), // El título que aparecerá en la barra
        backgroundColor: Colors.blue, // Color de fondo de la AppBar (opcional)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/logo.png"), height: 200, width: 200),
            SizedBox(height: 40), // Espacio adicional antes de los botones
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Aumentar el relleno
                  textStyle: TextStyle(fontSize: 20), // Aumentar el tamaño del texto
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentLoginView()),
                  );
                  // Navegar a la pantalla de reconocimiento facial
                },
                child: Text('Alumnos',
                    style: TextStyle(color: Colors.white, fontSize: 50),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Aumentar el relleno
                  textStyle: TextStyle(fontSize: 20), // Aumentar el tamaño del texto
                ),
                onPressed: () {
                  // Navegar a la pantalla de logIn para profesores
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeacherLoginView()),
                  );
                },
                child: Text('Profesores'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}