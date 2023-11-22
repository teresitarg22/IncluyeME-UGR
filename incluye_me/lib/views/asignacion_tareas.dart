import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:incluye_me/model/user.dart';
import 'package:incluye_me/model/estudiante.dart';
import './mostrar_usuario.dart';
import './user_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'edit_user.dart';
import '../controllers/usuario_controller.dart';
import '../controllers/session_controller.dart';
import 'package:incluye_me/views/pedir_material.dart';
// ----------------------------------------------------------

class TareaDetailsPage extends StatefulWidget {
  final String nombre;
  final String apellidos;
  final bool esEstudiante;
  final String userName;
  final String userSurname;

  const TareaDetailsPage(
      {super.key,
      required this.nombre,
      required this.apellidos,
      required this.esEstudiante,
      required this.userName,
      required this.userSurname});
  @override
  _TareaDetailsPageState createState() => _TareaDetailsPageState();
}

class _TareaDetailsPageState extends State<TareaDetailsPage> {
  bool isAdmin = false;
  var estudiantes = [];
  var personal = [];
  var usuarios = [];
  Controller controlador = Controller();

  SessionController sessionController = SessionController();

  String? selectedFilter = "Estudiantes";

  void userLogout() async {
    await sessionController.logout();
    Navigator.of(context).pushReplacementNamed('/');
  }

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();
  // -------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creacion de Tareas'),
        backgroundColor: const Color(0xFF29DA81),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF29DA81),
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 20), // Increase padding
                textStyle: const TextStyle(
                    fontSize: 20), // Increase text size
              ),
              onPressed: () {
                // Navigate to the PedirMaterial screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PedirMaterial()),
                );
              },
              child: const Text('Material', style: TextStyle(color: Colors.white, fontSize: 50)),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF29DA81), // Color personalizado
        currentIndex: 1,
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UserListPage(
                userName: widget.userName,
                userSurname: widget.userSurname,
              );
            }));
          } else if (index == 1) {
            // Lógica para la pestaña "Tareas"
          } else if (index == 2) {
            // Lógica para la pestaña "Gráficos"
          } else if (index == 3) {
            // Lógica para la pestaña "Chat"
          } else if (index == 4) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UserDetailsPage(
                nombre: widget.userName,
                apellidos: widget.userSurname,
                esEstudiante: false,
                userName: widget.userName,
                userSurname: widget.userSurname,
              );
            }));
          } else if (index == 5) {
            userLogout();
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: Colors.white),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF29DA81), // Color
            icon: Icon(Icons.assignment, color: Colors.white),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: Colors.white),
            label: 'Gráficos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.white),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout, color: Colors.white),
            label: 'Cerrar Sesión',
          ),
        ],
      ),
    );
  }
}