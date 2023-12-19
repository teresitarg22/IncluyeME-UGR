import 'package:flutter/material.dart';
import 'package:incluye_me/components/bottom_student_bar.dart';
import 'package:incluye_me/controllers/user_controller.dart';
import 'package:incluye_me/controllers/task_controller.dart';
import 'package:incluye_me/model/student.dart';
import 'package:incluye_me/model/user.dart';

class StudentDetailsPage extends StatefulWidget {
  final String userName;
  final String userSurname;

  const StudentDetailsPage(
      {super.key, required this.userName, required this.userSurname});

  @override
  _StudentDetailsPageState createState() => _StudentDetailsPageState();
}

// ----------------------------------------------------------------------

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  List<Map<String, dynamic>> tareasPendientes = [];
  List<Map<String, dynamic>> tareasCompletadas = [];

  double tareasCompletadasPorcentaje = 50.0;
  double tareasNoCompletadasPorcentaje = 50.0;
  int tareasTotales = 0;

  final TaskController taskController = TaskController();
  final Controller detailController = Controller();

  var resultado;
  User? user;

  // -----------------------------------------------------------------------------------------
  // Buscamos en la BD los detalles del usuario, teniendo en cuenta si es estudiante o no.
  Future<void> buscarDatosUsuario() async {
    resultado = await detailController.getEstudiante(
        widget.userName, widget.userSurname);

    setState(() {
      var detalles = resultado[0]['estudiante'];

      user = Estudiante(
          nombre: detalles['nombre'],
          apellidos: detalles['apellidos'],
          correo: detalles['correo'],
          foto: "",
          contrasenia: detalles['contrasenia'],
          tipo_letra: detalles['tipo_letra'] ?? '',
          maymin: detalles['maymin'] ?? '',
          formato: detalles['formato'] ?? '',
          contrasenia_iconos: detalles['contrasenia_iconos'] ?? '',
          sabeLeer: detalles['sabeLeer'] ?? false);
    });
  }

  // -----------------------------------------------------------------

  Future<void> setTareas() async {
    List<Map<String, dynamic>> tareasAsignadas =
        await taskController.getTareaAsignadaPorEstudiante(
      widget.userName,
      widget.userSurname,
    );

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

      setState(() {
        tareasPendientes = pendientes;
        tareasCompletadas = completadas;

        tareasCompletadasPorcentaje =
            (tareasCompletadas.length / tareasTotales) * 100;
        tareasNoCompletadasPorcentaje =
            (tareasPendientes.length / tareasTotales) * 100;
      });
    }
  }

  // ---------------------------
  @override
  void initState() {
    super.initState();
    buscarDatosUsuario();
    //setTareas();
  }

  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil del Usuario',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
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
                    '${user?.nombre} ${user?.apellidos}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 25, 72, 110),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // -----------------------------------------------------
                const Divider(height: 1, color: Colors.grey),
                const SizedBox(height: 20),
                // -----------------------------------------------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    // Imagen circular del alumno.
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width > 600 ? 80 : 55,
                      backgroundImage:
                          const AssetImage('assets/usuario_sin_foto.png'),
                    ),
                    // -----------------------------
                    const SizedBox(width: 30),
                    // -----------------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información personal',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 18
                                : 15,
                            color: Color.fromARGB(255, 25, 72, 110),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // -----------------------------
                        Row(
                          children: [
                            Text(
                              'Nombre:',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 18
                                        : 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${user?.nombre}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        // -----------------------------
                        const SizedBox(height: 4),
                        // -----------------------------
                        Row(
                          children: [
                            Text(
                              'Apellido:',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 18
                                        : 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${user?.apellidos}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // -----------------------------
                        Row(
                          children: [
                            Text('Email:',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 18
                                            : 15,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Text(
                              user?.correo ?? 'No tiene',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ]),
                ),
                // -----------------------------------------------------
                const SizedBox(height: 20),
                const Divider(height: 1, color: Colors.grey),
                // -----------------------------------------------------
              ]),
        ),
      ),
      bottomNavigationBar: StudentNavigationBar(
          userName: widget.userName, userSurname: widget.userSurname),
    );
  }
}
