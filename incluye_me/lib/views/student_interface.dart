import 'package:flutter/material.dart';

class StudentInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          margin: EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Image.asset(
                'assets/usuario_sin_foto.png',
                width: 40, // Ajusta el ancho según tus necesidades
                height: 40, // Ajusta el alto según tus necesidades
              ),
              SizedBox(width: 8.0),
              Text(
                'Nombre alumno',
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
      body: TaskList(),
    );
  }
}

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Aquí deberías obtener la lista de tareas desde la base de datos
    // y mostrarlas en un ListView, por ejemplo.
    return ListView(
      children: [
        ListTile(
          title: Text('Tarea 1'),
          // Otras propiedades de ListTile según tus necesidades
        ),
        ListTile(
          title: Text('Tarea 2'),
          // Otras propiedades de ListTile según tus necesidades
        ),
        // ... más tareas
      ],
    );
  }
}
