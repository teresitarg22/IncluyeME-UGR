import 'package:flutter/material.dart';
import 'package:incluye_me/views/start_view.dart';
import 'views/registro.dart';
import 'views/listado_usuarios.dart';
import 'views/test_principal_view.dart';

// -------------------------------------------------------------------

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => StartView(),
        '/registroPage': (context) => HomeScreen(),
        '/principal': (context) => TestPrincipalView(),
        '/userList': (context) => UserListPage()
      },
    );
  }
}

// -------------------------------------------------------------------


