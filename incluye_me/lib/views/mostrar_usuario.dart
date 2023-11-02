import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

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

class UserDetailsPage extends StatefulWidget {
  String userId;
  bool esEstudiante;
  UserDetailsPage({required this.userId, required this.esEstudiante});
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}


class _UserDetailsPageState extends State<UserDetailsPage> {
  var usuario = [];

  if(esEstudiante){
    usuario = await request("Select * from estudiante where dni = $userId");
  }else{
    usuario = await request("Select * from supervisor where dni = $userId");
  }

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
                  usuario['nombre'],
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
                      usuario.email,
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF29DA81), // Color personalizado
        currentIndex: 0,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/userList');
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
