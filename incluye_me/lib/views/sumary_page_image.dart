import 'package:flutter/material.dart';

class SummaryPageImage extends StatelessWidget {
  final Map<String, Map<String, int>> amount;
  Map<int, String> numeros = {};
  String? cantidad = "assets/cero.png";

  SummaryPageImage({required this.amount});

  /*@override
  void initState() {
    numeros[0] = "assets/cero.png";
    numeros[1] = "assets/uno.png";
    numeros[2] = "assets/dos.png";
    numeros[3] = "assets/tres.png";
    numeros[4] = "assets/cuatro.png";
    numeros[5] = "assets/cinco.png";
  }*/

  @override
  Widget build(BuildContext context) {
    numeros[0] = "assets/cero.png";
    numeros[1] = "assets/uno.png";
    numeros[2] = "assets/dos.png";
    numeros[3] = "assets/tres.png";
    numeros[4] = "assets/cuatro.png";
    numeros[5] = "assets/cinco.png";

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: amount.entries.map((entry) {
                return Center(
                  child: ListTile(
                    title: Text(
                      entry.key,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: entry.value.entries.map((innerEntry) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                '${innerEntry.key}',
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Expanded(
                              child: Image.asset(
                                numeros[innerEntry.value]!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
