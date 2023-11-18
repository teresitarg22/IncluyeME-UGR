import '../model/logic_database.dart';
import 'package:flutter/material.dart';

class RegistroController {
  final LogicDatabase _logicDatabase = LogicDatabase();

  // ----------------------------------------------------

  Future<void> handleRegister(
      String nombre,
      String apellidos,
      String? imagenesContrasenia,
      String? passwd,
      String? correoElectronicoAlumno,
      String imageHex,
      String tipoLetra,
      String mayMin,
      String selectedOptions,
      bool sabeLeer) async {
    await _logicDatabase.registrarEstudiante(
        nombre,
        apellidos,
        imagenesContrasenia,
        correoElectronicoAlumno,
        passwd,
        imageHex,
        tipoLetra,
        mayMin,
        selectedOptions,
        sabeLeer);
  }

  // ----------------------------------------------------

  Future<void> handleRegisterProfesor(
      String nombre,
      String apellidos,
      String correoElectronicoProfesor,
      String passwd,
      var image,
      bool esAdmin,
      var aulasProfesor) async {
    await _logicDatabase.registrarProfesor(
        nombre, apellidos, correoElectronicoProfesor, passwd, image, esAdmin);
    if (aulasProfesor.isNotEmpty) {
      for (var aula in aulasProfesor) {
        // Verificar si el aula ya existe
        var aulaResult = await _logicDatabase.comprobarAula(aula);
        // Si el aula no existe, insertarla
        if (aulaResult.isEmpty) {
          await _logicDatabase.insertarAula(aula);
        }
        await _logicDatabase.insertarImparteEn(aula, nombre, apellidos);
      }
    }
  }

  // ----------------------------------------------------
  Future<List<Map<String, Map<String, dynamic>>>> comprobarEstudianteController(
      String nombre, String apellidos) async {
    return await _logicDatabase.comprobarEstudiante(nombre, apellidos);
  }

  // ----------------------------------------------------
  Future<List<Map<String, Map<String, dynamic>>>> comprobarPersonalController(
      String nombre, String apellidos) async {
    return await _logicDatabase.comprobarPersonal(nombre, apellidos);
  }

  // ----------------------------------------------------
  Future<List<Map<String, Map<String, dynamic>>>>
      comprobarPersonalCorreoController(String correo) async {
    return await _logicDatabase.comprobarPersonalCorreo(correo);
  }

  // ----------------------------------------------------
  void llevarMostrarUsuarios(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/userList');
  }

  // ----------------------------------------------------
  Future<List<Map<String, Map<String, dynamic>>>> listaAulas() async {
    return await _logicDatabase.listaAulas();
  }
}
