import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:io';
import '../controllers/usuario_controller.dart';
import '../views/user_list.dart';
import '../views/home_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'classroom_choose.dart' ; 

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
  List<String> menus = ['Menu 1', 'Menu 2', 'Menu 3']; // Lista de menús
  Map<String, Map<String, int>> amount =
      {}; // Mapa para guardar la cantidad seleccionada de cada menú por clase
  List<String> classroom = ['Clase 1', 'Clase 2', 'Clase 3']; // Lista de clases
  int currentClassIndex = 0; // Índice de la clase actual

  @override
  void initState() {
    super.initState();
    for (var clas in classroom) {
      amount[clas] = {};
      for (var menu in menus) {
        amount[clas]![menu] = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Selecciona las comandas para ${classroom[currentClassIndex]}'),
        backgroundColor: const Color.fromARGB(255, 41, 218, 129),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(.10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          menus[index],
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove, size: 30.0),
                        onPressed: () {
                          setState(() {
                            if (amount[classroom[currentClassIndex]]![
                                    menus[index]]! >
                                0) {
                              amount[classroom[currentClassIndex]]![
                                      menus[index]] =
                                  amount[classroom[currentClassIndex]]![
                                          menus[index]]! -
                                      1;
                            }
                          });
                        },
                      ),
                      Text(
                        '${amount[classroom[currentClassIndex]]![menus[index]]}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, size: 30.0),
                        onPressed: () {
                          setState(() {
                            amount[classroom[currentClassIndex]]![
                                    menus[index]] =
                                amount[classroom[currentClassIndex]]![
                                        menus[index]]! +
                                    1;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 0,
            top: MediaQuery.of(context).size.height / 2,
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              iconSize: 50.0, // Hace el icono más grande
              onPressed: () {
                if (currentClassIndex < classroom.length - 1) {
                  setState(() {
                    currentClassIndex++;
                  });
                } else {
                  // Navega a la página de resumen cuando se han anotado todos los menús
                       Navigator.of(context).pop();
                       Navigator.pushNamed(context, '/classroomChoose');
                }
              },
            ),
          ),
          Positioned(
            left: 0,
            top: MediaQuery.of(context).size.height / 2,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: 50.0, // Hace el icono más grande
              onPressed: () {
                if (currentClassIndex > 0) {
                  setState(() {
                    currentClassIndex--;
                  });
                } else {
                  // Navega a la página anterior o realiza otra acción cuando se está en la primera clase
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
