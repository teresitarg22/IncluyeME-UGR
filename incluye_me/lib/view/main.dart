import 'package:flutter/material.dart';
import 'registro.dart';
import 'editar_usuario.dart';
import 'package:incluye_me/model/user.dart';

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
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/registroPage');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF29DA81),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(16.0),
            ),
            child: Text('Crear Nuevo Usuario'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                if (selectedFilter == "Todos" ||
                    (selectedFilter == "Profesores" &&
                        users[index].isTeacher) ||
                    (selectedFilter == "Alumnos" && !users[index].isTeacher)) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: GestureDetector(
                        child: Text(users[index].name),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UserDetailsPage(
                              user: users[index],
                            );
                          }));
                        },
                      ),
                      subtitle: Text(users[index].email),
                      leading: Icon(Icons.person),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.black),
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
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              // Agregar lógica de eliminación
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
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

class UserDetailsPage extends StatelessWidget {
  final User user;

  UserDetailsPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Usuario'),
        backgroundColor: Color(0xFF29DA81), // Color personalizado
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('Nombre: ${user.name}'),
                subtitle: Text('Email: ${user.email}'),
              ),
              // Puedes mostrar más detalles del usuario aquí dentro de Card
            ],
          ),
        ),
      ),
    );
  }
}
