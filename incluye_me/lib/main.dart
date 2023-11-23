import 'package:flutter/material.dart';
import 'package:incluye_me/views/mostrar_usuario.dart';
import 'package:incluye_me/views/start_view.dart';
import 'globals/globals.dart';
import 'views/registro.dart';
import 'views/user_list.dart';
import 'views/general_task_manager.dart';
import 'views/add_general_task.dart';

// -------------------------------------------------------------------

void main() {
  runApp(const MyApp());
}


//Código de testeo para cerrar la base de datos cuando la app se cierra
class LifecycleWatcher extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Aquí es donde cierras la base de datos
      dbDriver.close();
    }
  }
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
        '/userList': (context) => UserListPage(userName: user, userSurname: user),
        '/userDetails': (context) => UserDetailsPage(nombre: teacher!.name, apellidos: teacher!.surnames, esEstudiante: false, userName: teacher!.name, userSurname: teacher!.surnames),
        '/tasks': (context) => TaskView(),
      },
    );
  }
}

//PRUEBA DE USER LIST
class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    String user = "Carla";
    String userSurname = "Maria";
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) =>
            UserListPage(userName: user, userSurname: userSurname),
      },
    );
  }
}




// -------------------------------------------------------------------
