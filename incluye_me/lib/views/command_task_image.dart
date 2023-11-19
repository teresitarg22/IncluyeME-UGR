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
    'assets/menu.png',
    'assets/no_carne.png',
    'assets/puré.png',
    'assets/fruta_triturada.png',
    'assets/yogur.png',
    'assets/fruta.png'
  ]; // Lista de menús
  Map<String, Map<String, int>> amount =
      {}; // Mapa para guardar la cantidad seleccionada de cada menú por clase
  Map<String, int> numeros = {};
  //List<String> classroom = ['Clase 1', 'Clase 2', 'Clase 3']; // Lista de clases
  //int currentClassIndex = 0; // Índice de la clase actual

  String current_class = "Clase1";
  Map<String, String> contador = {};

  @override
  void initState() {
    super.initState();

    amount[current_class] = {};

    for (var menu in menus) {
      amount[current_class]![menu] = 0;
    }

    numeros["assets/uno.png"] = 1;
    numeros["assets/dos.png"] = 2;
    numeros["assets/tres.png"] = 3;
    numeros["assets/cuatro.png"] = 4;
    numeros["assets/cinco.png"] = 5;

    contador["assets/menu.png"] = 'assets/cero.png';
    contador["assets/no_carne.png"] = 'assets/cero.png';
    contador["assets/puré.png"] = 'assets/cero.png';
    contador["assets/fruta_triturada.png"] = 'assets/cero.png';
    contador["assets/yogur.png"] = 'assets/cero.png';
    contador["assets/fruta.png"] = 'assets/cero.png';

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
          'Selecciona las comandas para Clase1',
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

  void changeImage() {
    setState(() {});
  }

  Widget buildRowWithImages(String mainImagePath, List<String> repeatedImages) {
    String? selectedImagePath; // Ruta de la imagen seleccionada

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 100, // Ancho de la imagen izquierda
            child: Image.asset(
              contador[mainImagePath]!, // Ruta de tu imagen izquierda
              fit: BoxFit.contain,
            ),
          ),
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
                            selectedImagePath = imagePath;
                            if (amount.containsKey(current_class)) {
                              if (amount[current_class] != null &&
                                  amount[current_class]![mainImagePath] !=
                                      null &&
                                  numeros[imagePath] != null) {
                                amount[current_class]![mainImagePath] =
                                    numeros[imagePath]!;
                              }
                            }

                            contador[mainImagePath] = imagePath;
                            changeImage();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            color: selectedImagePath == imagePath
                                ? Colors.grey.withOpacity(0.5)
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
}
