import 'package:flutter/material.dart';
import 'registro_alumno.dart';
import 'registro_personal.dart';

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
*/

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Selección de Rol'),
          backgroundColor: Color.fromARGB(255, 41, 218, 129)),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AlumnoRegistration()));
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF29DA81),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school), // Icono de estudiante
                  SizedBox(width: 8), // Espacio entre el icono y el texto
                  Text('Alumno'), // Texto del botón
                ],
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfesorRegistration()));
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF29DA81),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work), // Icono de estudiante
                  SizedBox(width: 8), // Espacio entre el icono y el texto
                  Text('Personal'), // Texto del botón
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
