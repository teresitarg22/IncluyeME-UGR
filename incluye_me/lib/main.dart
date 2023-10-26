import 'package:flutter/material.dart';
import 'registro.dart';

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

class User {
  final String name;
  final String email;
  final bool isTeacher;

  User(this.name, this.email, this.isTeacher);
}

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final List<User> users = [
    User('Usuario 1', 'usuario1@example.com', true),
    User('Usuario 2', 'usuario2@example.com', false),
    User('Usuario 3', 'usuario3@example.com', true),
    // Agrega más usuarios según tus necesidades
  ];

  String? selectedFilter = "Todos"; // Cambiado a String?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        actions: [
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
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          if (selectedFilter == "Todos" ||
              (selectedFilter == "Profesores" && users[index].isTeacher) ||
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
                        // Agregar lógica de edición
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
          return Container(); // Oculta usuarios que no cumplen con el filtro
        },
      ),
      floatingActionButton: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(16.0),
        child: Material(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: Colors.blue,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/registroPage');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text(
                'Crear Nuevo Usuario',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue, // Cambiar el color de fondo a azul
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
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
