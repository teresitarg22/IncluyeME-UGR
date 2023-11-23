import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:io';
import '../controllers/usuario_controller.dart';
import '../views/user_list.dart';
import '../views/home_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String user = "";
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => CreateTaskCommand(userName: "Sergio", userSurname: "Lopez"),
        '/registroPage': (context) => const HomeScreen(),
        '/userList': (context) =>
            UserListPage(userName: user, userSurname: user)
      },
    );
  }
}

class CreateTaskCommand extends StatefulWidget {
  final String userName;
  final String userSurname;
  const CreateTaskCommand({super.key, required this.userName, required this.userSurname});

  @override
  _CreateTaskCommandState createState() => _CreateTaskCommandState();
}

class _CreateTaskCommandState extends State<CreateTaskCommand> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _name;
  final _controller = TextEditingController();
  Controller controlador = Controller();
  List<DateTime> _dates = [];
  List<String> _students = [];
  String? _selectedOption;
  DateTime? _selectedDate;
  List<String> selectedOptions = [];
  TextEditingController _fechaController = TextEditingController();




  Future<void> loadUsers() async {
    for (var _student in await controlador.listaEstudiantes()) {
      _students.add(_student['estudiante']!['nombre'].toString() +
          " " +
          _student['estudiante']!['apellidos'].toString());
    }
  }

  List<MultiSelectItem<String>> multiSelectOptions = [
    MultiSelectItem("1", "Lunes"),
    MultiSelectItem("2", "Martes"),
    MultiSelectItem("3", "Miércoles"),
    MultiSelectItem("4", "Jueves"),
    MultiSelectItem("5", "Viernes"),
  ];


  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Asignar Tarea Comanda'),
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
                Padding(
                  padding: EdgeInsets.only(
                      top: 20), // Agrega espacio en la parte superior
                  child: Row(
                    children: [
                      Text(
                        'Estudiante: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                          width:
                              20), // Agrega espacio entre el texto y el campo de texto
                      Container(
                        width: 200, // Cambia el ancho del campo de texto aquí
                        child: TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _controller,
                          ),
                          suggestionsCallback: (pattern) {
                            return _students.where((option) => option
                                .toLowerCase()
                                .contains(pattern.toLowerCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            _controller.text = suggestion;
                            _name = suggestion ; 
                            FocusScope.of(context).unfocus();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El nombre es obligatorio ';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20), // Agrega espacio en la parte superior
                      child: Row(
                        children: [
                          Text(
                            'Frecuencia: ',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                              width:
                                  20), // Agrega espacio entre el texto y el campo de texto
                          Container(
                            width:
                                200, // Cambia el ancho del campo de texto aquí
                            child: DropdownButtonFormField<String>(
                              value: _selectedOption,
                              items: ['Semanal', 'Fecha concreta']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedOption = newValue;
                                });
                              },
                            ),
                          ),
                          if (_selectedOption == 'Semanal')
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20), // Agrega espacio a la izquierda
                              child: Container(
                                width:
                                    400, // Cambia el ancho del campo de texto aquí
                                child: MultiSelectDialogField<String>(
                                  items: multiSelectOptions,
                                  initialValue: selectedOptions,
                                  title: const Text("Selecciona opciones"),
                                  selectedColor: Colors.green,
                                  buttonText: const Text(
                                      'Elige el dia de la semana para la tarea'),
                                  onConfirm: (values) {
                                    setState(() {
                                      selectedOptions = values;
                                    });
                                    for (var dia in selectedOptions) {
                                      var fecha = fechasDelDiaDeLaSemana(
                                          int.parse(dia));
                                      for (var fechaDia in fecha) {
                                        _dates.add(fechaDia);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          if (_selectedOption == 'Fecha concreta')
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20), // Agrega espacio a la izquierda
                              child: Container(
                                width:
                                    200, // Cambia el ancho del campo de texto aquí
                                child: TextFormField(
                                  controller: _fechaController,
                                  decoration: InputDecoration(
                                    labelText: 'Fecha',
                                  ),
                                  onTap: () async {
                                    FocusScope.of(context).requestFocus(
                                        new FocusNode()); // para evitar que se muestre el teclado
                                    final DateTime? picked =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(
                                              Duration(days: 365),
                                            ));
                                    if (picked != null &&
                                        picked != _selectedDate) {
                                      _selectedDate = picked;
                                      _dates.add(_selectedDate!) ; 
                                      _fechaController.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(picked);
                                    }
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center, // Centra el botón en el medio
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Mostrar un cuadro de diálogo
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Asginación exitosa'),
                              content: const Text(
                                  'La asignación se ha completado con éxito.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Aceptar'),
                                  onPressed: () {
                                    for (var fecha in _dates) {
                                      controlador.insertarTarea(
                                          "comanda", fecha);
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF29DA81), // Cambia el color del botón a verde
                    ),
                    child: const Text('Asignar'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  List<DateTime> fechasDelDiaDeLaSemana(int diaDeLaSemana) {
    List<DateTime> fechas = [];
    DateTime ahora = DateTime.now();
    DateTime primerDia = DateTime(ahora.year, ahora.month, ahora.day);
    DateTime ultimoDia = DateTime(ahora.year + 1, ahora.month, ahora.day);

    for (DateTime dia = primerDia;
        dia.isBefore(ultimoDia);
        dia = dia.add(Duration(days: 1))) {
      if (dia.weekday == diaDeLaSemana) {
        fechas.add(dia);
      }
    }

    return fechas;
  }
}