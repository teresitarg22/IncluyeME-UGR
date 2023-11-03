import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:postgres/postgres.dart';

final connection = PostgreSQLConnection(
  'flora.db.elephantsql.com', // host de la base de datos
  5432, // puerto de la base de datos
  '', // nombre de la base de datos
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

class ProfesorRegistration extends StatefulWidget {
  @override
  _ProfesorRegistrationState createState() => _ProfesorRegistrationState();
}

class _ProfesorRegistrationState extends State<ProfesorRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedGenderProf;
  String? _selectedStudyLevel;
  String? _passwd = null;
  String? _confirmPasswd = null;
  bool? _isAdmin = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _selectedNacionalidad;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _dateControllerContratacion = TextEditingController();
  DateTime? _selectedDate;
  DateTime? _selectedDateContratacion;
  String? _otherNacionalidad; // Nueva

  //TextEditingController _cvController =
  //TextEditingController(); //CREO QUE NO SE UTILIZA
  File? _attachedFile;

  File? _image;
  String? _imageError;

  String? _nombre;
  String? _apellidos;
  String? _genero;
  String? _nacionalidad;
  String? _id;
  String? _tarjetaSanitaria;
  String? _direccionDomicilio;
  String? _nivelEstudios;
  String? _informacionAdicional;
  String? _puesto;
  String? _departamento;
  String? _numeroTlf;
  String? _correoElectronico;
  String? _tlfEmergencia;

  List<String> _titulosAcademicos =
      []; // Lista para almacenar los títulos académicos
  List<String> _certificadosAdicionales =
      []; // Lista para almacenar los certificados adicionales
  List<String> _experienciaLaboral =
      []; //Lista para almacenar la experiencia laboral
  List<String> _aulasProfesor = [];

  /*List<String> nacionalidades = [
    'España',
    'Francia',
    'Italia',
    'Portugal',
    'Estados Unidos',
    'Reino Unido',
    'Irlanda',
    'Otro'
  ];*/

/*  Map<String, String> banderas = {
    'España': 'assets/espana.png',
    'Francia': 'assets/francia.png',
    'Italia': 'assets/italia.png',
    'Reino Unido': 'assets/uk.png',
    'Estados Unidos': 'assets/eeuu.png',
    'Irlanda': 'assets/irlanda.png',
    'Portugal': 'assets/portugal.png',
    'Otro': 'assets/desconocido.png'
  };*/

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Registro de Personal'),
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
                      return 'El nombre es obligatorio';
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
                      onPressed: () {
                        _pickImage(); // Llama a la función para seleccionar una imagen
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF29DA81),
                      ),
                      child: Text('Elige una foto'),
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
                          decoration:
                              InputDecoration(labelText: 'Aulas de Profesor '),
                          onChanged: (value) {
                            // Guardar el valor introducido en _aulasProfesor
                            setState(() {
                              _aulasProfesor[index] = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _aulasProfesor.removeAt(index); // Eliminar el aula
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _aulasProfesor.add(''); // Agregar un nuevo campo vacío
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF29DA81),
                  ),
                  child: Text('Añadir Aulas del Profesor'),
                ),

                Padding(
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
                    _correoElectronico =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
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

                    if (_confirmPasswd != null && _confirmPasswd != _passwd)
                      return 'Las contraseñas deben ser iguales';

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

                    if (_passwd != null && _confirmPasswd != _passwd)
                      return 'Las contraseñas deben ser iguales';

                    return null;
                  },
                  obscureText: !_showConfirmPassword,
                ),

                Padding(
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
                CheckboxListTile(
                  title: Text('Administrador'),
                  value:
                      _isAdmin, // Valor de la casilla de verificación (true o false)
                  onChanged: (bool? value) {
                    setState(() {
                      _isAdmin =
                          value; // Actualiza el valor de _isAdmin al marcar/desmarcar
                    });
                  },
                ),

                Align(
                  alignment: Alignment.center, // Centra el botón en el medio
                  child: ElevatedButton(
                    onPressed: () async {
                      // Hacer la función asíncrona
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(_selectedDate!);

                        // Verificar si el correo electrónico o el DNI ya existen
                        String checkQuery =
                            "SELECT * FROM supervisor WHERE dni = '$_id'";
                        String checkQuery2 =
                            "SELECT * FROM supervisor WHERE correoelectronico = '$_correoElectronico'";
                        var result = await request(checkQuery);
                        var result2 = await request(checkQuery2);
                        if (result.isNotEmpty) {
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
                        } else if (result2.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Ya existe una cuenta asociada a ese correo electronico.'),
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
                          String query =
                              "INSERT INTO supervisor (dni, genero, nombre, apellidos, fechanacimiento, contraseña, tarjetasanitaria, direcciondomiciliar, nacionalidad, numerotelefono, numerotelefonoemergencia, correoelectronico, foto, nivelestudios, tituloacademico, experiencialaboralprevia, certificacionesadicionales, curriculumvitae, informacionacademicaadicional, puesto, fechacontratacion, departamento, admin) VALUES ('$_id', '$_genero', '$_nombre', '$_apellidos', '$formattedDate', '$_passwd', '$_tarjetaSanitaria', '$_direccionDomicilio', '$_nacionalidad', '$_numeroTlf', '$_tlfEmergencia', '$_correoElectronico', '$_image', '$_nivelEstudios', '$_titulosAcademicos', '$_experienciaLaboral', '$_certificadosAdicionales', '$_attachedFile', '$_informacionAdicional', '$_puesto', '$_selectedDateContratacion', '$_departamento', '$_isAdmin')";
                          request(query);
                          if (_aulasProfesor.isNotEmpty) {
                            for (var aula in _aulasProfesor) {
                              // Verificar si el aula ya existe
                              String checkAulaQuery =
                                  "SELECT * FROM aula WHERE nombre = '$aula'";
                              var aulaResult = await request(checkAulaQuery);
                              // Si el aula no existe, insertarla
                              if (aulaResult.isEmpty) {
                                String insertAulaQuery =
                                    "INSERT INTO aula (nombre) VALUES ('$aula')";
                                await request(insertAulaQuery);
                              }

                              String insertAulaProfesorQuery =
                                  "INSERT INTO imparte_en (nombre, dni) VALUES ('$aula', '$_id')";
                              await request(insertAulaProfesorQuery);
                            }
                          }
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _selectDateContratacion(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: _selectedDateContratacion ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;

    if (picked != null && picked != _selectedDateContratacion) {
      setState(() {
        _selectedDateContratacion = picked;
        _dateControllerContratacion.text =
            DateFormat('dd-MM-yyyy').format(picked);
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
