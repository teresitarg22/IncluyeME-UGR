import 'package:flutter/material.dart';
import '../globals/globals.dart';

class CustomNavigationBar extends StatefulWidget {
  final String userName;
  final String userSurname;

  const CustomNavigationBar(
      {super.key, required this.userName, required this.userSurname});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

// ----------------------------------------------------------

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentIndex = currentBottomNavigationBarIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
          currentBottomNavigationBarIndex = index;
        });
        // -----------------------
        if (index == 0) {
          // ----------------------------------------------------------
          // Lista de usuarios
          String currentRouteName = ModalRoute.of(context)?.settings.name ?? '';
          if (currentRouteName != '/userList') {
            print(currentRouteName);
            print("Test");
            Navigator.pushReplacementNamed(context, '/userList');
          }
        } else if (index == 1) {
          // ----------------------------------------------------------
          // Lista de tareas
          String currentRouteName = ModalRoute.of(context)?.settings.name ?? '';
          if (currentRouteName != '/taskList') {
            Navigator.pushReplacementNamed(context, '/taskList');
          }
        } else if (index == 2) {
          // ----------------------------------------------------------
          // Detalles del usuario
          String currentRouteName = ModalRoute.of(context)?.settings.name ?? '';
          if (currentRouteName != '/userDetails') {
            Navigator.pushReplacementNamed(context, '/userDetails');
          }
        } else if (index == 3) {
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
          icon: Icon(Icons.people, color: Colors.white),
          label: 'Usuarios',
        ),
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

  // ----------------------------------------------------------

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
