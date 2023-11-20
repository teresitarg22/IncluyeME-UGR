import 'package:flutter/material.dart';

class LoginWithSymbols extends StatefulWidget {
  const LoginWithSymbols({super.key});

  @override
  _LoginWithSymbolsState createState() => _LoginWithSymbolsState();
}

// ------------------------------------------------------------------------

class _LoginWithSymbolsState extends State<LoginWithSymbols> {
  List<String> selectedSymbols = [];
  final List<String> symbols =
      List.generate(9, (index) => 'assets/symbol$index.png');

  // Combinación correcta de símbolos
  final List<String> correctCombination = [
    'assets/symbol0.png',
    'assets/symbol1.png',
    'assets/symbol2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona 3 símbolos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0), // Padding para los bordes
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0, // Espaciado entre elementos
                mainAxisSpacing: 16.0,
              ),
              itemCount: symbols.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (selectedSymbols.length < 3) {
                      setState(() {
                        selectedSymbols.add(symbols[index]);
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius:
                          BorderRadius.circular(10), // Borde redondeado
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Sombra
                        ),
                      ],
                    ),
                    child: Image.asset(symbols[index]),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 16.0), // Padding inferior
            height: 250,
            child: Column(
              children: [
                // --------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (index) {
                    if (index < selectedSymbols.length) {
                      return Image.asset(selectedSymbols[index],
                          height: 100, width: 100);
                    } else {
                      return const Icon(Icons.clear,
                          size: 50, color: Colors.red);
                    }
                  }),
                ),
                // --------------------------
                ElevatedButton(
                  onPressed: () {
                    // Verificar si la combinación es correcta.
                    if (selectedSymbols.length == 3 &&
                        selectedSymbols[0] == correctCombination[0] &&
                        selectedSymbols[1] == correctCombination[1] &&
                        selectedSymbols[2] == correctCombination[2]) {
                      // Mostrar popup de inicio de sesión correcto.
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Inicio de sesión correcto'),
                          content: const Text('Redirigiendo...'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Simular redirección
                                Navigator.pop(context); // Cerrar popup
                                Navigator.pop(
                                    context); // Cerrar pantalla actual
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Mostrar popup de inicio de sesión incorrecto.
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Inicio de sesión incorrecto'),
                          content: const Text('Por favor, intenta de nuevo.'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context), // Cerrar popup
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Aceptar'),
                ),
                // --------------------------
                ElevatedButton(
                  onPressed: () {
                    // Acción para borrar toda la selección
                    setState(() {
                      selectedSymbols.clear();
                    });
                  },
                  child: const Text('Borrar selección'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
