import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:io';
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

class AlumnoRegistration extends StatefulWidget {
  @override
  _AlumnoRegistrationState createState() => _AlumnoRegistrationState();
}

class _AlumnoRegistrationState extends State<AlumnoRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  String? _selectedGenderTutor;
  /*String? _selectedDiscapacidad;
  String? _selectedTipo;
  String? _selectedNecesidad;*/
  String? _selectedFont;
  String? _selectedTamanio;
  String? _selectedRelacion;
  String? _selectedImage;

  TextEditingController _dateControllerAlumno = TextEditingController();
  DateTime? _selectedDateAlumno;
  //TextEditingController _historialMedicoController = TextEditingController();
  File? _attachedFile;
  File? _image;
  String? _imageError;
  bool? _isTactil = false;

  String? _nombre;
  String? _apellidos;
  String? _genero;
  String? _id;
  String? _tarjetaSanitaria;
  String? _direccionDomicilio;
  String? _informacionAdicional;
  String? _alergias;
  String? _tipoLetra;
  String? _mayMin;
  String? _numeroTlfAlumno;
  String? _correoElectronicoAlumno;

  String? _nombreTutor;
  String? _apellidosTutor;
  String? _relacionAlumnoTutor;
  String? _generoTutor;
  String? _idTutor;
  String? _direccionDomicilioTutor;
  String? _numeroTlfTutor;
  String? _correoElectronicoTutor;
  String? _tlfEmergencia;

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
                TextFormField(
                  controller: _dateControllerAlumno,
                  decoration: InputDecoration(
                    labelText: 'Fecha de Nacimiento *',
                  ),
                  validator: (value) {
                    if (_selectedDateAlumno == null) {
                      return 'La fecha de nacimiento es obligatoria';
                    }
                    return null;
                  },
                  onTap: () {
                    _selectDateAlumno(context);
                  },
                  readOnly: true,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  items: ['Hombre', 'Mujer', 'Otro']
                      .map((gender) => DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Género *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El género es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _genero =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                if (_selectedGender == 'Otro')
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Género *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El genero es obligatorio';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _genero =
                          value; // Asignar el valor introducido a la variable
                    },
                  ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Dirección del domiciio *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La dirección es obligatoria';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _direccionDomicilio =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Documento de Identificación *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El documento de identificación es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _id = value; // Asignar el valor introducido a la variable
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Número de Seguridad Social *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El número de seguridad social es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _tarjetaSanitaria =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top:
                          16.0), // Ajusta la cantidad de espacio superior según tus necesidades
                  child: Text(
                    'Foto',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_image != null)
                  Image.file(_image!), // Muestra la imagen seleccionada
                ElevatedButton(
                  onPressed: () {
                    _pickImage(); // Llama a la función para seleccionar una imagen
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF29DA81),
                  ),
                  child: Text('Seleccionar Foto'),
                ),
                if (_imageError !=
                    null) // Muestra un mensaje de error si el campo está vacío
                  Text(
                    _imageError!,
                    style: TextStyle(color: Colors.red),
                  ),

                Padding(
                  padding: EdgeInsets.only(
                      top:
                          16.0), // Ajusta la cantidad de espacio superior según tus necesidades
                  child: Text(
                    'Historial Médico',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _pickFile(); // Abre el selector de archivos
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF29DA81),
                  ),
                  child: Text('Añadir historial médico'),
                ),
                if (_attachedFile != null)
                  Text('Archivo adjunto: ${_attachedFile!.path}'),

                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Alergías o intolerancias '),
                  onSaved: (value) {
                    _alergias =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Información Adicional '),
                  onSaved: (value) {
                    _informacionAdicional =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top:
                          16.0), // Ajusta la cantidad de espacio superior según tus necesidades
                  child: Text(
                    'Accesibilidad',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

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
                  items: ['Mayuscula', 'Miniscula']
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
                CheckboxListTile(
                  title: Text('Uso de pantalla táctil'),
                  value:
                      _isTactil, // Valor de la casilla de verificación (true o false)
                  onChanged: (bool? value) {
                    setState(() {
                      _isTactil =
                          value; // Actualiza el valor de _isAdmin al marcar/desmarcar
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top:
                          16.0), // Ajusta la cantidad de espacio superior según tus necesidades
                  child: Text(
                    'Información de contacto del tutor legal',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedRelacion,
                  onChanged: (value) {
                    setState(() {
                      _selectedRelacion = value;
                    });
                  },
                  items: ['Madre', 'Padre', 'Otro']
                      .map((relacion) => DropdownMenuItem<String>(
                            value: relacion,
                            child: Text(relacion),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                      labelText: 'Relación entre el tutor y el alumno *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La relación es obligatoria';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _relacionAlumnoTutor =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                if (_selectedRelacion == 'Otro')
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Relación entre el tutor y el alumno *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La relación es obligatoria';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _relacionAlumnoTutor =
                          value; // Asignar el valor introducido a la variable
                    },
                  ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nombre *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nombreTutor =
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
                    _apellidosTutor =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedGenderTutor,
                  onChanged: (value) {
                    setState(() {
                      _selectedGenderTutor = value;
                    });
                  },
                  items: ['Hombre', 'Mujer', 'Otro']
                      .map((gender) => DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Género *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El género es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _generoTutor =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                if (_selectedGenderTutor == 'Otro')
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Género *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El genero es obligatorio';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _generoTutor =
                          value; // Asignar el valor introducido a la variable
                    },
                  ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Dirección del domiciio *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La dirección es obligatoria';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _direccionDomicilioTutor =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Documento de Identificación *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El documento de identificación es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _idTutor =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Número de teléfono *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El número de teléfono es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _numeroTlfTutor =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Correo electrónico *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El correo electrónico es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _correoElectronicoTutor =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText:
                          'Contacto de emergencia (número de teléfono) *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El contacto de emergencia es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _tlfEmergencia =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top:
                          16.0), // Ajusta la cantidad de espacio superior según tus necesidades
                  child: Text(
                    'Información de contacto del alumno',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Número de teléfono '),
                  onSaved: (value) {
                    _numeroTlfAlumno =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Correo electrónico '),
                  onSaved: (value) {
                    _correoElectronicoAlumno =
                        value; // Asignar el valor introducido a la variable
                  },
                ),

                MultiSelectDialogField(
                  items: multiSelectImagenes,
                  initialValue: selectedImages,
                  title: Text('Selecciona imágenes'),
                  buttonText: Text('Imágenes seleccionadas'),
                  onConfirm: (values) {
                    if (values.length == 3) {
                      setState(() {
                        selectedImages.add(mapaImagenes.entries
                            .firstWhere((entry) => entry.value == values[0])
                            .key
                            .toString());
                        selectedImages.add(mapaImagenes.entries
                            .firstWhere((entry) => entry.value == values[1])
                            .key
                            .toString());
                        selectedImages.add(mapaImagenes.entries
                            .firstWhere((entry) => entry.value == values[2])
                            .key
                            .toString());
                      });
                    } else {
                      values.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('TIENES QUE SELECCIONAR 3 ELEMENTOS'),
                        ),
                      );
                    }
                  },
                ),
                /*SizedBox(height: 20), // Espacio entre el menú y otros elementos
                Text(
                  'Imágenes seleccionadas:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),*/
                /* Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: selectedImages.map((option) {
                    return Image.asset(
                      option,
                      width: 50, // Tamaño de la imagen
                      height: 50,
                    );
                  }).toList(),
                ),*/

                Align(
                  alignment: Alignment.center, // Centra el botón en el medio
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String formattedDate = DateFormat('yyyy-MM-dd')
                            .format(_selectedDateAlumno!);

                        String checkQuery1 =
                            "SELECT * FROM estudiante WHERE dni = '$_id'";
                        var result1 = await request(checkQuery1);

                        if (result1.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Ya existe una cuenta asociada a ese DNI.'),
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
                          String checkQuery2 =
                              "SELECT * FROM tutor_legal WHERE dni = '$_idTutor'";
                          var result2 = await request(checkQuery2);

                          if (result2.isEmpty) {
                            String query2 =
                                "INSERT INTO tutor_legal (dni, genero, nombre, apellidos, direcciondomiciliar, numerotelefono, correoelectronico, contactoemergencia, relacion) VALUES ('$_idTutor', '$_generoTutor', '$_nombreTutor', '$_apellidosTutor', '$_direccionDomicilioTutor', '$_numeroTlfTutor', '$_correoElectronicoTutor', '$_tlfEmergencia', '$_relacionAlumnoTutor')";
                            request(query2);
                          }

                          String prueba = selectedImages.join(",");

                          String query =
                              "INSERT INTO estudiante (dni, genero, nombre, apellidos, fechanacimiento, contraseña, tarjetasanitaria, direcciondomiciliar, numerotelefono, correoelectronico, foto, archivomedico, alergiasintolerancias, informacionadicionalmedico, tipodeletra, minmay, formatodeapp, pantallatactil, dnitutorlegal) VALUES ('$_id', '$_genero', '$_nombre', '$_apellidos', '$formattedDate', '$prueba', '$_tarjetaSanitaria', '$_direccionDomicilio', '$_numeroTlfAlumno', '$_correoElectronicoAlumno', '$_image', '$_attachedFile', '$_alergias', '$_informacionAdicional', '$_tipoLetra', '$_mayMin', '$selectedOptions', '$_isTactil', '$_idTutor')";
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

  Future<void> _selectDateAlumno(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: _selectedDateAlumno ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;

    if (picked != null && picked != _selectedDateAlumno) {
      setState(() {
        _selectedDateAlumno = picked;
        _dateControllerAlumno.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
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
