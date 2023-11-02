import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'registro.dart';
import 'mostrar_usuario.dart';

// Crear la conexión como una variable global
final connection = PostgreSQLConnection(
  'flora.db.elephantsql.com', // host de la base de datos
  5432, // puerto de la base de datos
  'srvvjedp', // nombre de la base de datos
  username: 'srvvjedp', // nombre de usuario de la base de datos
  password:
      'tuZz6S15UozErJ7aROYQFR3ZcThFJ9MZ', // contraseña del usuario de la base de datos
);

Future<List<Map<String, Map<String, dynamic>>>> request(String query) async {
  List<Map<String, Map<String, dynamic>>> results = [];

  try {
    // Verificar si la conexión está cerrada antes de intentar abrirla
    if (connection.isClosed) {
      await connection.open();
      print('Connected to the database');
    }

    results = await connection.mappedResultsQuery(query);
  } catch (e) {
    print('Error: $e');
  } finally {
    // No cerrar la conexión aquí
    print('Query executed');
  }

  return results;
}

Future<List<Map<String, Map<String, dynamic>>>> getUserById(
    String id, bool esEstudiante, PostgreSQLConnection connection) async {
  final results;
  if (esEstudiante) {
    results = await request('SELECT * FROM estudiante WHERE dni = @id');
  } else {
    results = await request('SELECT * FROM supervisor WHERE dni = @id');
  }

  return results;
}

/*
//Obtenemos los id de los estudiantes
Future<List<String>> getEstudiantesIds(PostgreSQLConnection connection) async {
  final List<String> estudiantesIds = [];

  try {
    if (connection.isClosed) {
      await connection.open();
      print('Connected to the database');
    }
    final results = await connection.query('SELECT dni FROM estudiante');

    for (final row in results) {
      estudiantesIds.add(row[0] as String);
    }
  } catch (e) {
    throw Exception('$e');
  }

  return estudiantesIds;
}

//Obtenemos los id del supervisor
Future<List<String>> getsupervisorIds(PostgreSQLConnection connection) async {
  final List<String> supervisorIds = [];

  try {
    if (connection.isClosed) {
      await connection.open();
      print('Connected to the database');
    }

    final results = await connection.query('SELECT dni FROM supervisor');

    for (final row in results) {
      supervisorIds.add(row[0] as String);
    }
  } catch (e) {
    throw Exception('$e');
  }

  return supervisorIds;
}

//Obtenemos los datos de los usuarios

*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => UserListPage(),
        '/registroPage': (context) => HomeScreen(),
      },
    );
  }
}

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  var estudiantes = [];
  var supervisor = [];
  var usuarios = [];

  String? selectedFilter = "Estudiantes";

  @override
  void initState() {
    super.initState();
    loadUsersIds();
  }

  Future<void> loadUsersIds() async {
    estudiantes = await request('SELECT dni FROM estudiante');
    supervisor = await request('SELECT dni FROM supervisor');
    //estudiantes = await getEstudiantesIds(connection);
    //supervisor = await getsupervisorIds(connection);
    usuarios.addAll(estudiantes);
    usuarios.addAll(supervisor);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var filteredUsers = [];
    bool esEstudiante = true;

    if (selectedFilter == "Supervisor") {
      filteredUsers = supervisor;
      esEstudiante = false;
    } else if (selectedFilter == "Estudiantes") {
      filteredUsers = estudiantes;
      esEstudiante = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        backgroundColor: Color(0xFF29DA81),
        actions: [
          IconButton(
            onPressed: () {
              // Abre un cuadro de diálogo para la búsqueda
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String query =
                      ''; // Variable para almacenar la consulta de búsqueda

                  return AlertDialog(
                    title: Text('Buscar por Nombre'),
                    content: TextField(
                      onChanged: (text) {
                        query =
                            text; // Almacena la consulta a medida que se escribe
                      },
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.search),
          ),
          DropdownButton<String?>(
            value: selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                selectedFilter = newValue;
              });
            },
            items: <String?>['Supervisor', 'Estudiantes']
                .map<DropdownMenuItem<String?>>((String? value) {
              return DropdownMenuItem<String?>(
                value: value,
                child: Text(value ?? ''),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder(
                  future: getUserById(
                      filteredUsers[index], esEstudiante, connection),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final userData = snapshot.data as Map<String, dynamic>;
                      final userName = userData[
                          'nombre']; // Reemplaza 'nombre' con el campo que desees mostrar

                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: GestureDetector(
                            child: Text(userName),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return UserDetailsPage(
                                  userId: filteredUsers[index],
                                );
                              }));
                            },
                          ),
                          // Otros detalles del usuario
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/registroPage');
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF29DA81),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(16.0),
            ),
            child: Text('Crear Nuevo Usuario'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF29DA81),
        currentIndex: 0,
        onTap: (int index) {
          if (index == 0) {
            //reloadUsers();
          } else if (index == 1) {
            // Lógica para la pestaña "Tareas"
          } else if (index == 2) {
            // Lógica para la pestaña "Gráficos"
          } else if (index == 3) {
            // Lógica para la pestaña "Chat"
          } else if (index == 4) {
            // Lógica para la pestaña "Perfil"
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
