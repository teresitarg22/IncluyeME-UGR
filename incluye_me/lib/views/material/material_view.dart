import 'package:flutter/material.dart';
import '../../components/bottom_navigation_bar.dart';
import '../../controllers/task_controller.dart' as TC;
import '../../controllers/user_controller.dart' as UC;

class MaterialView extends StatefulWidget {
  String userName;
  String userSurname;
  bool sabeLeer;
  int taskID;

  MaterialView({Key? key, required this.userName, required this.userSurname, required this.sabeLeer, required this.taskID}) : super(key: key);

  @override
  _MaterialViewState createState() => _MaterialViewState();
}

class _MaterialViewState extends State<MaterialView> {
  final UC.Controller Ucontrolador = UC.Controller();
  final TC.TaskController Tcontrolador = TC.TaskController();
  final List<String> numeros = ["assets/cero.png", "assets/uno.png", "assets/dos.png", "assets/tres.png", "assets/cuatro.png", "assets/cinco.png"];

  List<int> listaCantidad = [];
  List<String> listaMaterial = [];
  List<bool> isDoneList = [];
  Future<int>? initFuture;

  Future<int> getListMaterial() async {
    List<Map<String, Map<String, dynamic>>> listas = await Tcontrolador.getListMaterial(widget.taskID);
    for (int i = 0; i < listas[0]['tarea_material']!['cantidad'].length; i++) {
      listaCantidad.add(listas[0]['tarea_material']!['cantidad'][i]);
      listaMaterial.add(listas[0]['tarea_material']!['material'][i]);
      isDoneList.add(listas[0]['tarea_material']!['hecho'][i]);
    }
    return 1;
  }

  Future<void> saveHecho() async {
    await Tcontrolador.saveHechoMaterial(isDoneList, widget.taskID);

    // Check if all elements in isDoneList are true
    if (isDoneList.every((element) => element == true)) {
      // If all are true, call the taskDone function
      await Tcontrolador.taskDone(widget.taskID);
    }
  }

  String getImageMaterial(String material) {
    String mat = "";
    if(material == 'papel') mat = "assets/papel.png";
    if(material == 'boligrafo') mat = "assets/boli.jpg";
    if(material == 'regla') mat = "assets/regla.png";
    return mat;
  }

  @override
  void initState() {
    super.initState();
    initFuture = getListMaterial();
  }

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
              title: Text('Material List'),
            ),
            body: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Material')),
                  DataColumn(label: Text('Cantidad')),
                  DataColumn(label: Text('Hecho')),
                ],
                rows: List.generate(
                  listaMaterial.length,
                  (index) => DataRow(cells: [
                    DataCell(
                      widget.sabeLeer
                          ? Text(listaMaterial[index])
                          : Image.asset(
                              getImageMaterial(listaMaterial[index]),
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                    ),
                    DataCell(
                      widget.sabeLeer
                          ? Text(listaCantidad[index].toString())
                          : Image.asset(
                              numeros[listaCantidad[index]],
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                    ),
                    DataCell(Checkbox(
                      value: isDoneList[index],
                      onChanged: (bool? value) {
                        setState(() {
                          isDoneList[index] = value!;
                        });
                      },
                    )),
                  ]),
                ),
              ),
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await saveHecho();
                    // Navigate back to the previous screen
                    Navigator.pop(context);
                  },
                  child:
                    widget.sabeLeer
                    ? Text('Guardar')
                    : Image.asset(
                        'assets/sí.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                
                ),
                CustomNavigationBar(userName: widget.userName, userSurname: widget.userSurname),
              ],
            ),
          );
        }
      },
    );
  }
}
