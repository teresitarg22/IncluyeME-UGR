import 'package:flutter/material.dart';
import 'command_task.dart'; 


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
        '/': (context) => ClaseDropdown(),
        
        '/classroomChoose': (context) => ClaseDropdown(),
      },
    );
  }
}

class ClaseDropdown extends StatefulWidget {
  @override
  _ClaseDropdownState createState() => _ClaseDropdownState();
}

class _ClaseDropdownState extends State<ClaseDropdown> {
  String? _selectedClase;
  List<String> clasesDisponibles = ['Clase A', 'Clase B', 'Clase C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una Clase'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selecciona una Clase:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  value: _selectedClase,
                  onChanged: (value) {
                    setState(() {
                      _selectedClase = value;
                    });
                  },
                  items: clasesDisponibles.map((clase) {
                    return DropdownMenuItem<String>(
                      value: clase,
                      child: Text(clase),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                if (_selectedClase != null)
                  Text(
                    'Clase seleccionada: $_selectedClase',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: MediaQuery.of(context).size.height / 2,
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              iconSize: 50.0,
              onPressed: () {
                Navigator.of(context).pop();
                 Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TaskCommand(
               clase: _selectedClase,
              );
            }));
              },
            ),
          ),
          Positioned(
            left: 0,
            top: MediaQuery.of(context).size.height / 2,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: 50.0,
              onPressed: () {
                // Acción al presionar el botón de retroceso
              },
            ),
          ),
        ],
      ),
    );
  }
}
