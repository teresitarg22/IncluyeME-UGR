import 'package:flutter/material.dart';

import '../globals/globals.dart';

class CustomNavigationBar extends StatefulWidget {
  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentIndex = currentBottomNavigationBarIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF29DA81),
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
          currentBottomNavigationBarIndex = index;
        });

        if (index == 0) {
          navigateToRoute(
              context,
              '/userList',
              () => {
                    'userName': teacher!.getName(),
                    'userSurname': teacher!.getSurnames(),
                  });
        } else if (index == 1) {
          navigateToRoute(context, '/tasks');
        } else if (index == 2) {
          // Lógica para la pestaña "Gráficos"
        } else if (index == 3) {
          // Lógica para la pestaña "Chat"
        } else if (index == 4) {
          navigateToRoute(
              context,
              '/userDetails');
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
          backgroundColor: Color(0xFF29DA81),
          icon: Icon(Icons.assignment, color: Colors.white),
          label: 'Tareas',
        ),
        BottomNavigationBarItem(
          backgroundColor: Color(0xFF29DA81),
          icon: Icon(Icons.bar_chart, color: Colors.white),
          label: 'Gráficos',
        ),
        BottomNavigationBarItem(
          backgroundColor: Color(0xFF29DA81),
          icon: Icon(Icons.chat, color: Colors.white),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          backgroundColor: Color(0xFF29DA81),
          icon: Icon(Icons.person, color: Colors.white),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          backgroundColor: Color(0xFF29DA81),
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
