import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    String user = "";
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => TaskCommand(clase: "clase1"),
      },
    );
  }
}

class TaskCommand extends StatefulWidget {
  final String? clase;
  const TaskCommand({Key? key, required this.clase});

  @override
  _CreateTaskCommandState createState() => _CreateTaskCommandState();
}

class _CreateTaskCommandState extends State<TaskCommand> {
  List<String> menus = ['Menu 1', 'Menu 2', 'Menu 3'];
  Map<String, int> amount = {};

  int currentClassIndex = 0;

  @override
  void initState() {
    super.initState();

    for (var menu in menus) {
      amount[menu] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona las comandas para la clase ${widget.clase}'),
        backgroundColor: const Color.fromARGB(255, 41, 218, 129),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            ListView.builder(
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
                            if (amount[menus[index]]! > 0) {
                              amount[menus[index]] =
                                  amount[menus[index]]! - 1;
                            }
                          });
                        },
                      ),
                      Text(
                        '${amount[menus[index]]}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, size: 30.0),
                        onPressed: () {
                          setState(() {
                            amount[menus[index]] =
                                amount[menus[index]]! + 1;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 2,
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
                iconSize: 50.0,
                onPressed: () {
                  Navigator.pop(
                    context,
                    {'clase': widget.clase, 'menu': amount},
                  );
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
      ),
    );
  }
}
