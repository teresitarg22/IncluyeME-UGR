import 'package:flutter/material.dart';
import 'package:incluye_me/components/bottom_student_bar.dart';
import 'package:incluye_me/controllers/user_controller.dart';
import 'package:incluye_me/controllers/task_controller.dart';
import 'package:incluye_me/model/student.dart';
import 'package:incluye_me/model/user.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:incluye_me/views/staff/graphics.dart';

class StudentDetailsPage extends StatefulWidget {
  final String userName;
  final String userSurname;

  StudentDetailsPage(
      {super.key, required this.userName, required this.userSurname});

  @override
  _StudentDetailsPageState createState() =>
      _StudentDetailsPageState(userName, userSurname);
}

// ----------------------------------------------------------------------

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  String userName = "";
  String userSurname = "";

  List<Map<String, dynamic>> tareasPendientes = [];
  List<Map<String, dynamic>> tareasCompletadas = [];

  final TaskController taskController = TaskController();
  final Controller detailController = Controller();

  User? user;

  // ---------------------------------------------
  // Buscamos en la BD los detalles del usuario
  Future<void> buscarDatosUsuario() async {
    var resultado = await detailController.getEstudiante(
        widget.userName, widget.userSurname);
    user = Estudiante.fromJson(resultado[0]);

    setState(() {});
  }

  // ---------------------------
  @override
  void initState() {
    super.initState();
    buscarDatosUsuario();
  }

  // ---------------------------

  _StudentDetailsPageState(String userName, String userSurname) {
    this.userName = userName;
    this.userSurname = userSurname;
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
                    //Imagen circular del alumno.
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width > 600 ? 80 : 50,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: user?.foto != null
                            ? Image.memory(
                                user?.foto,
                                width: MediaQuery.of(context).size.width > 600
                                    ? 160
                                    : 110,
                                height: MediaQuery.of(context).size.width > 600
                                    ? 160
                                    : 110,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/usuario_sin_foto.png',
                                width: MediaQuery.of(context).size.width > 600
                                    ? 160
                                    : 110,
                                height: MediaQuery.of(context).size.width > 600
                                    ? 160
                                    : 110,
                                fit: BoxFit.cover,
                              ),
                      ),
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
