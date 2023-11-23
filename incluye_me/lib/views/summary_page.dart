import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  Map<String, Map<String, Map<String, int>>> amount = {};
  Map<String, int> menus = {};

  SummaryPage({required this.amount, required this.menus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centra los elementos verticalmente
              children: amount.entries.map((entry) {
                return Column(
                  children: [
                    Text(entry.key,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24)),
                    ...entry.value.entries.map((menuEntry) {
                      int total = 0;
                      // Verificamos si el menú está presente en la variable menus
                      if (menus.containsKey(entry.key) ) {
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
                          SizedBox(
                              height: 10), // Agregamos espacio entre los menús
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
    );
  }
}
