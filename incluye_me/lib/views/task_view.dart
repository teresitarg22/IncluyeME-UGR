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
  var resultado;
  String tipo = "";
  User? user;

  @override
  void initState() {
    super.initState();
    buscarDatosUsuario();
  }

  // -----------------------------------------------------------------------------------------
  // Buscamos en la BD los detalles del usuario, teniendo en cuenta si es estudiante o no.
  Future<void> buscarDatosUsuario() async {
    if (widget.tipo == 'general') {
      // ------------------------
      // ESTUDIANTE
      resultado =
          await controlador.getEstudiante(widget.nombre, widget.apellidos);

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
    } else if (widget.tipo == 'material') {
      // ------------------------
      // PERSONAL
      resultado =
          await controlador.getPersonal(widget.nombre, widget.apellidos);

      setState(() {
        var detalles = resultado[0]['personal'];

        user = User(
            nombre: detalles['nombre'],
            apellidos: detalles['apellidos'],
            correo: detalles['correo'],
            foto: "",
            contrasenia: detalles['contrasenia']);
      });
    } else if (widget.tipo == "comanda") {
    } else {
      print("ERROR: No se ha podido encontrar el tipo de tarea.");
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
                    '${user?.nombre} ${user?.apellidos}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 77, 131, 105),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                /*user?.foto != null
              ? Image.memory(
                 Uint8List.fromList(
                    // Convierte la cadena Base64 a Uint8List
                    base64.decode(user!.foto!),
                  ),
                  width: 100, // ajusta el ancho según tus necesidades
                  height: 100, // ajusta la altura según tus necesidades
                )
              : const Text('Sin foto'),*/
                const Divider(height: 1, color: Colors.grey),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información personal',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 77, 131, 105),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // -----------------------------
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
                              '${user?.nombre}',
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
                              'Apellido:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${user?.apellidos}',
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
                              'Email:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${user?.correo}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Autentificación',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 77, 131, 105),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // -----------------------------
                        Row(
                          children: [
                            const Text(
                              'Contraseña:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              user?.contrasenia ?? 'No tiene',
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
                              widget.esEstudiante
                                  ? 'Contraseña de iconos'
                                  : "No tiene",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.esEstudiante
                                  ? (user as Estudiante?)?.contrasenia_iconos ??
                                      ''
                                  : '',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.esEstudiante ? 'Accesibilidad' : "",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 77, 131, 105),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // -----------------------------
                        Row(
                          children: [
                            Text(
                              widget.esEstudiante ? 'Tipo de letra:' : "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.esEstudiante
                                  ? (user as Estudiante?)?.tipo_letra ?? ''
                                  : '',
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
                              widget.esEstudiante
                                  ? 'Mayúsculas y minúsculas:'
                                  : "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.esEstudiante
                                  ? (user as Estudiante?)?.maymin ?? ''
                                  : '',
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
                              widget.esEstudiante ? 'Formato:' : "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.esEstudiante
                                  ? (user as Estudiante?)?.formato ?? ''
                                  : '',
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
                              widget.esEstudiante ? 'Sabe Leer:' : "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.esEstudiante
                                  ? ((user as Estudiante?)?.sabeLeer ?? false)
                                      ? 'Sí'
                                      : 'No'
                                  : '',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
