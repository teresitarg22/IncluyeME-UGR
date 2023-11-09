import 'package:flutter/material.dart';
import 'package:incluye_me/model/user.dart';
import 'package:incluye_me/views/start_view.dart';
import 'package:incluye_me/views/teacher_login_view.dart';
import 'views/registro.dart';
import 'views/user_list.dart';

// -------------------------------------------------------------------

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String user = "";
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => StartView(),
        '/registroPage': (context) => HomeScreen(),
        '/userList': (context) => UserListPage(user: user)
      },
    );
  }
}

// -------------------------------------------------------------------

