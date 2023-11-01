import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:postgres/postgres.dart';

Future<void> request(String query) async {
  final connection = PostgreSQLConnection(
    'flora.db.elephantsql.com', // host de la base de datos
    5432, // puerto de la base de datos
    'srvvjedp', // nombre de la base de datos
    username: 'srvvjedp', // nombre de usuario de la base de datos
    password:
        'tuZz6S15UozErJ7aROYQFR3ZcThFJ9MZ', // contraseña del usuario de la base de datos
  );

  try {
    await connection.open();
    print('Connected to the database');

    await connection.query(query);
  } catch (e) {
    print('Error: $e');
  } finally {
    //await connection.close();
    print('Connection closed');
  }
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

  List<String> nacionalidades = [
    'España',
    'Francia',
    'Italia',
    'Portugal',
    'Estados Unidos',
    'Reino Unido',
    'Irlanda',
    'Otro'
  ];

  Map<String, String> banderas = {
    'España': 'assets/espana.png',
    'Francia': 'assets/francia.png',
    'Italia': 'assets/italia.png',
    'Reino Unido': 'assets/uk.png',
    'Estados Unidos': 'assets/eeuu.png',
    'Irlanda': 'assets/irlanda.png',
    'Portugal': 'assets/portugal.png',
    'Otro' :  'assets/desconocido.png'
  };

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
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha de Nacimiento *',
                  ),
                  validator: (value) {
                    if (_selectedDate == null) {
                      return 'La fecha de nacimiento es obligatoria';
                    }
                    return null;
                  },
                  onTap: () {
                    _selectDate(context);
                  },
                  readOnly: true,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedGenderProf,
                  onChanged: (value) {
                    setState(() {
                      _selectedGenderProf = value;
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

                if (_selectedGenderProf == 'Otro')
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
                          value; // Reescribir el valor introducido a la variable
                    },
                  ),

                Row(
                  children: [
                    Text('Nacionalidad:'), 
                    SizedBox(
                        width:
                            20), // Espacio entre el texto y el botón desplegable
                    DropdownButton<String>(
                      value: _selectedNacionalidad,
                      onChanged: (value) {
                        setState(() {
                          _selectedNacionalidad = value;
                        });
                      },
                      items: nacionalidades.map((nacionalidad) {
                        return DropdownMenuItem<String>(
                          value: nacionalidad,
                          child: Row(
                            children: [
                              Image.asset(
                                banderas[
                                    nacionalidad]!, // Obtiene la ruta de la bandera
                                width: 32, // Ajusta el tamaño de la bandera
                                height: 20,
                              ),
                              SizedBox(
                                  width:
                                      8), // Espacio entre la bandera y el texto
                              Text(nacionalidad), // Nombre de la nacionalidad
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
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
                    'Información académica',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                DropdownButtonFormField<String>(
                  value: _selectedStudyLevel,
                  onChanged: (value) {
                    setState(() {
                      _selectedStudyLevel = value;
                    });
                  },
                  items: [
                    'Educación Preescolar',
                    'Educación Primaria',
                    'Educación Secundaria',
                    'Educación Técnica',
                    'Licenciatura',
                    'Maestría',
                    'Doctorado',
                    'Otro'
                  ]
                      .map((studyLevel) => DropdownMenuItem<String>(
                            value: studyLevel,
                            child: Text(studyLevel),
                          ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Nivel de estudios *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nivel de estudios es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nivelEstudios =
                        value; // Asignar el valor introducido a la variable
                  },
                ),

                if (_selectedStudyLevel == 'Otro')
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Nivel de estudios *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nivel de estudios es obligatorio';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nivelEstudios =
                          value; // Asignar el valor introducido a la variable
                    },
                  ),

                // Mapear la lista de títulos académicos en campos de entrada
                ..._titulosAcademicos.asMap().entries.map((entry) {
                  final int index = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue:
                              entry.value, // Mostrar el título existente
                          decoration:
                              InputDecoration(labelText: 'Título Académico *'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El título académico es obligatorio';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _titulosAcademicos.removeAt(
                                index); // Eliminar el título académico
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _titulosAcademicos
                          .add(''); // Agregar un nuevo campo vacío
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF29DA81),
                  ),
                  child: Text('Añadir Título Académico'),
                ),
                // Mapear la lista de certificados académicos adicionales en campos de entrada
                ..._certificadosAdicionales.asMap().entries.map((entry) {
                  final int index = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue:
                              entry.value, // Mostrar el título existente
                          decoration: InputDecoration(
                              labelText: 'Certificados adicionales '),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _certificadosAdicionales.removeAt(
                                index); // Eliminar el título académico
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _certificadosAdicionales
                          .add(''); // Agregar un nuevo campo vacío
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF29DA81),
                  ),
                  child: Text('Añadir Certificado Adicional'),
                ),
                // Mapear la lista de experiencia laboral en campos de entrada
                ..._experienciaLaboral.asMap().entries.map((entry) {
                  final int index = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue:
                              entry.value, // Mostrar la experiencia laboral
                          decoration: InputDecoration(
                              labelText: 'Experiencia laboral '),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _experienciaLaboral.removeAt(
                                index); // Eliminar la experiencia laboral
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _experienciaLaboral
                          .add(''); // Agregar un nuevo campo vacío
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF29DA81),
                  ),
                  child: Text('Añadir Experiencia Laboral'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _pickFile(); // Abre el selector de archivos
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF29DA81),
                  ),
                  child: Text('Añadir CV'),
                ),
                if (_attachedFile != null)
                  Text('Archivo adjunto: ${_attachedFile!.path}'),

                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Información adicional '),
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
                    'Información de empleo',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Puesto dentro del centro *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El puesto dentro del centro es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _puesto =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Departamento *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El departamento es obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _departamento =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                TextFormField(
                  controller: _dateControllerContratacion,
                  decoration: InputDecoration(
                    labelText: 'Fecha de contratación *',
                  ),
                  validator: (value) {
                    if (_selectedDateContratacion == null) {
                      return 'La fecha de contratación es obligatoria';
                    }
                    return null;
                  },
                  onTap: () {
                    _selectDateContratacion(context);
                  },
                  readOnly: true,
                ),
                ..._aulasProfesor.asMap().entries.map((entry) {
                  final int index = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue:
                              entry.value, // Mostrar la experiencia laboral
                          decoration:
                              InputDecoration(labelText: 'Aulas de Profesor '),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _aulasProfesor.removeAt(
                                index); // Eliminar la experiencia laboral
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
                    'Información de contacto',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                    _numeroTlf =
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
                    _correoElectronico =
                        value; // Asignar el valor introducido a la variable
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Número de teléfono de emergencia *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El número de teléfono de emergencia es obligatorio';
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
                    'Información de seguridad y acceso',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(_selectedDate!);
                        String query =
                            "INSERT INTO supervisor (dni, genero, nombre, apellidos, fechanacimiento, contraseña, tarjetasanitaria, direcciondomiciliar, nacionalidad, numerotelefono, numerotelefonoemergencia, correoelectronico, foto, nivelestudios, tituloacademico, experiencialaboralprevia, certificacionesadicionales, curriculumvitae, informacionacademicaadicional, puesto, fechacontratacion, departamento, admin) VALUES ('$_id', '$_genero', '$_nombre', '$_apellidos', '$formattedDate', '$_passwd', '$_tarjetaSanitaria', '$_direccionDomicilio', '$_nacionalidad', '$_numeroTlf', '$_tlfEmergencia', '$_correoElectronico', '$_image', '$_nivelEstudios', '$_titulosAcademicos', '$_experienciaLaboral', '$_certificadosAdicionales', '$_attachedFile', '$_informacionAdicional', '$_puesto', '$_selectedDateContratacion', '$_departamento', '$_isAdmin')";
                        request(query);
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
