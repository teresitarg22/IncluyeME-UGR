import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:io';
import 'package:postgres/postgres.dart';
import 'package:convert/convert.dart';
import 'package:image/image.dart' as img;

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

class AlumnoRegistration extends StatefulWidget {
  @override
  _AlumnoRegistrationState createState() => _AlumnoRegistrationState();
}

class _AlumnoRegistrationState extends State<AlumnoRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedFont;
  String? _selectedTamanio;
  String? _selectedImage;
  var imageBytes;
  List<int>? imagenPrueba;
  File? mostrarImagen;

  File? _attachedFile;
  File? _image;
  String? _imageError;

  String? _nombre;
  String? _apellidos;
  String? _tipoLetra;
  String? _mayMin;
  String? _correoElectronicoAlumno;
  String? _contraseniaTexto;
  bool _sabeLeer = false;

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
          title: Text('Registro de Alumno'),
          backgroundColor: Color.fromARGB(255, 41, 218, 129)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Datos Personales', // Título "Datos Personales"
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nombre *'),
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
                  decoration: InputDecoration(labelText: 'Apellido *'),
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
                    Text(
                      'Foto *',
                      style: TextStyle(
                          fontSize: 16.0), // Aumenta el tamaño del texto
                    ),
                    SizedBox(
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
                        primary: Color(0xFF29DA81),
                      ),
                      child: Text('Elige una foto'),
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
                  decoration: InputDecoration(labelText: 'Tipo de Letra *'),
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
                  decoration:
                      InputDecoration(labelText: 'Mayúsculas / Minúsculas *'),
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
                  title: Text("Selecciona opciones"),
                  selectedColor: Colors.green,
                  buttonText: Text('Preferencias para mostrar el contenido'),
                  onConfirm: (values) {
                    setState(() {
                      selectedOptions = values;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top:
                          16.0), // Ajusta la cantidad de espacio superior según tus necesidades
                  child: Text(
                    'Información de inicio de sesión del alumno',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: Text('Sabe leer y escribir'),
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
                            decoration: InputDecoration(
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
                            decoration:
                                InputDecoration(labelText: 'Contraseña texto '),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El nombre es obligatorio ';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _contraseniaTexto =
                                  value; // Asignar el valor introducido a la variable
                            },
                          ),
                        ],
                      )
                    : MultiSelectDialogField(
                        items: multiSelectImagenes,
                        initialValue: selectedImages,
                        title: Text('Selecciona imágenes'),
                        buttonText: Text('Imágenes seleccionadas'),
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
                              SnackBar(
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

                        String checkQuery1 =
                            "SELECT * FROM estudiante WHERE nombre = '$_nombre' and apellidos = '$_apellidos'";
                        var result1 = await request(checkQuery1);

                        if (result1.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Ya existe una cuenta asociada a ese nombre.'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          String imagenesContrasenia = selectedImages.join(",");

                          List<int> imageBytes = _image!.readAsBytesSync();
                          String imageHex = hex.encode(imageBytes);

                          String query =
                              "INSERT INTO estudiante (nombre, apellidos, contrasenia_iconos, contrasenia, correo, foto, tipo_letra, maymin, formato, sabe_leer) VALUES ('$_nombre', '$_apellidos', '$imagenesContrasenia', '$_contraseniaTexto', '$_correoElectronicoAlumno',  E'\\\\x$imageHex',  '$_tipoLetra', '$_mayMin', '$selectedOptions', '$_sabeLeer')";
                          request(query);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(
                          0xFF29DA81), // Cambia el color del botón a verde
                    ),
                    child: Text('Registrarse'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _attachedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _imageError =
            null; // Resetea el mensaje de error cuando se selecciona una imagen
      });
    }
  }
}
