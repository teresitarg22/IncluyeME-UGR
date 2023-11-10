import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/registro_controller.dart';

class ProfesorRegistration extends StatefulWidget {
  const ProfesorRegistration({super.key});

  @override
  _ProfesorRegistrationState createState() => _ProfesorRegistrationState();
}

// --------------------------------------------------------

class _ProfesorRegistrationState extends State<ProfesorRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _passwd;
  String? _confirmPasswd;
  bool? _isAdmin = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  File? _image;
  String? _imageError;

  String? _nombre;
  String? _apellidos;
  String? _correoElectronico;

  final List<String> _aulasProfesor = [];

  final RegistroController _controlador = RegistroController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Registro de Personal'),
          backgroundColor: const Color.fromARGB(255, 41, 218, 129)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Datos Personales', // Título "Datos Personales"
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // --------------------------
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nombre =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                // --------------------------
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Apellido *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El apellido es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _apellidos =
                        value; // Asignar el valor introducido a la variable
                  },
                ),

                Row(
                  children: [
                    const Text(
                      'Foto *',
                      style: TextStyle(
                          fontSize: 16.0), // Aumenta el tamaño del texto
                    ),
                    const SizedBox(
                        width:
                            15.0), // Agrega espacio horizontal entre el texto y el botón
                    ElevatedButton(
                      onPressed: () {
                        _pickImage(); // Llama a la función para seleccionar una imagen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF29DA81),
                      ),
                      child: const Text('Elige una foto'),
                    ),
                  ],
                ),
                if (_image != null)
                  Image.file(_image!), // Muestra la imagen seleccionada

                ..._aulasProfesor.asMap().entries.map((entry) {
                  final int index = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: entry.value, // Mostrar el aula
                          decoration: const InputDecoration(
                              labelText: 'Aulas de Profesor '),
                          onChanged: (value) {
                            // Guardar el valor introducido en _aulasProfesor
                            setState(() {
                              _aulasProfesor[index] = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _aulasProfesor.removeAt(index); // Eliminar el aula
                          });
                        },
                      ),
                    ],
                  );
                }),
                // --------------------------
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _aulasProfesor.add(''); // Agregar un nuevo campo vacío
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29DA81),
                  ),
                  child: const Text('Añadir Aulas del Profesor'),
                ),

                const Padding(
                  padding: EdgeInsets.only(
                      top:
                          16.0), // Ajusta la cantidad de espacio superior según tus necesidades
                  child: Text(
                    'Información de seguridad y acceso',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // --------------------------
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Correo electrónico *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El correo electrónico es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _correoElectronico =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                // --------------------------
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña *',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña es obligatoria';
                    }

                    _passwd = value;

                    if (_confirmPasswd != null && _confirmPasswd != _passwd) {
                      return 'Las contraseñas deben ser iguales';
                    }

                    return null;
                  },
                  obscureText:
                      !_showPassword, // Mostrar u ocultar la contraseña según el estado.
                ),

                // --------------------------
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña *',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La confirmación de contraseña es obligatoria';
                    }

                    _confirmPasswd = value;

                    if (_passwd != null && _confirmPasswd != _passwd) {
                      return 'Las contraseñas deben ser iguales';
                    }

                    return null;
                  },
                  obscureText: !_showConfirmPassword,
                ),

                const Padding(
                  padding: EdgeInsets.only(
                      top:
                          16.0), // Ajusta la cantidad de espacio superior según tus necesidades
                  child: Text(
                    'Privilegios',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // --------------------------
                CheckboxListTile(
                  title: const Text('Administrador'),
                  value:
                      _isAdmin, // Valor de la casilla de verificación (true o false)
                  onChanged: (bool? value) {
                    setState(() {
                      _isAdmin =
                          value!; // Actualiza el valor de _isAdmin al marcar/desmarcar.
                    });
                  },
                ),

                Align(
                  alignment: Alignment.center, // Centra el botón en el medio.
                  child: ElevatedButton(
                    onPressed: () async {
                      // ----------------------------------------
                      // Hacer la función asíncrona.
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        var comprobacion1 = await _controlador
                            .comprobarPersonalController(_nombre!, _apellidos!);
                        var comprobacion2 = await _controlador
                            .comprobarPersonalCorreoController(
                                _correoElectronico!);
                        if (comprobacion1.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Ya existe una cuenta asociada a ese nombre .'),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          // --------------------------------------------------
                        } else if (comprobacion2.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Ya existe una cuenta asociada a ese correo electronico.'),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          // ----------------------------------------------
                        } else {
                          await _controlador.handleRegisterProfesor(
                              _nombre!,
                              _apellidos!,
                              _correoElectronico!,
                              _passwd!,
                              _image,
                              _isAdmin!,
                              _aulasProfesor);

                          // Mostrar un cuadro de diálogo:
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Registro exitoso'),
                                content: const Text(
                                    'El registro se ha completado con éxito.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Aceptar'),
                                    onPressed: () {
                                      _controlador
                                          .llevarMostrarUsuarios(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF29DA81),
                    ),
                    child: const Text('Registrarse'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _imageError =
            null; // Resetea el mensaje de error cuando se selecciona una imagen.
      });
    }
  }
}
