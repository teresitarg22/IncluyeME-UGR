import 'package:flutter/material.dart';
import '../views/editar_usuario.dart';
import 'package:incluye_me/model/user.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final List<User> users = [
    User(name: 'Usuario 1', email: 'usuario1@example.com', isTeacher: true),
    User(name: 'Usuario 2', email: 'usuario2@example.com', isTeacher: false),
    User(name: 'Usuario 3', email: 'usuario3@example.com', isTeacher: true),
    // Agrega más usuarios según tus necesidades
  ];

  String? selectedFilter = "Todos";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        backgroundColor: Color(0xFF29DA81), // Color personalizado
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
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Cierra el cuadro de diálogo y realiza la búsqueda
                          Navigator.of(context).pop();
                          // Lógica de búsqueda con "query"
                          List<User> searchResults = users
                              .where((user) => user.name
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();
                          // Filtra la lista de usuarios según "query"
                          setState(() {
                            // Actualiza la lista de usuarios para mostrar los resultados de la búsqueda
                            users.clear();
                            users.addAll(searchResults);
                          });
                        },
                        child: Text('Buscar'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.search), // Icono de lupa
          ),
          DropdownButton<String?>(
            value: selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                selectedFilter = newValue;
              });
            },
            items: <String?>['Todos', 'Profesores', 'Alumnos']
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
        // ---------------------------------------------------
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                if (selectedFilter == "Todos" ||
                    (selectedFilter == "Profesores" &&
                        users[index].isTeacher) ||
                    (selectedFilter == "Alumnos" && !users[index].isTeacher)) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return UserDetailsPage(
                          user: users[index],
                        );
                      }));
                    },
                    child: Card(
                      margin: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                      child: ListTile(
                        title: GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                users[index].name,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 76, 76, 76),
                                  fontSize: 18, // Tamaño de fuente más grande
                                  fontWeight:
                                      FontWeight.bold, // Texto en negrita
                                ),
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                        subtitle: Text(users[index].email),
                        leading: Icon(
                          Icons.person,
                          size: 45,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ------------------------------------
                            IconButton(
                              icon: Icon(Icons.edit,
                                  color: Color.fromARGB(255, 76, 76, 76)),
                              onPressed: () {
                                // Nos dirigimos a la interfaz de edición de usuario:
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditarUsuarioPage(user: users[index]),
                                  ),
                                );
                              },
                            ),
                            // -----------------
                            SizedBox(width: 30.0),
                            // -----------------
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color: Color.fromARGB(255, 76, 76, 76)),
                              onPressed: () {
                                // Agregar lógica de eliminación
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16.0, bottom: 30.0),
            child: ElevatedButton(
              // --------------------------
              onPressed: () {
                Navigator.pushNamed(context, '/registroPage');
              },
              // --------------------------
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF29DA81),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(16.0),
              ),
              // --------------------------
              child: Row(
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
        backgroundColor: Color(0xFF29DA81), // Color personalizado
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

// -------------------------------------------------------------------

class UserDetailsPage extends StatelessWidget {
  final User user;

  UserDetailsPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Usuario'),
        backgroundColor: Color(0xFF29DA81), // Color personalizado
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          margin: const EdgeInsets.all(
              16.0), // Agregamos un margen alrededor de la tarjeta
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Alineamos los elementos a la izquierda
            children: <Widget>[
              ListTile(
                title: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22, // Tamaño de fuente para el título
                    fontWeight: FontWeight.bold, // Texto en negrita
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.grey), // Línea divisoria
              Container(
                margin: EdgeInsets.only(top: 12, left: 20, right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '· Email:',
                      style: TextStyle(
                        fontSize: 18, // Tamaño de fuente para el título
                        fontWeight: FontWeight.bold, // Texto en negrita
                      ),
                    ),
                    const SizedBox(width: 8), // Espacio de 8 puntos
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize:
                            16, // Tamaño de fuente para el correo electrónico
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
