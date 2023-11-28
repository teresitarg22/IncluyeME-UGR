import 'package:flutter/material.dart';
import '../model/user.dart';
import '../controllers/task_controller.dart';
import '../components/bottom_navigation_bar.dart';

// ----------------------------------------------------------

class TaskDetailsPage extends StatefulWidget {
  final int taskID;
  final String tipo;
  final String userName;
  final String userSurname;

  const TaskDetailsPage(
      {super.key,
      required this.taskID,
      required this.userName,
      required this.tipo,
      required this.userSurname});
  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

// -----------------------------------------------------------------------

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final Controller controlador = Controller();
  bool asignada = false;
  var tarea_asignada;
  var tarea;
  User? user;

  @override
  void initState() {
    super.initState();
    _getTarea();
    initializeData();
  }

  void initializeData() async {
    asignada = await controlador.esTareaAsignada(widget.taskID);
    tarea_asignada = await controlador.getTareaAsignada(widget.taskID);
  }

  Future<void> _getTarea() async {
    if (widget.tipo == "general") {
      tarea = await controlador.getTareaGeneral(widget.taskID);
    } else if (widget.tipo == "material") {
      tarea = await controlador.getTareaMaterial(widget.taskID);
    } else if (widget.tipo == "comanda") {
      tarea = await controlador.getTareaComanda(widget.taskID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Tarea'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          margin: const EdgeInsets.all(5.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text(
                    tarea[0][widget.tipo]['nombre'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Nombre:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tarea[0][widget.tipo]['nombre'],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // -----------------------------
                        Row(
                          children: [
                            const Text(
                              'Asignada:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              asignada ? 'Sí' : 'No',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // -----------------------------
                        Row(
                          children: [
                            Text(
                              asignada ? 'Asignada a:' : '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${tarea_asignada[0]['asignada']['nombre']} ${tarea_asignada[0]['asignada']['apellidos']}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // -----------------------------
                        Row(
                          children: [
                            Text(
                              asignada ? 'Completada:' : '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tarea[0][widget.tipo]['completada'] ? 'Sí' : 'No',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // -----------------------------
                        //if(widget.tipo == "comanda")
                        //if(widget.tipo == "general")
                        //if(widget.tipo == "material")
                      ],
                    ),
                  ]),
                ),
              ]),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
          userName: widget.userName, userSurname: widget.userSurname),
    );
  }
}
