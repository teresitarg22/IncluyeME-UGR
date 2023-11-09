import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'mostrar_usuario.dart';
import 'edit_user.dart';

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

Future<bool> esAdmin(String user) async {
  var value = await request("SELECT * FROM personal WHERE nombre = '$user'");

  if (value.isNotEmpty) {
    var personalData = value[0]['personal'];

    if (personalData != null && personalData['es_admin'] == true) {
      return true;
    }
  }

  return false;
}

Future<bool> esUsuarioEstudiante(String user) async {
  var value = await request("SELECT * FROM estudiante WHERE nombre = '$user'");

  if (value.isNotEmpty) {
    var estudianteData = value[0]['estudiante'];

    if (estudianteData != null && estudianteData['nombre'] == user) {
      return true;
    }
  }

  return false;
}

//---------------------------------------------------------------------------------------
class UserListPage extends StatefulWidget {
  final String user;

  const UserListPage({super.key, required this.user});

  @override
  _UserListPageState createState() => _UserListPageState(user: user);
}

class _UserListPageState extends State<UserListPage> {
  late bool isAdmin = false;
  late String user;
  final _formKey = GlobalKey<FormState>();
  var estudiantes = [];
  var supervisor = [];
  var usuarios = [];

  String? selectedFilter = "Estudiantes";

  _UserListPageState({required this.user});

  @override
  void initState() {
    super.initState();
    user = widget.user;
    initializeData();
  }

  Future<void> initializeData() async {
    await loadUsersIds();
    await initializeAdminStatus();
  }

  Future<void> initializeAdminStatus() async {
    bool adminStatus = await esAdmin(user);
    setState(() => isAdmin = adminStatus);
  }

  Future<void> loadUsersIds() async {
    estudiantes = await request('SELECT * FROM estudiante');
    supervisor = await request('SELECT * FROM personal');
    usuarios.addAll(estudiantes);
    usuarios.addAll(supervisor);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isAdmin ? buildAdminUI() : buildNonAdminUI();
  }

  // Lógica para construir la interfaz de administrador
  Widget buildAdminUI() {
    var filteredUsers = [];
    bool esEstudiante = true;
    String tipo = "estudiante";

    if (selectedFilter == "Personal") {
      filteredUsers = supervisor;
      esEstudiante = false;
      tipo = "personal";
    } else if (selectedFilter == "Estudiantes") {
      filteredUsers = estudiantes;
      esEstudiante = true;
      tipo = "estudiante";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
        backgroundColor: const Color(0xFF29DA81),
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
                    title: const Text('Buscar por Nombre'),
                    content: TextField(
                      onChanged: (text) {
                        query =
                            text; // Almacena la consulta a medida que se escribe
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Cierra el cuadro de diálogo y realiza la búsqueda
                          Navigator.of(context).pop();
                          // Lógica de búsqueda con "query"
                          var searchResults = usuarios.where((user) {
                            final estudianteNombre =
                                user['estudiante']?['nombre']?.toLowerCase() ??
                                    '';
                            final personalNombre =
                                user['personal']?['nombre']?.toLowerCase() ??
                                    '';

                            return estudianteNombre
                                    .contains(query.toLowerCase()) ||
                                personalNombre.contains(query.toLowerCase());
                          }).toList();

                          // Filtra la lista de usuarios según "query"
                          setState(() {
                            // Actualiza la lista de usuarios para mostrar los resultados de la búsqueda
                            filteredUsers.clear();
                            filteredUsers.addAll(searchResults
                                .cast<Map<String, Map<String, dynamic>>>());
                          });
                        },
                        child: const Text('Buscar'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.search), // Icono de lupa
          ),
          DropdownButton<String?>(
            value: selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                selectedFilter = newValue;
              });
            },
            items: <String?>['Estudiantes', 'Personal']
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
                final nombre = filteredUsers[index][tipo]?['nombre'];

                if (nombre != null) {
                  esUsuarioEstudiante(nombre).then((valorEsEstudiante) {
                    esEstudiante = valorEsEstudiante;
                    if (esEstudiante) {
                      tipo = "estudiante";
                    } else {
                      tipo = "personal";
                    }
                  });
                }

                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UserDetailsPage(
                        nombre: filteredUsers[index][tipo]['nombre'],
                        esEstudiante: esEstudiante,
                        user: widget.user,
                      );
                    }));
                  },
                  child: Card(
                    margin: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                    child: ListTile(
                      title: GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              "${filteredUsers[index]?[tipo]?['nombre']} ${filteredUsers[index]?[tipo]?['apellidos']}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 76, 76, 76),
                                fontSize: 18, // Tamaño de fuente más grande
                                fontWeight: FontWeight.bold, // Texto en negrita
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      subtitle:
                          Text(filteredUsers[index][tipo]?['correo'] ?? ''),
                      leading: const Icon(
                        Icons.person,
                        size: 45,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ------------------------------------
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color.fromARGB(255, 76, 76, 76)),
                            onPressed: () {
                              // Nos dirigimos a la interfaz de edición de usuario:
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => EditUserPage(
                                          nombre: filteredUsers[index][tipo]
                                              ['nombre'],
                                          esEstudiante: esEstudiante,
                                          user: widget.user,
                                        )),
                              );
                            },
                          ),
                          // -----------------
                          const SizedBox(width: 30.0),
                          // -----------------
                          IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color.fromARGB(255, 76, 76, 76)),
                              onPressed: () async {
                                // Hacer la función asíncrona
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  // Mostrar un diálogo de confirmación
                                  bool confirmar = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmar Eliminación'),
                                        content: const Text(
                                            '¿Seguro que quiere eliminar al usuario?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Sí'),
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  true); // Confirma la eliminación
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('No'),
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  false); // Cancela la eliminación
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmar) {
                                    // Realizar la actualización en la base de datos
                                    String updateQuery =
                                        "DELETE FROM usuario WHERE nombre = '${filteredUsers[index][tipo]['nombre']}' and apellidos = '${filteredUsers[index][tipo]['apellidos']}'";
                                    // Luego, ejecuta la consulta en tu base de datos PostgreSQL
                                    request(updateQuery);

                                    //Actualizar la vista
                                    setState(() {
                                      // Aquí puedes realizar las actualizaciones necesarias para refrescar la página.
                                      // Por ejemplo, podrías eliminar el usuario de la lista de usuarios filtrados:
                                      filteredUsers.removeAt(index);
                                    });
                                  }
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                );
                //}
                return Container();
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16.0, bottom: 30.0),
            child: ElevatedButton(
              // --------------------------
              onPressed: () {
                Navigator.pushNamed(context, '/registroPage');
              },
              // --------------------------
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF29DA81),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
              ),
              // --------------------------
              child: const Row(
                // Usamos un Row para colocar el icono y el texto horizontalmente.
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8.0),
                  Text('Nuevo Usuario',
                      style: TextStyle(fontSize: 16)), // El texto del botón.
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF29DA81),
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

  // Lógica para construir la interfaz no administrador
  Widget buildNonAdminUI() {
    var filteredUsers = estudiantes;
    bool esEstudiante = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Alumnos'),
        backgroundColor: const Color(0xFF29DA81),
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
                    title: const Text('Buscar por Nombre'),
                    content: TextField(
                      onChanged: (text) {
                        query =
                            text; // Almacena la consulta a medida que se escribe
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Cierra el cuadro de diálogo y realiza la búsqueda
                          Navigator.of(context).pop();
                          // Lógica de búsqueda con "query"
                          var searchResults = estudiantes
                              .where((user) =>
                                  user['nombre'] != null &&
                                  user['nombre']
                                      .toLowerCase()
                                      .contains(query.toLowerCase()))
                              .toList();
                          // Filtra la lista de usuarios según "query"
                          setState(() {
                            // Actualiza la lista de usuarios para mostrar los resultados de la búsqueda
                            filteredUsers.clear();
                            filteredUsers.addAll(searchResults
                                .cast<Map<String, Map<String, dynamic>>>());
                          });
                        },
                        child: const Text('Buscar'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.search), // Icono de lupa
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UserDetailsPage(
                        nombre: filteredUsers[index]['estudiante']['nombre'],
                        esEstudiante: esEstudiante,
                        user: widget.user,
                      );
                    }));
                  },
                  child: Card(
                    margin: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                    child: ListTile(
                      title: GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              "${filteredUsers[index]['estudiante']?['nombre']} ${filteredUsers[index]['estudiante']?['apellidos']}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 76, 76, 76),
                                fontSize: 18, // Tamaño de fuente más grande
                                fontWeight: FontWeight.bold, // Texto en negrita
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      subtitle:
                          Text(filteredUsers[index]['estudiante']['correo']),
                      leading: const Icon(
                        Icons.person,
                        size: 45,
                      ),
                      trailing: const Row(
                        mainAxisSize: MainAxisSize.min,
                      ),
                    ),
                  ),
                );
                return Container();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF29DA81),
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
