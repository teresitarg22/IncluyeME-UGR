import 'package:flutter/material.dart';
import 'registro_alumno.dart';
import 'registro_personal.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selección de Rol'),
        backgroundColor: Color.fromARGB(255, 41, 218, 129),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlumnoRegistration(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF29DA81),
                  minimumSize: Size(
                      double.infinity, 100), // Ajusta la altura como desees
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school), // Icono de estudiante
                    SizedBox(width: 8), // Espacio entre el icono y el texto
                    Text(
                      'Alumno',
                      style: TextStyle(fontSize: 24),
                    ), // Texto del botón
                  ],
                ),
              ),
            ),
            SizedBox(width: 20), // Espacio entre los botones
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfesorRegistration(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF29DA81),
                  minimumSize: Size(
                      double.infinity, 100), // Ajusta la altura como desees
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.work), // Icono de estudiante
                    SizedBox(width: 8), // Espacio entre el icono y el texto
                    Text(
                      'Personal',
                      style: TextStyle(fontSize: 24),
                    ), // Texto del botón
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
