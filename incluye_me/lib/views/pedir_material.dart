import 'package:flutter/material.dart';

class PedirMaterial extends StatefulWidget {

  const PedirMaterial({super.key});

@override
  _PedirMaterialState createState() => _PedirMaterialState();
}

class _PedirMaterialState extends State<PedirMaterial> {
  List<List<TextEditingController>> controllersList = [
    [
      TextEditingController(text: 'Material 1'),
      TextEditingController(text: '0'),
    ],
  ];

  List<String> dropdownItems = ["Material 1", "Material 2", "Material 3"];

  void addLine() {
    setState(() {
      List<TextEditingController> rowControllers = [
        TextEditingController(text: 'Material 1'),
        TextEditingController(text: '0'),
      ];
      controllersList.add(rowControllers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarea Material'),
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Cuantidad',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                for (var controllers in controllersList)
                  TableRow(
                    children: [
                      DropdownButton<String>(
                        value: controllers[0].text,
                        items: dropdownItems.map((String value) {
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
                      TextFormField(
                        controller: controllers[1],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Ajouter de l'espace en bas
          SizedBox(height: 16),
        ],
      ),
      // Bouton flottant en bas à droite
      floatingActionButton: FloatingActionButton(
        onPressed: addLine,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}