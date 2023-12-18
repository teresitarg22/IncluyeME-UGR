import 'package:flutter/material.dart';

import '../globals/globals.dart';
import '../views/tasks/task_list.dart';
import '../views/user_list.dart';
import '../views/user_details.dart';
import 'package:incluye_me/main.dart';

class CustomNavigationBar extends StatefulWidget {
  final String userName;
  final String userSurname;

  const CustomNavigationBar(
      {required this.userName, required this.userSurname});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentIndex = currentBottomNavigationBarIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int index) {
        if (index == 0) {
          String currentRouteName = ModalRoute.of(context)?.settings.name ?? '';
          if (currentRouteName != '/userList') {
            print(currentRouteName);
            print("Test");
            Navigator.pushReplacementNamed(context, '/userList', arguments: {
              'userName': teacher!.getName(),
              'userSurname': teacher!.getSurnames(),
            });
          }
        } else if (index == 1) {
          // Lógica para la pestaña "Tareas"
          String currentRouteName = ModalRoute.of(context)?.settings.name ?? '';
          if (currentRouteName != '/taskList') {
            print(currentRouteName);
            print("Test");
            Navigator.pushReplacementNamed(context, '/taskList', arguments: {
              'userName': teacher!.getName(),
              'userSurname': teacher!.getSurnames(),
            });
          }

        } else if (index == 2) {
          // Lógica para la pestaña "Gráficos"
        } else if (index == 3) {
          // Lógica para la pestaña "Chat"
        } else if (index == 4) {
          String currentRouteName = ModalRoute.of(context)?.settings.name ?? '';
          if (currentRouteName != '/userDetails') {
            print(currentRouteName);
            print("Test");
            Navigator.pushReplacementNamed(context, '/userDetails');
          }
        } else if (index == 5) {
          teacher = null;
          Navigator.pushReplacementNamed(context, '/');
        }
      },
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
          icon: Icon(Icons.bar_chart, color: Colors.white),
          label: 'Gráficos',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.blue,
          icon: Icon(Icons.chat, color: Colors.white),
          label: 'Chat',
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
