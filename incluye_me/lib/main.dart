import 'package:flutter/material.dart';
import 'package:incluye_me/views/start_view.dart';
import 'views/registro.dart';
import 'views/user_list.dart';

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
<<<<<<< HEAD
        '/principal': (context) => TestPrincipalView(),
        '/userList': (context) => UserListPage()
=======
        '/userList': (context) => UserListPage(),
>>>>>>> 0b57cf62df614001c48f15c1ba45585b155992fc
      },
    );
  }
}

// -------------------------------------------------------------------


