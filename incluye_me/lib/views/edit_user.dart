import 'package:flutter/material.dart';
import 'package:incluye_me/model/estudiante.dart';
import 'package:postgres/postgres.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:incluye_me/model/user.dart';
import './mostrar_usuario.dart';
import './user_list.dart';
import '../controllers/usuario_controller.dart';

class EditUserPage extends StatefulWidget {
  final String nombre;
  final String apellidos;
  final bool esEstudiante;
  final String userName;
  final String userSurname;

  const EditUserPage(
      {super.key,
      required this.nombre,
      required this.apellidos,
      required this.esEstudiante,
      required this.userName,
      required this.userSurname});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

// -----------------------------------------------------------

class _EditUserPageState extends State<EditUserPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();
  Controller controlador = Controller();
  var resultado;
  Future<User>? userFuture;
  User? user;

  // ------------------------

  @override
  void initState() {
    super.initState();
    userFuture = buscarDatosUsuario();
  }

  Future<User> buscarDatosUsuario() async {
    if (widget.esEstudiante == true) {
      resultado =
          await controlador.getEstudiante(widget.nombre, widget.apellidos);

      if (resultado.isNotEmpty) {
        setState(() {
          final detalles = resultado[0]['estudiante'];

          user = Estudiante(
              nombre: detalles['nombre'],
              apellidos: detalles['apellidos'],
              correo: detalles['correo'],
              foto: " ",
              contrasenia: detalles['contrasenia'],
              tipo_letra: detalles['tipo_letra'] ?? '',
              maymin: detalles['maymin'] ?? '',
              formato: detalles['formato'] ?? '',
              contrasenia_iconos: detalles['contrasenia_iconos'] ?? '',
              sabeLeer: detalles['sabeLeer'] ?? false);
        });
      }
    } else {
      resultado =
          await controlador.getPersonal(widget.nombre, widget.apellidos);
      ;

      if (resultado.isNotEmpty) {
        setState(() {
          final detalles = resultado[0]['personal'];

          user = User(
              nombre: detalles['nombre'],
              apellidos: detalles['apellidos'],
              correo: detalles['correo'],
              foto: " ",
              contrasenia: detalles['contrasenia']);
        });
      }
    }

    return user!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit User'),
              backgroundColor: const Color(0xFF29DA81),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                // key: _fbKey,
                initialValue: {
                  'nombre': user?.nombre,
                  'correo': user?.correo,
                  'apellidos': user?.apellidos,
                  'foto': user?.foto,
                  'contrasenia': user?.contrasenia,
                  //--------------------------------------
                  // Campos adicionales para estudiantes
                  'tipo_letra': (user is Estudiante)
                      ? (user as Estudiante).tipo_letra
                      : '',
                  'maymin':
                      (user is Estudiante) ? (user as Estudiante).maymin : '',
                  'formato':
                      (user is Estudiante) ? (user as Estudiante).formato : '',
                  'contrasenia_iconos': (user is Estudiante)
                      ? (user as Estudiante).contrasenia_iconos
                      : '',
                  'sabeLeer': (user is Estudiante)
                      ? (user as Estudiante).sabeLeer
                      : false,
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
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    FormBuilderTextField(
                      name: 'apellidos',
                      decoration: const InputDecoration(labelText: 'Apellidos'),
                    ),
                    FormBuilderTextField(
                      name: 'correo',
                      decoration: const InputDecoration(labelText: 'Correo'),
                    ),
                    FormBuilderTextField(
                      name: 'contrasenia',
                      decoration:
                          const InputDecoration(labelText: 'Contraseña'),
                    ),
                    FormBuilderTextField(
                      name: 'foto',
                      decoration: const InputDecoration(labelText: 'Foto'),
                    ),

                    // Campos adicionales para estudiantes
                    if (user is Estudiante) ...[
                      FormBuilderTextField(
                        name: 'tipo_letra',
                        decoration:
                            const InputDecoration(labelText: 'Tipo de Letra'),
                      ),
                      FormBuilderTextField(
                        name: 'maymin',
                        decoration: const InputDecoration(
                            labelText: 'Mayúsculas/Minúsculas'),
                      ),
                      FormBuilderTextField(
                        name: 'formato',
                        decoration: const InputDecoration(labelText: 'Formato'),
                      ),
                      FormBuilderTextField(
                        name: 'contrasenia_iconos',
                        decoration: const InputDecoration(
                            labelText: 'Contraseña de Iconos'),
                      ),
                      FormBuilderCheckbox(
                        name: 'sabeLeer',
                        title: const Text('Sabe Leer'),
                      ),
                    ],
                    Container(
                      // -----------------------------------------------------------
                      margin: const EdgeInsets.only(
                          top: 16.0), // Define el margen superior
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
                            user?.apellidos = _fbKey
                                    .currentState!.fields['apellidos']?.value ??
                                user?.apellidos;
                            user?.foto =
                                _fbKey.currentState!.fields['foto']?.value ??
                                    user?.foto;
                            user?.contrasenia = _fbKey.currentState!
                                    .fields['contrasenia']?.value ??
                                user?.contrasenia;

                            //--------------------------------------
                            // Campos adicionales para estudiantes
                            if (user is Estudiante) {
                              var estudiante = user as Estudiante;

                              estudiante.tipo_letra = _fbKey.currentState!
                                      .fields['tipo_letra']?.value ??
                                  estudiante.tipo_letra;
                              estudiante.maymin = _fbKey
                                      .currentState!.fields['maymin']?.value ??
                                  estudiante.maymin;
                              estudiante.formato = _fbKey
                                      .currentState!.fields['formato']?.value ??
                                  estudiante.formato;
                              estudiante.contrasenia_iconos = _fbKey
                                      .currentState!
                                      .fields['contrasenia_iconos']
                                      ?.value ??
                                  estudiante.contrasenia_iconos;
                              estudiante.sabeLeer = _fbKey.currentState!
                                      .fields['sabeLeer']?.value ??
                                  false;
                            }

                            // Aquí puedes realizar la lógica para guardar los cambios en la base de datos si es necesario

                            // Vuelve a la página de detalles del usuario con los datos actualizados
                            Navigator.of(context).pop(user);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 98, 186, 142),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(16.0),
                        ),
                        child: const Text('Guardar cambios'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color(0xFF29DA81), // Color personalizado
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
                      userName: widget.userName,
                      userSurname: widget.userSurname,
                    );
                  }));
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
      },
    );
  }
}
