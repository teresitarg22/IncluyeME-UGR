import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:postgres/postgres.dart';
import '../model/estudiante.dart';
import '../model/user.dart';
import '../model/logic_database.dart';
import './user_list.dart';

// -------------------------- DATA BASE --------------------------

// Create the connection as a global variable
final connection = PostgreSQLConnection(
  'flora.db.elephantsql.com', // database host
  5432, // database port
  'srvvjedp', // database name
  username: 'srvvjedp', // database username
  password: 'tuZz6S15UozErJ7aROYQFR3ZcThFJ9MZ', // database user's password
);

Future<List<Map<String, Map<String, dynamic>>>> request(String query) async {
  List<Map<String, Map<String, dynamic>>> results = [];

  try {
    // Check if the connection is closed before attempting to open it
    if (connection.isClosed) {
      await connection.open();
      print('Connected to the database');
    }

    results = await connection.mappedResultsQuery(query);
  } catch (e) {
    print('Error: $e');
  } finally {
    // Do not close the connection here
    print('Query executed');
  }

  return results;
}

// -----------------------------------------------------

class UserDetailsPage extends StatefulWidget {
  final String nombre;
  final bool esEstudiante;
  final String user;

  UserDetailsPage(
      {required this.nombre, required this.esEstudiante, required this.user});
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();
  var resultado = [];
  User? user;

  @override
  void initState() {
    super.initState();
    buscarDatosUsuario();
  }

  Future<void> buscarDatosUsuario() async {
    if (widget.esEstudiante == true) {
      resultado = await request(
          'SELECT * FROM estudiante WHERE nombre = \'${widget.nombre}\'');

      if (resultado.isNotEmpty) {
        setState(() {
          final detalles = resultado[0]['estudiante'];

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
    } else {
      resultado = await request(
          'SELECT * FROM personal WHERE nombre = \'${widget.nombre}\'');

      if (resultado.isNotEmpty) {
        setState(() {
          final detalles = resultado[0]['personal'];

          user = User(
              nombre: detalles['nombre'],
              apellidos: detalles['apellidos'],
              correo: detalles['correo'],
              foto: "",
              contrasenia: detalles['contrasenia']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Usuario'),
        backgroundColor: Color(0xFF29DA81),
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
                const Divider(height: 1, color: Colors.grey), // Línea divisoria
                Container(
                  //margin: EdgeInsets.only(top: 12, left: 20, right: 10),
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
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
                        Row(
                          children: [
                            const Text(
                              'Nombre:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${user?.nombre}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                        SizedBox(height: 4),
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
                              user?.contrasenia ?? '' ,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              widget.esEstudiante ? 'Contraseña de iconos' : "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.esEstudiante
                                  ? '${(user as Estudiante?)?.contrasenia_iconos ?? ''}'
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
                                  ? '${(user as Estudiante?)?.tipo_letra ?? ''}'
                                  : '',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                                  ? '${(user as Estudiante?)?.maymin ?? ''}'
                                  : '',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                                  ? '${(user as Estudiante?)?.formato ?? ''}'
                                  : '',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
        backgroundColor: Color(0xFF29DA81), // Color personalizado
        currentIndex: 0,
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UserListPage(
                user: widget.user,
              );
            }));
          } else if (index == 1) {
            // Lógica para la pestaña "Tareas"
          } else if (index == 2) {
            // Lógica para la pestaña "Gráficos"
          } else if (index == 3) {
            // Lógica para la pestaña "Chat"
          } else if (index == 4) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UserDetailsPage(
                nombre: widget.user,
                esEstudiante: false,
                user: widget.user,
              );
            }));
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF29DA81), // Color personalizado
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
