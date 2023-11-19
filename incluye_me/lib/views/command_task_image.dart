import 'package:flutter/material.dart';
import '../views/user_list.dart';
import '../views/home_view.dart';
import 'classroom_choose.dart';

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
        '/': (context) => TaskCommand(clase: "clase1"),
        '/registroPage': (context) => const HomeScreen(),
        '/userList': (context) =>
            UserListPage(userName: user, userSurname: user),
        '/classroomChoose': (context) => ClaseDropdown(),
      },
    );
  }
}

class TaskCommand extends StatefulWidget {
  final String? clase;
  const TaskCommand({super.key, required this.clase});

  @override
  _CreateTaskCommandState createState() => _CreateTaskCommandState();
}

class _CreateTaskCommandState extends State<TaskCommand> {
  List<String> menus = [
    'menu.png',
    'no_carne.png',
    'puré.png',
    'fruta_triturada.png',
    'yogur.png',
    'fruta.png'
  ]; // Lista de menús
  Map<String, Map<String, int>> amount =
      {}; // Mapa para guardar la cantidad seleccionada de cada menú por clase
  Map<String, int> numeros = {};
  List<String> classroom = ['Clase 1', 'Clase 2', 'Clase 3']; // Lista de clases
  int currentClassIndex = 0; // Índice de la clase actual

  String current_class = "Clase1";

  @override
  void initState() {
    super.initState();

    amount[current_class] = {};

    for (var menu in menus) {
      amount[current_class]![menu] = 0;
    }

    numeros["uno.png"] = 1;
    numeros["dos.png"] = 2;
    numeros["tres.png"] = 3;
    numeros["cuatro.png"] = 4;
    numeros["cinco.png"] = 5;

    /*
    for (var clas in classroom) {
      amount[clas] = {};
      for (var menu in menus) {
        amount[clas]![menu] = 0;
      }
    }*/
  }

  @override
  Widget build(BuildContext context) {
    List<String> repeatedImages = [
      'assets/uno.png',
      'assets/dos.png',
      'assets/tres.png',
      'assets/cuatro.png',
      'assets/cinco.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selecciona las comandas para ${classroom[currentClassIndex]}',
        ),
        backgroundColor: const Color.fromARGB(255, 41, 218, 129),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          buildRowWithImages('assets/menu.png', repeatedImages),
          buildRowWithImages('assets/no_carne.png', repeatedImages),
          buildRowWithImages('assets/puré.png', repeatedImages),
          buildRowWithImages('assets/fruta_triturada.png', repeatedImages),
          buildRowWithImages('assets/yogur.png', repeatedImages),
          buildRowWithImages('assets/fruta.png', repeatedImages)
        ],
      ),
    );
  }

  /*Widget buildRowWithImages(String mainImagePath, List<String> repeatedImages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2, // Usa más espacio para la imagen principal
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                mainImagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
              width:
                  16.0), // Separación entre la imagen principal y las repetidas
          Expanded(
            flex: 4, // Usa más espacio para las imágenes repetidas
            child: Row(
              children: repeatedImages.map((imagePath) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        // Aquí puedes implementar la lógica de selección
                        setState(() {
                          // Lógica de selección de imagen
                          if (amount.containsKey(current_class)) {
                            // Verificar si mainImagePath y imagePath existen en amount[current_class]
                            if (amount[current_class] != null &&
                                amount[current_class]![mainImagePath] != null &&
                                numeros[imagePath] != null) {
                              // Asignar el valor si no son nulos
                              amount[current_class]![mainImagePath] =
                                  numeros[imagePath]!;
                            }
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Color del borde seleccionado
                            width: 2.0, // Ancho del borde
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }*/

  Widget buildRowWithImages(String mainImagePath, List<String> repeatedImages) {
    String? selectedImagePath; // Ruta de la imagen seleccionada

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                mainImagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            flex: 4,
            child: Row(
              children: repeatedImages.map((imagePath) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            print('Tapped: $imagePath');

                            selectedImagePath = imagePath;

                            if (amount.containsKey(current_class)) {
                              // Verificar si mainImagePath y imagePath existen en amount[current_class]
                              if (amount[current_class] != null &&
                                  amount[current_class]![mainImagePath] !=
                                      null &&
                                  numeros[imagePath] != null) {
                                // Asignar el valor si no son nulos
                                amount[current_class]![mainImagePath] =
                                    numeros[imagePath]!;
                              }
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            color: selectedImagePath == imagePath
                                ? Colors.grey
                                    .withOpacity(0.5) // Fondo seleccionado
                                : Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

/*
  Widget buildRowWithImages(String mainImagePath, List<String> repeatedImages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2, // Usa más espacio para la imagen principal
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                mainImagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
              width:
                  16.0), // Separación entre la imagen principal y las repetidas
          Expanded(
            flex: 4, // Usa más espacio para las imágenes repetidas
            child: Row(
              children: repeatedImages.map((imagePath) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }*/
}
