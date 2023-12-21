import 'package:flutter/material.dart';

class TaskCommandImage extends StatefulWidget {
  final String? clase;
  const TaskCommandImage({Key? key, required this.clase});

  @override
  _CreateTaskImageCommandState createState() => _CreateTaskImageCommandState();
}

class _CreateTaskImageCommandState extends State<TaskCommandImage> {
  Map<String, int> amount = {};
  List<String> menus = [
    'assets/menu.png',
    'assets/no_carne.png',
    'assets/puré.png',
    'assets/fruta_triturada.png',
    'assets/yogur.png',
    'assets/fruta.png'
  ];

  int _currentPageIndex = 0;
  List<String> pages = [
    'assets/menu.png',
    'assets/no_carne.png',
    'assets/puré.png',
    'assets/fruta_triturada.png',
    'assets/yogur.png',
    'assets/fruta.png'
  ];

  Map<String, int> numeros = {};
  late String currentClass;
  Map<String, String> contador = {};

  @override
  void initState() {
    super.initState();
    currentClass = widget.clase!;

    amount = {};

    for (var menu in menus) {
      amount[menu] = 0;
    }

    numeros["assets/cero.png"] = 0;
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
  }

  @override
  Widget build(BuildContext context) {
    List<String> repeatedImages = [
      'assets/cero.png',
      'assets/uno.png',
      'assets/dos.png',
      'assets/tres.png',
      'assets/cuatro.png',
      'assets/cinco.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selecciona las comandas para $currentClass',
        ),
        backgroundColor:  Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          buildRowWithImages(pages[_currentPageIndex], repeatedImages),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 50.0,
                onPressed: () {
                  if (_currentPageIndex > 0) {
                    setState(() {
                      _currentPageIndex--;
                      //currentClass = pages[_currentPageIndex];
                    });
                  } else {
                    Navigator.pop(
                      context,
                      {'devolver': widget.clase},
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                iconSize: 50.0,
                onPressed: () {
                  if (_currentPageIndex < pages.length - 1) {
                    setState(() {
                      _currentPageIndex++;
                      //currentClass = pages[_currentPageIndex];
                    });
                  } else {
                    Navigator.pop(
                      context,
                      {'clase': currentClass, 'menu': amount},
                    );
                  }
                },
              ),
            ],
          ),
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
                            if (amount.containsKey(mainImagePath)) {
                              if (amount[mainImagePath] != null &&
                                  numeros[imagePath] != null) {
                                amount[mainImagePath] = numeros[imagePath]!;
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
