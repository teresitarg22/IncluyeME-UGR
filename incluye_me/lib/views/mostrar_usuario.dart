import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

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
  final String userId;
  final bool esEstudiante;

  UserDetailsPage({required this.userId, required this.esEstudiante});
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  var usuario = <Map<String, Map<String, dynamic>>>[];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (widget.esEstudiante) {
      usuario = await connection.mappedResultsQuery(
          "SELECT * FROM estudiante WHERE dni = ${widget.userId}");
    } else {
      usuario = await connection.mappedResultsQuery(
          "SELECT * FROM supervisor WHERE dni = ${widget.userId}");
    }
  }

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
                title: Text(
                    'Nombre: ${usuario.isNotEmpty ? usuario[0]['nombre'] : ''}'),
                subtitle: Text(
                    'Email: ${usuario.isNotEmpty ? usuario[0]['email'] : ''}'),
              ),
              // Puedes mostrar más detalles del usuario aquí dentro de Card
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF29DA81), // Color personalizado
        currentIndex: 0,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pop(context);
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
