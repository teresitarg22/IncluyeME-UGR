import 'package:flutter/material.dart';
import 'package:incluye_me/controllers/task_controller.dart';
import 'package:incluye_me/model/general_task.dart';

class TareaGeneralView extends StatelessWidget {
  final int taskId;
  final TaskController controller = TaskController();
  Tarea tarea = Tarea(titulo: '', indicesPasos: [], propietario: '');

  TareaGeneralView({Key? key, required this.taskId}) : super(key: key);

  // Funcion para oberner la tarea general
  Future<Tarea> getTareaGeneral() async {
    tarea = (await controller.getTareaGeneral(taskId)) as Tarea;
    return tarea;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarea por pasos"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "Nombre de la tarea: ${tarea.titulo}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
