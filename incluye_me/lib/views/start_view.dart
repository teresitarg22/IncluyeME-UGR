import 'package:flutter/material.dart';
import 'package:incluye_me/views/student_login_view.dart';
import 'teacher_login_view.dart';

class StartView extends StatelessWidget {
  const StartView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a Incluye-Me'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6), // Ajusta la opacidad aquí
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ----------------------------------------------
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: const Image(
                  image: AssetImage("assets/logo.png"),
                  height: 230,
                  width: 230,
                ),
              ),
              const SizedBox(height: 40),
              // ----------------------------------------------
              buildButtonWithIcon(
                'assets/estudiante.png',
                'ESTUDIANTES',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentLoginView(),
                    ),
                  );
                },
              ),
              // ----------------------------------------------
              const SizedBox(height: 12),
              buildButtonWithIcon(
                'assets/maestro.png',
                'PROFESORES',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherLoginView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonWithIcon(
      String imagePath, String buttonText, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const SizedBox(width: 15),
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  12.0), // Ajusta el radio según sea necesario
              border: Border.all(
                  color: const Color.fromARGB(111, 33, 149, 243), width: 1.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              textStyle: const TextStyle(fontSize: 24),
              fixedSize: const Size(230, 85),
            ),
            onPressed: onPressed,
            child: Align(
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
