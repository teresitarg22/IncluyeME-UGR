import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:incluye_me/model/user.dart';

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

class EditUserPage extends StatefulWidget {
  final String userId;
  final bool isStudent;

  EditUserPage({required this.userId, required this.isStudent});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

// -----------------------------------------------------------

class _EditUserPageState extends State<EditUserPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();
  Map<String, dynamic> details = {};
  User? user;

  // --------------------------------

  @override
  void initState() {
    super.initState();

    // Realizar una consulta a la base de datos para obtener los detalles del usuario
    fetchUserDetails();
  }

  // --------------------------------
  // Buscar detalles del usuario en la base de datos
  void fetchUserDetails() async {
    final results =
        await request('SELECT * FROM student WHERE dni = ${widget.userId}');

    if (results.isNotEmpty) {
      setState(() {
        details = results[0];
        user = User(
          dni: details['dni'] ?? '',
          gender: details['genero'] ?? '',
          name: details['nombre'] ?? '',
          lastName: details['apellidos'] ?? '',
          dateOfBirth: details['fechanacimiento'] ?? '',
          password: details['"contraseña"'] ?? '',
          healthCard: details['tarjetasanitaria'] ?? '',
          homeAddress: details['direcciondomiciliar'] ?? '',
          phone: details['numerotelefono'] ?? '',
          email: details['correoelectronico'] ?? '',
          photo: details['foto'] ?? '',
          medicalRecord: details['archivomedico'] ?? '',
          allergiesIntolerances: details['alergiasintolerancias'] ?? '',
          additionalMedicalInformation:
              details['informacionadicionalmedico'] ?? '',
          fontType: details['tipodeletra'] ?? '',
          fontSize: details['minmay'] ?? '',
          appFormat: details['formatodeapp'] ?? '',
          touchscreen: details['pantallatactil'] ?? false,
          tutorDni: details['dni_tutor'] ?? '',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
        backgroundColor: Color(0xFF29DA81),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _fbKey,
          initialValue: {
            'name': user?.name, // Asigna el nombre del usuario desde 'user'
            'email': user?.email, // Asigna el email del usuario desde 'user'
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // -----------------------------------------------------------
              ListTile(
                title: Text('Name: ${user?.name ?? ''}'),
                subtitle: Text('Email: ${user?.email ?? ''}'),
              ),
              Divider(),
              FormBuilderTextField(
                name: 'name',
                decoration: InputDecoration(labelText: 'Name'),
              ),
              FormBuilderTextField(
                name: 'email',
                decoration: InputDecoration(labelText: 'Email'),
              ),
              Container(
                // -----------------------------------------------------------
                margin: EdgeInsets.only(top: 16.0), // Define el margen superior
                child: ElevatedButton(
                  onPressed: () {
                    if (_fbKey.currentState!.saveAndValidate()) {
                      // Guarda los datos actualizados en el objeto 'user' desde el formulario
                      user?.name = _fbKey.currentState!.fields['name']?.value ??
                          user?.name;
                      user?.email =
                          _fbKey.currentState!.fields['email']?.value ??
                              user?.email;

                      // Aquí puedes realizar la lógica para guardar los cambios en la base de datos si es necesario

                      // Vuelve a la página de detalles del usuario con los datos actualizados
                      Navigator.of(context).pop(user);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF29DA81),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                  ),
                  child: Text('Save Changes'),
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
