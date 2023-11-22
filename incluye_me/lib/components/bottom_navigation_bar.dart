import 'package:flutter/material.dart';

import '../globals/globals.dart';

class CustomNavigationBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF29DA81),
      currentIndex: 0,
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
          backgroundColor: Color(0xFF29DA81),
          icon: Icon(Icons.people, color: Colors.white),
          label: 'Usuarios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment, color: Colors.white),
          label: 'Tareas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart, color: Colors.white),
          label: 'Gráficos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat, color: Colors.white),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.white),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout, color: Colors.white),
          label: 'Cerrar Sesión',
        ),
      ],
    );
  }
}
