import 'package:flutter/material.dart';

import '../globals/globals.dart';
import '../components/bottom_navigation_bar.dart';
import '../model/general_task.dart';
import '../views/add_general_task.dart';

class TaskView extends StatefulWidget {
  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  List<Tarea> tasks = []; // Lista de tareas

  void _addTask(Tarea tarea) {
    setState(() {
      tasks.add(tarea);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas'),
        backgroundColor: const Color(0xFF29DA81),
      ),
      body: tasks.isEmpty
          ? Center(
              child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No hay tareas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddTaskView(onAddTask: _addTask),
                        ),
                      );
                    },
                    child: Text('Añadir Tarea'),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF29DA81),
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
            ))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(
                      tasks[index].titulo,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: tasks[index].pasos.map((paso) {
                      return ListTile(
                        title: Text(paso.descripcion),
                        leading: paso.imagen.isNotEmpty
                            ? Image.asset(paso.imagen, width: 50, height: 50)
                            : null,
                      );
                    }).toList(),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para añadir tarea
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskView(onAddTask: _addTask),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: const Color(0xFF29DA81),
      ),
      //bottomNavigationBar: CustomNavigationBar(userName:widget.userName, userSurname:widget.userSurname),
    );
  }
}
