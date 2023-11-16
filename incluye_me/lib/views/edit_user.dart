import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:incluye_me/model/user.dart';
import 'package:incluye_me/model/estudiante.dart';
import './mostrar_usuario.dart';
import './user_list.dart';
import '../controllers/usuario_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
  List<String> availableFonts = GoogleFonts.asMap().keys.toList();

  List<MultiSelectItem<String>> multiSelectOptions = [
    MultiSelectItem("Pictograma", "Pictograma"),
    MultiSelectItem("Audio", "Audio"),
    MultiSelectItem("Imagen", "Imagen"),
    MultiSelectItem("Video", "Video"),
    MultiSelectItem("Dibujo", "Dibujo"),
    MultiSelectItem("Texto", "Texto"),
  ];

  List<String> selectedOptions = [];
  List<String> selectedImages = []; //CONTRASEÑA

  List<MultiSelectItem<String>> multiSelectImagenes = [
    MultiSelectItem("../assets/symbol0.png", "Balón"),
    MultiSelectItem("../assets/symbol8.png", "Martillo"),
    MultiSelectItem("../assets/symbol5.png", "Raqueta"),
    MultiSelectItem("../assets/symbol2.png", "Teléfono"),
    MultiSelectItem("../assets/symbol3.png", "Silla"),
    MultiSelectItem("../assets/symbol6.png", "Oso"),
    MultiSelectItem("../assets/symbol7.png", "Hamburguesa"),
    MultiSelectItem("../assets/symbol4.png", "Reloj"),
    MultiSelectItem("../assets/symbol1.png", "Casa"),
  ];

  Map<int, String> mapaImagenes = {
    0: '../assets/symbol0.png',
    1: '../assets/symbol1.png',
    2: '../assets/symbol2.png',
    3: '../assets/symbol3.png',
    4: '../assets/symbol4.png',
    5: '../assets/symbol5.png',
    6: '../assets/symbol6.png',
    7: '../assets/symbol7.png',
    8: '../assets/symbol8.png',
  };

  // ------------------------

  @override
  void initState() {
    super.initState();
    userFuture = buscarDatosUsuario();
  }

  // ------------------------------------------------------------------------------------
  // Buscamos los datos del usuario en la BD, teniendo en cuenta si es estudiante o no.
  Future<User> buscarDatosUsuario() async {
    if (widget.esEstudiante == true) {
      // --------------------------
      // ESTUDIANTE
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
              sabeLeer: detalles['sabe_leer'] ?? false);

          if (detalles['formato'] != "") {
            selectedOptions = detalles['formato']
                .substring(1, detalles['formato'].length - 1)
                .split(', ');
          }
          if (detalles['contrasenia_iconos'] != "") {
            List<String> keys = detalles['contrasenia_iconos']?.split(',');
            for (var key in keys) {
              selectedImages.add(mapaImagenes[int.parse(key)]!);
            }
          }
        });
      }
    } else {
      // --------------------------
      // PERSONAL
      resultado =
          await controlador.getPersonal(widget.nombre, widget.apellidos);

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

  // -------------------------------------------
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
                    // --------------------------
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
                      FormBuilderDropdown(
                        name: 'tipo_letra',
                        decoration: InputDecoration(labelText: 'Tipo de Letra'),
                        items: availableFonts
                            .map((option) => DropdownMenuItem(
                                value: option, child: Text("$option")))
                            .toList(),
                      ),
                      FormBuilderDropdown(
                        name: 'maymin',
                        decoration: const InputDecoration(
                            labelText: 'Mayúsculas/Minúsculas'),
                        items: ['Mayúscula', 'Minúscula']
                            .map((option) => DropdownMenuItem(
                                value: option, child: Text("$option")))
                            .toList(),
                      ),
                      MultiSelectDialogField<String>(
                        items: multiSelectOptions,
                        initialValue: selectedOptions,
                        title: const Text("Selecciona opciones"),
                        selectedColor: Colors.green,
                        buttonText: const Text(
                            'Preferencias para mostrar el contenido'),
                        onConfirm: (values) {
                          setState(() {
                            selectedOptions = values;
                          });
                        },
                      ),
                      MultiSelectDialogField(
                        items: multiSelectImagenes,
                        initialValue: selectedImages,
                        title: const Text('Selecciona imágenes'),
                        buttonText: const Text('Imágenes seleccionadas'),
                        onConfirm: (values) {
                          if (values.length == 3) {
                            setState(() {
                              selectedImages.add(mapaImagenes.entries
                                  .firstWhere(
                                      (entry) => entry.value == values[0])
                                  .key
                                  .toString());
                              selectedImages.add(mapaImagenes.entries
                                  .firstWhere(
                                      (entry) => entry.value == values[1])
                                  .key
                                  .toString());
                              selectedImages.add(mapaImagenes.entries
                                  .firstWhere(
                                      (entry) => entry.value == values[2])
                                  .key
                                  .toString());
                            });
                          } else {
                            values.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('TIENES QUE SELECCIONAR 3 ELEMENTOS'),
                              ),
                            );
                          }
                        },
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

                            // Vuelve a la página de detalles del usuario con los datos actualizados.
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
