import 'package:flutter/material.dart';
import 'package:incluye_me/views/mostrar_usuario.dart';
import 'package:incluye_me/views/start_view.dart';
import 'globals/globals.dart';
import 'views/registro.dart';
import 'views/user_list.dart';
import 'package:incluye_me/globals/globals.dart';
import 'views/general_task_manager.dart';
import 'views/add_general_task.dart';
import 'controllers/task_controller.dart';

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
        '/userList': (context) =>
            UserListPage(userName: user, userSurname: user)
      },
    );
  }
}




// -------------------------------------------------------------------

