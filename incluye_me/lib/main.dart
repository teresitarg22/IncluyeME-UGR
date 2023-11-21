import 'package:flutter/material.dart';
import 'package:incluye_me/views/start_view.dart';
import 'globals/globals.dart';
import 'model/database_driver.dart';
import 'views/registro.dart';
import 'views/user_list.dart';

// -------------------------------------------------------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String user = "";
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const StartView(),
        '/registroPage': (context) => const HomeScreen(),
        '/userList': (context) =>
            UserListPage(userName: user, userSurname: user)
      },
    );
  }
}

// -------------------------------------------------------------------

