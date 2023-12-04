import 'package:flutter/material.dart';
import 'package:incluye_me/views/login/student_login_view.dart';
import 'login/teacher_login_view.dart';

class StartView extends StatelessWidget {
  const StartView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a Incluye-Me'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double screenWidth = constraints.maxWidth; // Tamaño de la pantalla.
            String fondo =
                screenWidth > 600 // Selección del fondo según las dimensiones.
                    ? 'assets/fondo_inicio_horizontal.png'
                    : 'assets/fondo_inicio_vertical.png';

            // -------------------------------------
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(fondo),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              // ----------------------------
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: const Image(
                          image: AssetImage("assets/logo.png"),
                          height: 230,
                          width: 230,
                        ),
                      ),
                      // -------------------------------
                      const SizedBox(height: 40),
                      // -------------------------------
                      buildButtonWithIcon(
                          'assets/estudiante.png', 'ESTUDIANTES', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentLoginView(),
                          ),
                        );
                      }, context),
                      // -------------------------------
                      const SizedBox(height: 12),
                      // -------------------------------
                      buildButtonWithIcon('assets/maestro.png', 'PROFESORES',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeacherLoginView(),
                          ),
                        );
                      }, context),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  Widget buildButtonWithIcon(String imagePath, String buttonText,
      VoidCallback onPressed, BuildContext context) {
    // Variables para calcular el tamaño de los botones dependiendo del tamaño de la pantalla.
    final double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth;
    double containerSize;
    double iconSize;

    // Calculamos el tamaño según las dimensiones:
    if (screenWidth > 600) {
      buttonWidth = screenWidth * 0.25;
      containerSize = screenWidth * 0.06;
      iconSize = screenWidth * 0.06;
    } else {
      buttonWidth = screenWidth * 0.5;
      containerSize = screenWidth * 0.2;
      iconSize = screenWidth * 0.2;
    }

    // Calcular los valores mínimos y máximos para el ancho del botón:
    final double minButtonWidth = screenWidth * 0.2;
    final double maxButtonWidth = screenWidth * 0.4;

    // -----------------------------------------------
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minButtonWidth,
        maxWidth: maxButtonWidth,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // -----------------------------
            const SizedBox(width: 15),
            // -----------------------------
            Container(
              height: containerSize,
              width: containerSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(containerSize * 0.09),
                border: Border.all(
                  color: const Color.fromARGB(111, 33, 149, 243),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: iconSize,
                  width: iconSize,
                ),
              ),
            ),
            // -----------------------------
            const SizedBox(width: 10),
            // -----------------------------
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonWidth * 0.1),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: buttonWidth * 0.13, vertical: 20),
                textStyle: TextStyle(fontSize: buttonWidth * 0.1),
                fixedSize: Size(buttonWidth, 85),
              ),
              onPressed: onPressed,
              child: Align(
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // -----------------------------
            const SizedBox(width: 50),
            // -----------------------------
          ],
        ),
      ),
    );
  }
}
