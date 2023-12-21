import 'package:flutter/material.dart';
import 'package:incluye_me/components/bottom_navigation_bar.dart';
import '/controllers/task_controller.dart' as TC;
import '/controllers/user_controller.dart' as UC;

class PedirMaterial extends StatefulWidget {
  final String userName;
  final String userSurname;

  const PedirMaterial(
      {super.key, required this.userName, required this.userSurname});

  @override
  _PedirMaterialState createState() => _PedirMaterialState();
}

// -------------------------------------------------------------------------

class _PedirMaterialState extends State<PedirMaterial> {
  final UC.Controller Ucontrolador = UC.Controller();
  final TC.TaskController Tcontrolador = TC.TaskController();
  List<String> aulaList = [""];
  List<String> studentList = [""];
  List<String> materialList = [""];
  String selectedAula = "";
  String selectedStudent = "";
  Future<int>? initFuture;

  // -----------------------------

  Future<int> loadMaterial() async {
    for (var material in await Tcontrolador.monstrarListaMaterial()) {
      materialList.add(material['lista_material']!['nombre'].toString());
    }
    return 1;
  }

  // -----------------------------

  Future<void> loadAula() async {
    for (var aula in await Ucontrolador.listaAulas()) {
      aulaList.add(aula['aula']!['nombre'].toString());
    }
  }

  // -----------------------------

  Future<void> loadEstudiante() async {
    for (var student in await Ucontrolador.listaEstudiantes()) {
      studentList.add(
          "${student['estudiante']!['nombre']} ${student['estudiante']!['apellidos']}");
    }
  }

  // -----------------------------

  List<List<TextEditingController>> controllersList = [
    [
      TextEditingController(text: ""),
      TextEditingController(text: '0'),
    ],
  ];

  // -----------------------------

  void addLine() {
    setState(() {
      List<TextEditingController> rowControllers = [
        TextEditingController(text: ""),
        TextEditingController(text: '0'),
      ];
      controllersList.add(rowControllers);
    });
  }

  // -----------------------------

  void addMaterialToStudent(String student, String aula) {
    List<String> material = [];
    List<int> cantidad = [];
    List<String> hecho = [];
    for (List<TextEditingController> listeInterne in controllersList) {
      if (listeInterne.isNotEmpty) {
        material.add(listeInterne[0].text);
        int isInt = int.parse(listeInterne[1].text);
        cantidad.add(isInt);
        hecho.add('false');
      }
    }
    Tcontrolador.addMaterialToStudent(student, aula, material, cantidad, hecho);
  }

  // -----------------------------

  @override
  void initState() {
    super.initState();
    loadAula();
    loadEstudiante();
    initFuture = loadMaterial();
  }

  // -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Tarea Material',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                backgroundColor: Colors.blue,
                automaticallyImplyLeading: false,
              ),
              body: Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        // -----------------------------
                        const TableRow(
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
                                'Cantidad',
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                              // -----------------------------
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: TextFormField(
                                  controller: controllers[1],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  // ---------------------------------
                  const SizedBox(height: 16),
                  // ---------------------------------
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // -----------------------------
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
                        // -----------------------------
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
                  // -----------------------------
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                      ),
                      child: const Text(
                        "Asignar a alumno",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        addMaterialToStudent(selectedStudent, selectedAula);
                      }),
                ],
              ),
              // ---------------------------------------------------------
              floatingActionButton: FloatingActionButton(
                  onPressed: addLine,
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.blue),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,

              bottomNavigationBar: CustomNavigationBar(
                  userName: widget.userName, userSurname: widget.userSurname),
            );
          }
        });
  }
}
