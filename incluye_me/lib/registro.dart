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
              child: Text('Alumno'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfesorRegistration()));
              },
              child: Text('Personal'),
            ),
          ],
        ),
      ),
    );
  }
}
