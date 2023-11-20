import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:io';
import 'package:convert/convert.dart';
import '../controllers/registro_controller.dart';

class AlumnoRegistration extends StatefulWidget {
  const AlumnoRegistration({super.key});

  @override
  _AlumnoRegistrationState createState() => _AlumnoRegistrationState();
}

class _AlumnoRegistrationState extends State<AlumnoRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedFont;
  String? _selectedTamanio;
  var imageBytes;
  List<int>? imagenPrueba;
  File? mostrarImagen;

  File? _image;
  String? _nombre;
  String? _apellidos;
  String? _tipoLetra;
  String? _mayMin;
  String? _correoElectronicoAlumno;
  String? _passwd;
  String? _confirmPasswd;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _sabeLeer = false;
  RegistroController controlador = RegistroController();

  List<String> availableFonts = GoogleFonts.asMap().keys.toList();
  List<String> selectedOptions = []; //FORMATO DE LA APP.
  List<String> selectedImages = []; //CONTRASEÑA

  List<MultiSelectItem<String>> multiSelectOptions = [
    MultiSelectItem("Pictograma", "Pictograma"),
    MultiSelectItem("Audio", "Audio"),
    MultiSelectItem("Imagen", "Imagen"),
    MultiSelectItem("Video", "Video"),
    MultiSelectItem("Dibujo", "Dibujo"),
    MultiSelectItem("Texto", "Texto"),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Registro de Alumno'),
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
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es obligatorio ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nombre =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
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
                      onPressed: () async {
                        _pickImage(); // Llama a la función para seleccionar una imagen
                        /* String imageQuery =
                            "SELECT foto FROM estudiante WHERE nombre = '$_nombre' and apellidos = '$_apellidos'";
                        imageBytes = await request(imageQuery);
                        if (imageBytes.first[0] != null) {
                          imagenPrueba = imageBytes.first[0] as List<int>;
                        }
                        img.Image? niIdea = img.decodeImage(imagenPrueba!);
                        mostrarImagen = new File('hola.pg')
                          ..writeAsBytesSync(img.encodePng(niIdea!));*/
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF29DA81),
                      ),
                      child: const Text('Elige una foto'),
                    ),
                  ],
                ),
                if (_image != null) Image.file(_image!),
                if (mostrarImagen != null) Image.file(mostrarImagen!),
                /*Image.file(_image!),
                  String sacarimagen = "SELECT foto FROM estudiante WHERE dni = 'nuevo1'",*/

                DropdownButtonFormField<String>(
                  value: _selectedFont,
                  onChanged: (value) {
                    setState(() {
                      _selectedFont = value;
                    });
                  },
                  items: availableFonts
                      .map((font) => DropdownMenuItem<String>(
                            value: font,
                            child: Text(font),
                          ))
                      .toList(),
                  decoration:
                      const InputDecoration(labelText: 'Tipo de Letra *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El tipo de letra es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _tipoLetra =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedTamanio,
                  onChanged: (value) {
                    setState(() {
                      _selectedTamanio = value;
                    });
                  },
                  items: ['Mayúscula', 'Minúscula']
                      .map((tamanio) => DropdownMenuItem<String>(
                            value: tamanio,
                            child: Text(tamanio),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                      labelText: 'Mayúsculas / Minúsculas *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La selección es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _mayMin =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                MultiSelectDialogField<String>(
                  items: multiSelectOptions,
                  initialValue: selectedOptions,
                  title: const Text("Selecciona opciones"),
                  selectedColor: Colors.green,
                  buttonText:
                      const Text('Preferencias para mostrar el contenido'),
                  onConfirm: (values) {
                    setState(() {
                      selectedOptions = values;
                    });
                  },
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
                CheckboxListTile(
                  title: const Text('Sabe leer y escribir'),
                  value:
                      _sabeLeer, // Valor de la casilla de verificación (true o false)
                  onChanged: (bool? value) {
                    setState(() {
                      _sabeLeer =
                          value!; // Actualiza el valor de _sabeLeer al marcar/desmarcar
                    });
                  },
                ),
                _sabeLeer
                    ? Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Correo electrónico '),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El nombre es obligatorio ';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _correoElectronicoAlumno =
                                  value; // Asignar el valor introducido a la variable
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Contraseña *',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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

                              if (_confirmPasswd != null &&
                                  _confirmPasswd != _passwd) {
                                return 'Las contraseñas deben ser iguales';
                              }

                              return null;
                            },
                            obscureText:
                                !_showPassword, // Mostrar u ocultar la contraseña según el estado
                          ),
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
                                    _showConfirmPassword =
                                        !_showConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'La confirmación de contraseña es obligatoria';
                              }

                              _confirmPasswd = value;

                              if (_passwd != null &&
                                  _confirmPasswd != _passwd) {
                                return 'Las contraseñas deben ser iguales';
                              }

                              return null;
                            },
                            obscureText: !_showConfirmPassword,
                          ),
                        ],
                      )
                    : MultiSelectDialogField(
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
                Align(
                  alignment: Alignment.center, // Centra el botón en el medio
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        var comprobacion =
                            await controlador.comprobarEstudianteController(
                                _nombre!, _apellidos!);

                        if (comprobacion!.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Ya existe una cuenta asociada a ese nombre.'),
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
                        } else {
                          List<int> imageBytes = _image!.readAsBytesSync();
                          String imageHex = hex.encode(imageBytes);

                          await controlador.handleRegister(
                            _nombre!,
                            _apellidos!,
                            selectedImages.join(","),
                            _passwd,
                            _correoElectronicoAlumno,
                            imageHex,
                            _tipoLetra!,
                            _mayMin!,
                            selectedOptions.join(","),
                            _sabeLeer,
                          );

                          // Mostrar un cuadro de diálogo
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
                                      controlador
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
                      backgroundColor: const Color(
                          0xFF29DA81), // Cambia el color del botón a verde
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

  // ---------------------------------------------------
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
}
