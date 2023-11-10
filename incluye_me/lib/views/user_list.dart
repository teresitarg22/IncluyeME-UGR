import 'package:flutter/material.dart';
import 'mostrar_usuario.dart';
import 'edit_user.dart';
import '../controllers/usuario_controller.dart';
import '../controllers/session_controller.dart';

// --------------------------------------------
// Clase para la página de lista de usuarios
class UserListPage extends StatefulWidget {
  final String userName;
  final String userSurname;

  const UserListPage(
      {super.key, required this.userName, required this.userSurname});

  @override
  _UserListPageState createState() => _UserListPageState();
}

// ------------------------------------------------------------------

class _UserListPageState extends State<UserListPage> {
  bool isAdmin = false;
  var estudiantes = [];
  var personal = [];
  var usuarios = [];
  Controller controlador = Controller();

  SessionController sessionController = SessionController();

  String? selectedFilter = "Estudiantes";

  // -----------------------------
  void userLogout() async {
    await sessionController.logout();
    Navigator.of(context).pushReplacementNamed('/');
  }

  // -----------------------------
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  // -----------------------------
  Future<void> initializeData() async {
    await loadUsersIds();
    await initializeAdminStatus();
  }

  // -----------------------------
  Future<void> loadUsersIds() async {
    estudiantes = await controlador.listaEstudiantes();
    personal = await controlador.listaPersonal();

    setState(() {
      usuarios.addAll(estudiantes);
      usuarios.addAll(personal);
    });
  }

  // -----------------------------
  Future<void> initializeAdminStatus() async {
    bool adminStatus =
        await controlador.esAdmin(widget.userName, widget.userSurname);
    setState(() => isAdmin = adminStatus);
  }

  // -----------------------------
  @override
  Widget build(BuildContext context) {
    return isAdmin ? buildAdminUI() : buildNonAdminUI();
  }

  // ---------------------------------------------------------
  // Lógica para construir la interfaz de administrador.
  Widget buildAdminUI() {
    var filteredUsers = [];
    bool esEstudiante = true;
    String tipo = "estudiante";

    if (selectedFilter == "Personal") {
      filteredUsers = personal;
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
              // Abre un cuadro de diálogo para la búsqueda.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String query =
                      ''; // Variable para almacenar la consulta de búsqueda.

                  return AlertDialog(
                    title: const Text('Buscar por Nombre'),
                    content: TextField(
                      onChanged: (text) {
                        query =
                            text; // Almacena la consulta a medida que se escribe.
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Cierra el cuadro de diálogo y realiza la búsqueda
                          Navigator.of(context).pop();
                          // Lógica de búsqueda con "query".
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

                          // Filtra la lista de usuarios según "query".
                          setState(() {
                            // Actualiza la lista de usuarios para mostrar los resultados de la búsqueda.
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
            icon: const Icon(Icons.search), // Icono de lupa.
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
                  controlador
                      .esUsuarioEstudiante(
                          filteredUsers[index][tipo]?['nombre'],
                          filteredUsers[index][tipo]?['apellidos'])
                      .then((valorEsEstudiante) {
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
                        apellidos: filteredUsers[index][tipo]['apellidos'],
                        esEstudiante: esEstudiante,
                        userName: widget.userName,
                        userSurname: widget.userSurname,
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
                                fontSize: 18, // Tamaño de fuente más grande.
                                fontWeight:
                                    FontWeight.bold, // Texto en negrita.
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
                                          apellidos: filteredUsers[index][tipo]
                                              ['apellidos'],
                                          esEstudiante: esEstudiante,
                                          userName: widget.userName,
                                          userSurname: widget.userSurname,
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
                                // Función asíncrona.

                                // Mostrar un diálogo de confirmación.
                                bool confirmar = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Confirmar Eliminación'),
                                      content: const Text(
                                          '¿Seguro que quiere eliminar al usuario?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Sí'),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                true); // Confirma la eliminación.
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('No'),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                false); // Cancela la eliminación.
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmar) {
                                  // Realizar la actualización en la base de datos.
                                  controlador.eliminarEstudiante(
                                      filteredUsers[index][tipo]['nombre'],
                                      filteredUsers[index][tipo]['apellidos']);

                                  //Actualizar la vista.
                                  setState(() {
                                    // Eliminar el usuario de la lista de usuarios filtrados:
                                    filteredUsers.removeAt(index);
                                  });
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ---------------------------------------------------------------------
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
                userName: widget.userName,
                userSurname: widget.userSurname,
              );
            }));
          } else if (index == 1) {
            // Lógica para la pestaña "Tareas".
          } else if (index == 2) {
            // Lógica para la pestaña "Gráficos".
          } else if (index == 3) {
            // Lógica para la pestaña "Chat".
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

  // -------------------------------------------------------------------------
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
              // Abre un cuadro de diálogo para la búsqueda.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String query =
                      ''; // Variable para almacenar la consulta de búsqueda.

                  return AlertDialog(
                    title: const Text('Buscar por Nombre'),
                    content: TextField(
                      onChanged: (text) {
                        query =
                            text; // Almacena la consulta a medida que se escribe.
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Cierra el cuadro de diálogo y realiza la búsqueda.
                          Navigator.of(context).pop();
                          // Lógica de búsqueda con "query".
                          var searchResults = estudiantes
                              .where((user) =>
                                  user['nombre'] != null &&
                                  user['nombre']
                                      .toLowerCase()
                                      .contains(query.toLowerCase()))
                              .toList();
                          // Filtra la lista de usuarios según "query".
                          setState(() {
                            // Actualiza la lista de usuarios para mostrar los resultados de la búsqueda.
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
                        apellidos: filteredUsers[index]['estudiante']
                            ['apellidos'],
                        esEstudiante: esEstudiante,
                        userName: widget.userName,
                        userSurname: widget.userSurname,
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
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                userName: widget.userName,
                userSurname: widget.userSurname,
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
                nombre: widget.userName,
                apellidos: widget.userSurname,
                esEstudiante: false,
                userName: widget.userSurname,
                userSurname: widget.userSurname,
              );
            }));
          } else if (index == 5) {
            userLogout();
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
          BottomNavigationBarItem(
            icon: Icon(Icons.logout, color: Colors.white),
            label: 'Cerrar Sesión',
          ),
        ],
      ),
    );
  }
}
