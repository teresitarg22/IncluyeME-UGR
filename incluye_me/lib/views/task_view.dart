import 'package:flutter/material.dart';
import 'package:incluye_me/views/task_list.dart';
import '../model/estudiante.dart';
import '../model/user.dart';
import './user_list.dart';
import '../controllers/task_controller.dart';
import 'mostrar_usuario.dart';

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
        backgroundColor: const Color(0xFF29DA81),
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
                      color: Color.fromARGB(255, 77, 131, 105),
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF29DA81),
        currentIndex: 0,
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UserListPage(
                userName: widget.userName,
                userSurname: widget.userSurname,
              );
            }));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TaskListPage(
                userName: widget.userName,
                userSurname: widget.userSurname,
              );
            }));
          } else if (index == 2) {
            // Lógica para la pestaña "Gráficos"
          } else if (index == 3) {
            // Lógica para la pestaña "Chat"
          } else if (index == 4) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UserDetailsPage(
                nombre: widget.userName,
                apellidos: widget.userSurname,
                esEstudiante: false,
                userName: widget.userName,
                userSurname: widget.userSurname,
              );
            }));
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF29DA81),
            icon: Icon(Icons.people, color: Colors.white),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: Colors.white),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: Colors.white),
            label: 'Gráficos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.white),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
