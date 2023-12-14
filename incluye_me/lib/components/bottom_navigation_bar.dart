import 'package:flutter/material.dart';

import '../globals/globals.dart';
import '../views/task_list.dart';
import '../views/user_list.dart';
import '../views/mostrar_usuario.dart';
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
      backgroundColor: Colors.blue,
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
          currentBottomNavigationBarIndex = index;
        });

        if (index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UserListPage(
              userName: widget.userName,
              userSurname: widget.userSurname,
            );
          }));
        } else if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TaskListPage(
              userName: widget.userName,
              userSurname: widget.userSurname,
            );
          }));
        } else if (index == 2) {
          // Lógica para la pestaña "Chat"
        } else if (index == 3) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UserDetailsPage(
              nombre: widget.userName,
              apellidos: widget.userSurname,
              esEstudiante: false,
              userName: widget.userName,
              userSurname: widget.userSurname,
            );
          }));
        } else if (index == 4) {
          Navigator.pushNamed(context, '/');
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
