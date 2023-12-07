import 'package:flutter/material.dart';
import '../components/bottom_navigation_bar.dart';
import '../controllers/task_controller.dart' as TC;
import '../controllers/usuario_controller.dart' as UC;

class PedirMaterial extends StatefulWidget {
  String userName;
  String userSurname;

  PedirMaterial({super.key, required this.userName, required this.userSurname});

  @override
  _PedirMaterialState createState() => _PedirMaterialState();
}

class _PedirMaterialState extends State<PedirMaterial> {
  final UC.Controller Ucontrolador = UC.Controller();
  final TC.Controller Tcontrolador = TC.Controller();
  List<String> aulaList = [""];
  List<String> studentList = [""];
  List<String> materialList = [""];
  String selectedAula = "";
  String selectedStudent = "";

  Future<void> loadMaterial() async {
    for (var material in await Tcontrolador.monstrarListaMaterial()) {
      materialList.add(material['lista_material']!['nombre'].toString());
    }
  }

  Future<void> loadAula() async {
    for (var aula in await Ucontrolador.listaAulas()) {
      aulaList.add(aula['aula']!['nombre'].toString());
    }
  }
  
  Future<void> loadEstudiante() async {
    for (var student in await Ucontrolador.listaEstudiantes()) {
      studentList.add(student['estudiante']!['nombre'].toString() +
          " " +
          student['estudiante']!['apellidos'].toString());
    }
  }

  List<List<TextEditingController>> controllersList = [
    [
      TextEditingController(text: ""),
      TextEditingController(text: '0'),
    ],
  ];

  void addLine() {
    setState(() {
      List<TextEditingController> rowControllers = [
        TextEditingController(text: ""),
        TextEditingController(text: '0'),
      ];
      controllersList.add(rowControllers);
    });
  }

void addMaterialToStudent(String student, String aula) {
  List<String> material = [];
  List<int> cantidad = [];
    for (List<TextEditingController> listeInterne in controllersList) {
      if (listeInterne.isNotEmpty) {
        material.add(listeInterne[0].text);
      }
    }
    for (List<TextEditingController> listeInterne in controllersList) {
      if (listeInterne.isNotEmpty) {
        int isInt = int.parse(listeInterne[1].text);
        cantidad.add(isInt);
      }
    }
    Tcontrolador.addMaterialToStudent(student, aula, material, cantidad);
  }

  @override
  void initState() {
    super.initState();
    loadAula();
    loadEstudiante();
    loadMaterial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarea Material'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Table(
              border: TableBorder.all(),
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Center(
                      child: Text(
                        'Material',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Cuantidad',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                for (var controllers in controllersList)
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButton<String>(
                          value: controllers[0].text,
                          items: materialList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              controllers[0].text = value!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          controller: controllers[1],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Ajouter de l'espace en bas
          SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the children horizontally
              children: [
                DropdownButton<String>(
                  value: selectedStudent,
                  items: studentList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedStudent = value!;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: selectedAula,
                  items: aulaList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedAula = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
              ),
              child: Text("Asignar a este alumno"),
              onPressed: () {addMaterialToStudent(selectedStudent, selectedAula);}),
        ],
      ),
      // Bouton flottant en bas à droite
      floatingActionButton: FloatingActionButton(
          onPressed: addLine,
          child: Icon(Icons.add),
          backgroundColor: Colors.blue),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: CustomNavigationBar(
          userName: widget.userName, userSurname: widget.userSurname),
    );
  }
}
