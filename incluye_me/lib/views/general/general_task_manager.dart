import 'package:flutter/material.dart';

import '../../controllers/task_controller.dart';
import '../../model/general_task.dart';
import 'add_general_task.dart';

class TaskView extends StatefulWidget {
  final Controller controller;

  TaskView({Key? key, required this.controller}) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  List<Tarea> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    var tareasData = await widget.controller.listaTareasGenerales();
    List<Tarea> tareasList = [];

    for (var tareaData in tareasData) {
      Tarea tarea = Tarea.fromJson(tareaData);

      // Obtener los detalles completos de los pasos a partir de los IDs
      List<Paso> pasos = await widget.controller.obtenerDetallesPasos(tarea.indicesPasos);

      tarea.setPasos(pasos); // Ajusta la tarea con sus pasos

      tareasList.add(tarea);
    }

    setState(() {
      tasks = tareasList;
    });
  }


  void _addTask(Tarea tarea) async {
    // Aquí los pasos ya han sido insertados y tienes los IDs en tarea.indicesPasos
    await widget.controller.addTareaGeneral(tarea.indicesPasos, tarea.titulo, tarea.propietario);
    _loadTasks();
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
                              AddTaskView(onAddTask: _addTask, controller: widget.controller)
                        ),
                      );
                    },
                    child: Text('Añadir Tarea'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF29DA81),
                      foregroundColor: Colors.white,
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
                        leading: paso.imagen?.isNotEmpty == true
                            ? Image.asset(paso.imagen!, width: 50, height: 50)
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
              builder: (context) => AddTaskView(onAddTask: _addTask, controller: widget.controller)
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
