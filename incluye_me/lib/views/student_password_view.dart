import 'package:flutter/material.dart';

class LoginWithSymbols extends StatefulWidget {
  const LoginWithSymbols({Key? key});

  @override
  _LoginWithSymbolsState createState() => _LoginWithSymbolsState();
}

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
          Flexible(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
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
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset(symbols[index]),
                  ),
                );
              },
            ),
          ),
          // ---------------------------------------------------------------
          Container(
            height: 1.5,
            color: Colors.blue, // Línea azul de separación.
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(bottom: 16.0),
            height: 250,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (index) {
                    if (index < selectedSymbols.length) {
                      return Image.asset(
                        selectedSymbols[index],
                        height: 80,
                        width: 80,
                      );
                    } else {
                      return const Icon(Icons.clear,
                          size: 50, color: Colors.red);
                    }
                  }),
                ),
                // ---------------------------------------------------------
                const SizedBox(height: 15),
                Container(
                  height: 1.5,
                  color: Colors.blue, // Línea azul de separación.
                ),
                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ----------------------------------------
                    // Botón para aceptar la acción
                    ElevatedButton(
                      onPressed: () {
                        if (selectedSymbols.length == 3 &&
                            selectedSymbols[0] == correctCombination[0] &&
                            selectedSymbols[1] == correctCombination[1] &&
                            selectedSymbols[2] == correctCombination[2]) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Inicio de sesión correcto'),
                              content: const Text('Redirigiendo...'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Inicio de sesión incorrecto'),
                              content:
                                  const Text('Por favor, intenta de nuevo.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8.0),
                      ),
                      child: SizedBox(
                        width: 50,
                        child: Image.asset('assets/sí.png'),
                      ),
                    ),
                    // -------------------------------------------------
                    const SizedBox(width: 70),
                    // ----------------------------------------
                    // Botón para denegar la acción
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedSymbols.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8.0),
                      ),
                      child: SizedBox(
                        width: 50, // Ajusta este valor según tus necesidades
                        child: Image.asset('assets/no.png'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
