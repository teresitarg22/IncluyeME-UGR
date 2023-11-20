import 'package:flutter/material.dart';

class TaskCommand extends StatefulWidget {
  final String? clase;
  final Map<String, int >? menus;
  final  Map<String, int>? specialOptions; 
  const TaskCommand({Key? key, required this.clase, this.menus, this.specialOptions});

  @override
  _CreateTaskCommandState createState() => _CreateTaskCommandState();
}

class _CreateTaskCommandState extends State<TaskCommand> {
  List<String> menus = ['Menu Principal'];
  Map<String, int> amount = {};
  Map<String, int> specialOptions = {
    'Sin Carne': 0,
    'Triturados': 0,
    'Fruta': 0,
    'Fruta triturada': 0,
    'Yogur': 0
  };

  @override
  void initState() {
    super.initState();

    if (widget.menus == null) {
      for (var menu in menus) {
        amount[menu] = 0;
      }
    } else {
      for (var menu in menus) {
        amount[menu] = widget.menus![widget.clase]! ; 
      }
      this.specialOptions = widget.specialOptions!;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: menus.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0), // Ajusta el espacio aquí
                        child: Text(
                          menus[index],
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 30),
                      IconButton(
                        icon: Icon(Icons.remove, size: 30.0),
                        onPressed: () {
                          setState(() {
                            if (amount[menus[index]]! > 0) {
                              amount[menus[index]] = amount[menus[index]]! - 1;
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
                            amount[menus[index]] = amount[menus[index]]! + 1;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            if (amount['Menu Principal']! > 0) ...[
              Divider(),
              ...specialOptions.keys.map((key) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      key,
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: Icon(Icons.remove, size: 30.0),
                      onPressed: () {
                        setState(() {
                          if (specialOptions[key]! > 0) {
                            specialOptions[key] = specialOptions[key]! - 1;
                          }
                        });
                      },
                    ),
                    Text(
                      '${specialOptions[key]}',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, size: 30.0),
                      onPressed: () {
                        setState(() {
                          if (key == 'Fruta Triturada') {
                            if (specialOptions['Fruta Triturada']! <
                                specialOptions['Fruta']!) {
                              specialOptions[key] = specialOptions[key]! + 1;
                            }
                          } else if (specialOptions[key]! <
                              amount['Menu Principal']!) {
                            specialOptions[key] = specialOptions[key]! + 1;
                          }
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            ],
            SizedBox(height: 20), // Separación entre los elementos de cada menú
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 50.0,
                  onPressed: () {
                    Navigator.pop(
                      context,
                      {'devolver': widget.clase},
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  iconSize: 50.0,
                  onPressed: () {
                    Navigator.pop(
                      context,
                      {
                        'clase': widget.clase,
                        'menu': amount,
                        'specialOptions': specialOptions
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
