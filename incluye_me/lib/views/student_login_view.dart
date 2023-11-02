import 'package:flutter/material.dart';
import 'package:incluye_me/views/student_password_view.dart';

class StudentLoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumnos')
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(60.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // número de columnas
          mainAxisSpacing: 32.0, // espacio vertical entre cuadros
          crossAxisSpacing: 32.0, // espacio horizontal entre cuadros
          childAspectRatio: 1.0, // proporción para determinar el tamaño del cuadro
        ),
        itemBuilder: (BuildContext context, int index) {
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginWithSymbols()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white, // color de fondo del botón
              side: BorderSide(width: 1.0),// borde del botón
            ),
            child: Image.asset('assets/usuario_sin_foto.png'),
          );
        },
        itemCount: 12, // número de cuadros
      ),
    );
  }
}