import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:postgres/postgres.dart';

import 'package:incluye_me/model/user.dart';
import 'package:incluye_me/model/estudiante.dart';

// -------------------------- DATA BASE --------------------------

// Create the connection as a global variable
final connection = PostgreSQLConnection(
  'flora.db.elephantsql.com', // database host
  5432, // database port
  'srvvjedp', // database nombre
  username: 'srvvjedp', // database usernombre
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
  final String nombre;
  final bool esEstudiante;

  EditUserPage({required this.nombre, required this.esEstudiante});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

// -----------------------------------------------------------

class _EditUserPageState extends State<EditUserPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();
  var resultado = [];
  User? user;

  // --------------------------------------------

  @override
  void initState() {
    user = null; // Inicializo los valores del usuario.

    super.initState();
    buscarDatosUsuario();
  }

  Future<void> buscarDatosUsuario() async {
    if (widget.esEstudiante == true) {
      resultado = await request(
          'SELECT * FROM estudiante WHERE nombre = \'${widget.nombre}\'');

      if (resultado.isNotEmpty) {
        setState(() {
          final detalles = resultado[0];

          user = Estudiante(
              nombre: detalles['nombre'],
              apellidos: detalles['apellidos'],
              correo: detalles['correo'],
              foto: detalles['foto'],
              contrasenia: detalles['contrasenia'],
              tipo_letra: detalles['tipo_letra'] ?? '',
              maymin: detalles['maymin'] ?? '',
              formato: detalles['formato'] ?? '',
              contrasenia_iconos: detalles['contrasenia_iconos'] ?? '',
              sabeLeer: detalles['sabeLeer'] ?? false);
        });
      }
    } else {
      resultado = await request(
          'SELECT * FROM personal WHERE nombre = \'${widget.nombre}\'');

      if (resultado.isNotEmpty) {
        setState(() {
          final detalles = resultado[0];

          user = User(
              nombre: detalles['nombre'] ?? '',
              apellidos: detalles['apellidos'] ?? '',
              correo: detalles['correo'] ?? '',
              foto: detalles['foto'] ?? '',
              contrasenia: detalles['contrasenia'] ?? '');
        });
      }
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
            'nombre': user?.nombre,
            'correo': user?.correo,
            'apellidos': user?.apellidos,
            'foto': user?.foto,
            'contrasenia': user?.contrasenia,
            //--------------------------------------
            // Campos adicionales para estudiantes
            'tipo_letra':
                (user is Estudiante) ? (user as Estudiante).tipo_letra : '',
            'maymin': (user is Estudiante) ? (user as Estudiante).maymin : '',
            'formato': (user is Estudiante) ? (user as Estudiante).formato : '',
            'contrasenia_iconos': (user is Estudiante)
                ? (user as Estudiante).contrasenia_iconos
                : '',
            'sabeLeer':
                (user is Estudiante) ? (user as Estudiante).sabeLeer : false,
          },
          child: ListView(
            children: <Widget>[
              // -----------------------------------------------------------
              const ListTile(
                title: Text(
                  'FORMULARIO DE EDICIÓN DE DATOS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 77, 131, 105),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              FormBuilderTextField(
                name: 'nombre',
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              FormBuilderTextField(
                name: 'apellidos',
                decoration: InputDecoration(labelText: 'Apellidos'),
              ),
              FormBuilderTextField(
                name: 'correo',
                decoration: InputDecoration(labelText: 'Correo'),
              ),
              FormBuilderTextField(
                name: 'contrasenia',
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
              FormBuilderTextField(
                name: 'foto',
                decoration: InputDecoration(labelText: 'Foto'),
              ),

              // Campos adicionales para estudiantes
              if (user is Estudiante) ...[
                FormBuilderTextField(
                  name: 'tipo_letra',
                  decoration: InputDecoration(labelText: 'Tipo de Letra'),
                ),
                FormBuilderTextField(
                  name: 'maymin',
                  decoration:
                      InputDecoration(labelText: 'Mayúsculas/Minúsculas'),
                ),
                FormBuilderTextField(
                  name: 'formato',
                  decoration: InputDecoration(labelText: 'Formato'),
                ),
                FormBuilderTextField(
                  name: 'contrasenia_iconos',
                  decoration:
                      InputDecoration(labelText: 'Contraseña de Iconos'),
                ),
                FormBuilderCheckbox(
                  name: 'sabeLeer',
                  title: Text('Sabe Leer'),
                ),
              ],
              Container(
                // -----------------------------------------------------------
                margin: EdgeInsets.only(top: 16.0), // Define el margen superior
                child: ElevatedButton(
                  onPressed: () {
                    if (_fbKey.currentState!.saveAndValidate()) {
                      // Guarda los datos actualizados en el objeto 'user' desde el formulario
                      user?.nombre =
                          _fbKey.currentState!.fields['nombre']?.value ??
                              user?.nombre;
                      user?.correo =
                          _fbKey.currentState!.fields['correo']?.value ??
                              user?.correo;
                      user?.apellidos =
                          _fbKey.currentState!.fields['apellidos']?.value ??
                              user?.apellidos;
                      user?.foto = _fbKey.currentState!.fields['foto']?.value ??
                          user?.foto;
                      user?.contrasenia =
                          _fbKey.currentState!.fields['contrasenia']?.value ??
                              user?.contrasenia;

                      //--------------------------------------
                      // Campos adicionales para estudiantes
                      if (user is Estudiante) {
                        var estudiante = user as Estudiante;

                        estudiante.tipo_letra =
                            _fbKey.currentState!.fields['tipo_letra']?.value ??
                                estudiante.tipo_letra;
                        estudiante.maymin =
                            _fbKey.currentState!.fields['maymin']?.value ??
                                estudiante.maymin;
                        estudiante.formato =
                            _fbKey.currentState!.fields['formato']?.value ??
                                estudiante.formato;
                        estudiante.contrasenia_iconos = _fbKey.currentState!
                                .fields['contrasenia_iconos']?.value ??
                            estudiante.contrasenia_iconos;
                        estudiante.sabeLeer =
                            _fbKey.currentState!.fields['sabeLeer']?.value ??
                                false;
                      }

                      // Aquí puedes realizar la lógica para guardar los cambios en la base de datos si es necesario

                      // Vuelve a la página de detalles del usuario con los datos actualizados
                      Navigator.of(context).pop(user);
                    }
                  },
                  // --------------------------------------------------
                  // Botón para guardar los cambios
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 98, 186, 142),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                  ),
                  child: Text('Guardar cambios'),
                ),
              ),
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
