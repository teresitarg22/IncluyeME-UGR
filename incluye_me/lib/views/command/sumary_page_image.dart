import 'package:flutter/material.dart';


class SummaryPageImage extends StatefulWidget {
  final Map<String, Map<String, int>> amount;

  SummaryPageImage({required this.amount});

  @override
  _SummaryPageImageState createState() => _SummaryPageImageState();
}

class _SummaryPageImageState extends State<SummaryPageImage> {
  PageController _pageController = PageController(initialPage: 0);
  Map<int, String> numeros = {};

  @override
  void initState() {
    super.initState();
    numeros[0] = "assets/cero.png";
    numeros[1] = "assets/uno.png";
    numeros[2] = "assets/dos.png";
    numeros[3] = "assets/tres.png";
    numeros[4] = "assets/cuatro.png";
    numeros[5] = "assets/cinco.png";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: PageView(
                controller: _pageController,
                children: buildPages(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (_pageController.page != 0) {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (_pageController.page != widget.amount.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPages() {
    List<Widget> pages = [];

    widget.amount.entries.forEach((entry) {
      Widget page = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              entry.key,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: entry.value.entries.map((innerEntry) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        innerEntry.key,
                        width: 75,
                        height: 75,
                        fit: BoxFit.contain,
                      ),
                      Image.asset(
                        numeros[innerEntry.value]!,
                        width: 75,
                        height: 75,
                        fit: BoxFit.contain,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
      pages.add(page);
    });

    return pages;
  }
}
