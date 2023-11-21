import 'package:flutter/material.dart';
import 'package:incluye_me/views/task_view.dart';
import 'mostrar_usuario.dart';
import 'edit_user.dart';
import '../controllers/session_controller.dart';
import '../controllers/task_controller.dart';
import 'user_list.dart';
import 'edit_user.dart';

// --------------------------------------------
// Clase para la página de lista de usuarios
class TaskListPage extends StatefulWidget {
  final String userName;
  final String userSurname;

  const TaskListPage(
      {super.key, required this.userName, required this.userSurname});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

// ------------------------------------------------------------------

class _TaskListPageState extends State<TaskListPage> {
  bool isAdmin = false;
  var tareas = [];
  var material = [];
  String tipo = ""; // Variable para almacenar el tipo de tarea
  bool asignada = false; // Variable para almacenar si la tarea está asignada

  Controller controlador = Controller();

  SessionController sessionController = SessionController();

  String? selectedFilter = "Todas";

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
    await loadTaskIds();
    await initializeAdminStatus();
  }

  // -----------------------------
  Future<void> loadTaskIds() async {
    tareas = await controlador.listaTareas();
    material = await controlador.listaTareasMaterial();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
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
                          // Navigator.of(context).pop();
                          // // Lógica de búsqueda con "query".
                          // var searchResults = tareas.where((user) {
                          //   final estudianteNombre =
                          //       user['estudiante']?['nombre']?.toLowerCase() ??
                          //           '';
                          //   final personalNombre =
                          //       user['personal']?['nombre']?.toLowerCase() ??
                          //           '';

                          //   return estudianteNombre
                          //           .contains(query.toLowerCase()) ||
                          //       personalNombre.contains(query.toLowerCase());
                          // }).toList();

                          // // Filtra la lista de usuarios según "query".
                          // setState(() {
                          //   // Actualiza la lista de usuarios para mostrar los resultados de la búsqueda.
                          //   tareas.clear();
                          //   tareas.addAll(searchResults
                          //       .cast<Map<String, Map<String, dynamic>>>());
                          // });
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
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tareas.length,
              itemBuilder: (BuildContext context, int index) {
                controlador
                    .tipoTarea(tareas[index]['tarea']['id'])
                    .then((resultado) {
                  tipo = resultado;
                });
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TaskDetailsPage(
                        taskID: tareas[index]['id'],
                        tipo: tipo,
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
                              "${tareas[index]?['tarea']?['nombre']}",
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
                      subtitle: Text(tipo),
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

                                // Mostrar un diálogo de confirmación
                                bool confirmar = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Confirmar Eliminación'),
                                      content: const Text(
                                          '¿Seguro que quiere eliminar la tarea?'),
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
                                  controlador.eliminarTarea(
                                      tareas[index]['tarea']['id']);

                                  //Actualizar la vista
                                  setState(() {
                                    // Aquí puedes realizar las actualizaciones necesarias para refrescar la página.
                                    // Por ejemplo, podrías eliminar el usuario de la lista de usuarios filtrados:
                                    tareas.removeAt(index);
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
          Stack(
            children: [
              // Botón principal
              ElevatedButton(
                onPressed: () {
                  // Acciones cuando se pulsa el botón principal
                  Navigator.pushNamed(context, '/registroPage');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF29DA81),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8.0),
                    Text(
                      'Nueva Tarea',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              // Botón "Petición de materiales"
              Positioned(
                top: 16, // Ajusta la posición vertical según sea necesario
                left: 16, // Ajusta la posición horizontal según sea necesario
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/materialesPage');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29DA81),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inventory),
                      SizedBox(width: 8.0),
                      Text(
                        'Petición de materiales',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              // Botón "Tarea General"
              Positioned(
                top: 16, // Ajusta la posición vertical según sea necesario
                right: 16, // Ajusta la posición horizontal según sea necesario
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/tareaGeneralPage');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29DA81),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.assignment),
                      SizedBox(width: 8.0),
                      Text(
                        'Tarea General',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TaskListPage(
                userName: widget.userName,
                userSurname: widget.userSurname,
              );
            }));
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

  // -------------------------------------------------------------------------
  // Lógica para construir la interfaz no administrador
  Widget buildNonAdminUI() {
    var tareas = material;
    tipo = "material";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
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
                          // Navigator.of(context).pop();
                          // // Lógica de búsqueda con "query".
                          // var searchResults = estudiantes
                          //     .where((user) =>
                          //         user['nombre'] != null &&
                          //         user['nombre']
                          //             .toLowerCase()
                          //             .contains(query.toLowerCase()))
                          //     .toList();
                          // // Filtra la lista de usuarios según "query".
                          // setState(() {
                          //   // Actualiza la lista de usuarios para mostrar los resultados de la búsqueda.
                          //   tareas.clear();
                          //   tareas.addAll(searchResults
                          //       .cast<Map<String, Map<String, dynamic>>>());
                          // });
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
              itemCount: tareas.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TaskDetailsPage(
                        taskID: tareas[index]['tarea']['id'],
                        tipo: tipo,
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
                              "${tareas[index]['estudiante']?['nombre']} ${tareas[index]['estudiante']?['apellidos']}",
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
                      subtitle: Text(tareas[index]['estudiante']['correo']),
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
