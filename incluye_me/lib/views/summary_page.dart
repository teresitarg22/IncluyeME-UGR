import 'package:flutter/material.dart';
import '../controllers/usuario_controller.dart'; 

class SummaryPage extends StatelessWidget {
  Map<String, Map<String, Map<String, int>>> amount = {};
  Map<String, int> menus = {};
  final taskID; 

  SummaryPage({required this.amount, required this.menus, required this.taskID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: amount.entries.map((entry) {
                return Column(
                  children: [
                    Text(entry.key,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24)),
                    ...entry.value.entries.map((menuEntry) {
                      int total = 0;
                      if (menus.containsKey(entry.key)) {
                        total = menus[entry.key]!;
                      }

                      return Column(
                        children: [
                          ListTile(
                            title: Text(menuEntry.key,
                                textAlign: TextAlign.center),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:
                                  menuEntry.value.entries.map((optionEntry) {
                                return Text(
                                    '${optionEntry.key}: ${optionEntry.value}',
                                    textAlign: TextAlign.center);
                              }).toList(),
                            ),
                          ),
                          Text('Total: $total',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            Controller().completarTarea(taskID);
            List<String> comanda = [];
            for  ( var clase  in amount.keys)  {
              for ( var menu in amount[clase]!.keys)  {
                for ( var option in amount[clase]![menu]!.keys)  {
                   
                  comanda.add('${amount[clase]![menu]![option]}') ; 
                }
                Controller().insertarComanda(taskID, clase, menu , comanda.toString(), menus[clase]!);
                comanda.clear() ;
              }
            }

            //Navigator.pop(context);
          },
          child: Text('Finalizar Tarea',
          style: TextStyle(fontSize: 25),),
          
        ),
      ),
    );
  }
}
