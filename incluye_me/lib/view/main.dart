import 'package:flutter/material.dart';
import 'registro.dart';
import 'listado_usuarios.dart';

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
        '/': (context) => UserListPage(),
        '/registroPage': (context) => HomeScreen(),
      },
    );
  }
}

// -------------------------------------------------------------------


