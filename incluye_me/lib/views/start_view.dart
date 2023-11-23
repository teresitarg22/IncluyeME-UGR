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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
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
                  height: 300,
                  width: 300,
                ),
              ),
              const SizedBox(height: 40),
              // ----------------------------------------------
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudentLoginView()),
                    );
                  },
                  child: const Text(
                    'Estudiantes',
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                ),
              ),
              // ----------------------------------------------
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TeacherLoginView()),
                    );
                  },
                  child: const Text('Profesores'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
