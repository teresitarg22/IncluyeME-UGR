import 'package:flutter/material.dart';
import 'package:incluye_me/views/start_view.dart';
import 'package:incluye_me/views/teacher_login_view.dart';
import 'views/registro.dart';
import 'views/user_list.dart';

// -------------------------------------------------------------------

void main() {
  runApp(MyTest());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => StartView(),
        '/registroPage': (context) => HomeScreen(),
        '/userList': (context) => UserListPage()
      },
    );
  }
}


class MyTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => TeacherLoginView(),
        '/userList': (context) => UserListPage()
      },
    );
  }
}
// -------------------------------------------------------------------

