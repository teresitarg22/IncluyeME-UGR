
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AlumnoRegistration extends StatefulWidget {
  @override
  _AlumnoRegistrationState createState() => _AlumnoRegistrationState();
}

class _AlumnoRegistrationState extends State<AlumnoRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  /*String? _selectedDiscapacidad;
  String? _selectedTipo;
  String? _selectedNecesidad;*/
  String? _selectedFont;
  String? _selectedTamanio;
  String? _selectedRelacion;

  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  TextEditingController _historialMedicoController = TextEditingController();
  File? _attachedFile;
  File? _image;
  String? _imageError;
  bool? _isTactil = false;

  List<String> availableFonts = GoogleFonts.asMap().keys.toList();
  List<String> selectedOptions =
      []; // Lista para rastrear opciones seleccionadas
  List<String> options = [
    "Opción 1",
    "Opción 2",
    "Opción 3",
    "Opción 4",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Alumno'),
      ),
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
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Apellido *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El apellido es obligatorio';
                    }
                    return null;
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
                  child: Text('Seleccionar Foto'),
                ),
                if (_imageError !=
                    null) // Muestra un mensaje de error si el campo está vacío
                  Text(
                    _imageError!,
                    style: TextStyle(color: Colors.red),
                  ),
                /* Padding(
                  padding: EdgeInsets.only(
                      top:
                          16.0), // Ajusta la cantidad de espacio superior según tus necesidades
                  child: Text(
                    'Discapacidad',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                    value: _selectedTipo,
                    onChanged: (value) {
                      setState(() {
                        _selectedTipo = value;
                      });
                    },
                    items: ['Física', 'Visual', 'Auditiva', 'Cognitiva', 'Otro']
                        .map((tipo) => DropdownMenuItem<String>(
                              value: tipo,
                              child: Text(tipo),
                            ))
                        .toList(),
                    decoration:
                        InputDecoration(labelText: 'Tipo Discapacidad *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El tipo  es obligatorio';
                      }
                      return null;
                    }),
                if (_selectedTipo == 'Otro')
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El tipo de discapacidad es obligatorio';
                      }
                      return null;
                    },
                  ),
                DropdownButtonFormField<String>(
                    value: _selectedDiscapacidad,
                    onChanged: (value) {
                      setState(() {
                        _selectedDiscapacidad = value;
                      });
                    },
                    items: ['Leve', 'Moderado', 'Grave', 'Otro']
                        .map((discapacidad) => DropdownMenuItem<String>(
                              value: discapacidad,
                              child: Text(discapacidad),
                            ))
                        .toList(),
                    decoration:
                        InputDecoration(labelText: 'Grado Discapacidad *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El grado es obligatorio';
                      }
                      return null;
                    }),
                if (_selectedDiscapacidad == 'Otro')
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El grado de discapacidad es obligatorio';
                      }
                      return null;
                    },
                  ),
                DropdownButtonFormField<String>(
                    value: _selectedNecesidad,
                    onChanged: (value) {
                      setState(() {
                        _selectedNecesidad = value;
                      });
                    },
                    items: [
                      'Ninguna',
                      'Silla de Ruedas',
                      'Audifonos',
                      'Bastón de Movilidad',
                      'Asistencia para la Comunicación',
                      'Otro'
                    ]
                        .map((necesidad) => DropdownMenuItem<String>(
                              value: necesidad,
                              child: Text(necesidad),
                            ))
                        .toList(),
                    decoration:
                        InputDecoration(labelText: 'Necesidades Específicas *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La necesidad específica es obligatoria';
                      }
                      return null;
                    }),
                if (_selectedNecesidad == 'Otro')
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La necesidad específica es obligatoria';
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Información Adicional '),
                ),*/
                Padding(
                  padding: EdgeInsets.only(
                      top:
                          16.0), // Ajusta la cantidad de espacio superior según tus necesidades
                  child: Text(
                    'Historial Medico ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      _attachedFile = File(result.files.single.path!);
                      setState(() {
                        _historialMedicoController.text =
                            result.files.single.name;
                      });
                    }
                  },
                  child: Text('Adjuntar Archivo'),
                ),

                TextFormField(
                  controller: _historialMedicoController,
                  decoration: InputDecoration(labelText: 'Historial Médico'),
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Alergías o intolerancias '),
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Información Adicional '),
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
                    }),
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
                  value: _selectedGender,
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
                  ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nombre *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
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
                  decoration:
                      InputDecoration(labelText: 'Número de teléfono *'),
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Correo electrónico *'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Los datos son válidos, puedes procesar el registro.
                    }
                  },
                  child: Text('Registrarse'),
                ),
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

  Future<void> _pickFile() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _attachedFile = File(result.files.single.path!);
        });
      }
    } else {
      // El usuario denegó el permiso, puedes mostrar un mensaje de error o solicitar permisos nuevamente más tarde.
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