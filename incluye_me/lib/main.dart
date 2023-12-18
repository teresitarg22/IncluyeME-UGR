import 'package:flutter/material.dart';
import 'package:incluye_me/views/start_view.dart';
import 'package:incluye_me/views/tasks/task_list.dart';
import 'package:incluye_me/views/user_details.dart';
import 'globals/globals.dart';
import 'views/register/register.dart';
import 'views/user_list.dart';

// -------------------------------------------------------------------

void main() {
  runApp(const MyApp());
}


//Código de testeo para cerrar la base de datos cuando la app se cierra
// class LifecycleWatcher extends WidgetsBindingObserver {
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.detached) {
//       // Aquí es donde cierras la base de datos
//       dbDriver.close();
//     }
//   }
// }

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
        '/taskList': (context) => const TaskListPage(userName: '', userSurname: ''),
        '/userList': (context) => UserListPage(userName: user, userSurname: user),
        '/userDetails': (context) => UserDetailsPage(nombre: teacher!.name, apellidos: teacher!.surnames, esEstudiante: false, userName: teacher!.name, userSurname: teacher!.surnames),
      },
    );
  }
}




// -------------------------------------------------------------------

