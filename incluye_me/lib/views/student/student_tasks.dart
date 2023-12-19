import 'package:flutter/material.dart';
import 'package:incluye_me/components/bottom_student_bar.dart';
import 'package:incluye_me/controllers/task_controller.dart';

class StudentTasks extends StatefulWidget {
  final String userName;
  final String userSurname;

  const StudentTasks({
    super.key,
    required this.userName,
    required this.userSurname,
  });

  @override
  _StudentTasksState createState() => _StudentTasksState();
}

// ----------------------------------------------------------------------------

class _StudentTasksState extends State<StudentTasks> {
  final TaskController taskController = TaskController();
  String tipo = "";
  String pictograma = "";

  List<Map<String, dynamic>> tareasPendientes = [];
  List<Map<String, dynamic>> tareasCompletadas = [];

  // --------------------------------------------------------------

  Future<void> setTareas() async {
    // Llama a la función que obtiene las tareas asignadas
    List<Map<String, dynamic>> tareasAsignadas =
        await taskController.getTareaAsignadaPorEstudiante(
      widget.userName,
      widget.userSurname,
    );

    // Inicializa las listas de tareas pendientes y completadas
    List<Map<String, dynamic>> pendientes = [];
    List<Map<String, dynamic>> completadas = [];

    for (var tareaAsignada in tareasAsignadas) {
      int idTarea = tareaAsignada['asignada']['id_tarea'];

      List<Map<String, Map<String, dynamic>>> detallesTarea =
          await taskController.getTarea(idTarea);

      // Verifica si la tarea está completada o pendiente
      if (detallesTarea.isNotEmpty &&
          detallesTarea[0]['tarea']?['completada'] == true) {
        completadas.addAll(detallesTarea);
      } else {
        pendientes.addAll(detallesTarea);
      }
    }

    setState(() {
      tareasPendientes = pendientes;
      tareasCompletadas = completadas;
    });
  }

  // --------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    setTareas();
  }

  // --------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Container(
          margin: const EdgeInsets.only(left: 8.0),
          child: const Row(
            children: [
              // Imagen circular
              CircleAvatar(
                radius: 18, // Ajusta según sea necesario
                backgroundImage: AssetImage('assets/usuario_sin_foto.png'),
              ),
              // --------------------------
              SizedBox(width: 15),
              // --------------------------
              Text(
                '¡Bienvenido Sergio Lopez!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: PageView(
          children: [
            Column(
              children: [
                // -------------------------------
                const SizedBox(height: 12),
                // ----------------------------------------
                const Text(
                  'Tareas Pendientes',
                  style: TextStyle(
                    color: Color.fromARGB(255, 26, 106, 170),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // -------------------------------
                const SizedBox(height: 10),
                // ----------------------------------------
                Expanded(
                  child: ListView.builder(
                    itemCount: tareasPendientes.length,
                    itemBuilder: (BuildContext context, int index) {
                      taskController
                          .tipoTarea(tareasPendientes[index]['tarea']['id'])
                          .then((resultado) {
                        tipo = resultado;
                      });

                      switch (tipo) {
                        case "general":
                          pictograma = "assets/tarea_general.png";
                          break;
                        case "material":
                          pictograma = "assets/tarea_material.png";
                          break;
                        case "comanda":
                          pictograma = "assets/tarea_comanda.png";
                          break;
                        default:
                          pictograma = "assets/tarea.png";
                          break;
                      }

                      return InkWell(
                          child: Card(
                              color: const Color.fromARGB(255, 221, 234, 255),
                              margin: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 5.0,
                                  left: 15.0,
                                  right: 15.0),
                              child: ListTile(
                                title: GestureDetector(
                                  // ----------------------
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        "${tareasPendientes[index]['tarea']?['nombre']}",
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 76, 76, 76),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                                leading: CircleAvatar(
                                  radius: 17.5,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    pictograma,
                                    width: 35,
                                    height: 35,
                                  ),
                                ),
                              )));
                    },
                  ),
                ),
                // -------------------------------
                const SizedBox(height: 15),
                // -------------------------------
                Container(
                  height: 1.5,
                  color: Colors.blue, // Línea azul de separación.
                ),
                // -------------------------------
                const SizedBox(height: 12),
                // ----------------------------------------
                const Text(
                  'Tareas Completadas',
                  style: TextStyle(
                    color: Color.fromARGB(255, 26, 106, 170),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // -------------------------------
                const SizedBox(height: 10),
                // ---------------------------------------------------------------
                Expanded(
                  child: ListView.builder(
                    itemCount: tareasCompletadas.length,
                    itemBuilder: (BuildContext context, int index) {
                      taskController
                          .tipoTarea(tareasCompletadas[index]['tarea']['id'])
                          .then((resultado) {
                        tipo = resultado;
                      });

                      switch (tipo) {
                        case "general":
                          pictograma = "assets/tarea_general.png";
                          break;
                        case "material":
                          pictograma = "assets/tarea_material.png";
                          break;
                        case "comanda":
                          pictograma = "assets/tarea_comanda.png";
                          break;
                        default:
                          pictograma = "assets/tarea.png";
                          break;
                      }

                      return InkWell(
                          child: Card(
                              color: const Color.fromARGB(255, 229, 250, 238),
                              margin: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 5.0,
                                  left: 15.0,
                                  right: 15.0),
                              child: ListTile(
                                title: GestureDetector(
                                  // ----------------------
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        "${tareasCompletadas[index]['tarea']?['nombre']}",
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 76, 76, 76),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                                // -----------------------------
                                leading: CircleAvatar(
                                  radius: 17.5,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    pictograma,
                                    width: 35,
                                    height: 35,
                                  ),
                                ),
                              )));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: StudentNavigationBar(
          userName: widget.userName, userSurname: widget.userSurname),
    );
  }
}
