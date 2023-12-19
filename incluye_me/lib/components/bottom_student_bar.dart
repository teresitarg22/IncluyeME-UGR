import 'package:flutter/material.dart';

import 'package:incluye_me/views/student/student_details.dart';
import 'package:incluye_me/views/student/student_tasks.dart';
import '../globals/globals.dart';

class StudentNavigationBar extends StatefulWidget {
  final String userName;
  final String userSurname;

  const StudentNavigationBar(
      {required this.userName, required this.userSurname});

  @override
  _StudentNavigationBarState createState() => _StudentNavigationBarState();
}

class _StudentNavigationBarState extends State<StudentNavigationBar> {
  int _currentIndex = currentBottomNavigationBarIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.white,
      unselectedItemColor: Color.fromARGB(255, 209, 209, 209),
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
          currentBottomNavigationBarIndex = index;
        });

        if (index == 0) {
          // ----------------------------------------------------------
          // Lista de tareas del estudiante
          String currentRouteName = ModalRoute.of(context)?.settings.name ?? '';
          if (currentRouteName != '/studentTasks') {
            print(currentRouteName);
            print("Test");
            Navigator.pushReplacementNamed(context, '/studentTasks',
                arguments: {
                  'userName': widget.userName,
                  'userSurname': widget.userSurname,
                });
          }
        } else if (index == 1) {
          // ----------------------------------------------------------
          // Detalles del estudiante
          String currentRouteName = ModalRoute.of(context)?.settings.name ?? '';
          if (currentRouteName != '/studentDetails') {
            print(currentRouteName);
            print("Test");
            Navigator.pushReplacementNamed(context, '/studentDetails',
                arguments: {
                  'userName': widget.userName,
                  'userSurname': widget.userSurname,
                });
          }
        } else if (index == 2) {
          // ----------------------------------------------------------
          // Cerrar sesión
          teacher = null;
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      // ----------------------------------------------------------
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          backgroundColor: Colors.blue,
          icon: Icon(Icons.assignment, color: Colors.white),
          label: 'Tareas',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.blue,
          icon: Icon(Icons.person, color: Colors.white),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.blue,
          icon: Icon(Icons.logout, color: Colors.white),
          label: 'Cerrar Sesión',
        ),
      ],
    );
  }

  void navigateToRoute(BuildContext context, String newRouteName,
      [Map<String, dynamic> Function()? getArguments]) {
    String currentRouteName = ModalRoute.of(context)?.settings.name ?? '';

    if (currentRouteName != newRouteName) {
      print(currentRouteName);
      print("Navigating to $newRouteName");

      Map<String, dynamic>? arguments;
      if (getArguments != null) {
        arguments = getArguments();
      }

      Navigator.pushReplacementNamed(context, newRouteName,
          arguments: arguments);
    }
  }
}
