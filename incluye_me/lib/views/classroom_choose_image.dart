import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'command_task.dart';
import '../controllers/usuario_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
  final Controller controlador = Controller();
  var aulas = [];
  //Map<String, File> fotos = {};
  int sizeAulas = 0;
  String _selectedClase = '';

  @override
  void initState() {
    super.initState();
    buscarAulas();
  }

  Future<void> buscarAulas() async {
    aulas = await controlador.listaAulas();

    setState(() {
      sizeAulas = aulas.length;
    });

    /*Future.forEach(aulas, (aula) {
      return getImageFromDatabase(aula['aula']['nombre']);
    });*/
  }

  /*Future<void> getImageFromDatabase(String aula) async {
    // Obtener los bytes de la imagen desde la base de datos
    // bytes es la variable donde se obtienen los bytes desde la base de datos
    List<Map<String, Map<String, dynamic>>> datos =
        await controlador.fotoAula(aula);
    late Uint8List bytes;

    if (datos.isNotEmpty) {
      final imagen = datos[0]['personal']?['foto'];
      bytes = Uint8List.fromList(imagen);

      // Crear un archivo temporal para la imagen
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final tempFile = File('$tempPath/$aula.png');

      // Escribir los bytes en el archivo temporal
      if (bytes.isNotEmpty) {
        await tempFile.writeAsBytes(bytes);
      }

      setState(() {
        fotos[aula] = tempFile;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona una clase')),
      body: GridView.builder(
        padding: const EdgeInsets.all(60.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 32.0,
          crossAxisSpacing: 32.0,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (index >= 0 && index < sizeAulas) {
            _selectedClase = aulas[index]['aula']['nombre'];
            /*if (!fotos.containsKey(_selectedClase)) {
              getImageFromDatabase(_selectedClase);
            }*/
          }

          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TaskCommand(
                      clase: _selectedClase,
                    );
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(width: 1.0),
                ),
                child: Image.asset('assets/aula.png'),

                //child: fotos.containsKey(_selectedClase)
//? Image.file(fotos[_selectedClase]!)
                //: Image.asset('assets/usuario_sin_foto.png'),
                //child: Image.asset('assets/usuario_sin_foto.png'),
              ),
              SizedBox(height: 8),
              Text(_selectedClase),
            ],
          );
        },
        itemCount: sizeAulas,
      ),
    );
  }
}
