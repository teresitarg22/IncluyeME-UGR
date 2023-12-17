import 'package:flutter/material.dart';
import 'package:incluye_me/controllers/task_controller.dart';

class StudentInterface extends StatefulWidget {
  final String nombre;
  final String apellidos;

  const StudentInterface({
    super.key,
    required this.nombre,
    required this.apellidos,
  });

  @override
  _StudentInterfaceState createState() => _StudentInterfaceState();
}

// ----------------------------------------------------------------------------

class _StudentInterfaceState extends State<StudentInterface> {
  final Controller taskController = Controller();
  String tipo = ""; // Variable para almacenar el tipo de tarea

  List<Map<String, dynamic>> tareasPendientes = [];
  List<Map<String, dynamic>> tareasCompletadas = [];

  // --------------------------------------------------------------

  Future<void> setTareas() async {
    // Llama a la función que obtiene las tareas asignadas
    List<Map<String, dynamic>> tareasAsignadas =
        await taskController.getTareaAsignadaPorEstudiante(
      widget.nombre,
      widget.apellidos,
    );

    // Inicializa las listas de tareas pendientes y completadas
    List<Map<String, dynamic>> pendientes = [];
    List<Map<String, dynamic>> completadas = [];

    // Itera sobre los IDs de tareas y obtiene los datos
    for (var tareaAsignada in tareasAsignadas) {
      int idTarea = tareaAsignada['asignada']['id_tarea'];

      // Llama a la función que obtiene los detalles de la tarea
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
        actions: [
          IconButton(
            icon: const Icon(Icons.house),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            color: Colors.white,
          ),
        ],
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
                      return InkWell(
                          child: Card(
                              color: const Color.fromARGB(255, 241, 233, 255),
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
                                leading: const Icon(
                                  Icons.task_outlined,
                                  size: 35,
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
                                leading: const Icon(
                                  Icons.task,
                                  size: 35,
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
    );
  }
}
