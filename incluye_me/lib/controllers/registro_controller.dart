import 'package:incluye_me/globals/globals.dart';


import 'package:flutter/material.dart';

class RegistroController {


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
    await dbDriver.registrarEstudiante(
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
    await dbDriver.registrarProfesor(
        nombre, apellidos, correoElectronicoProfesor, passwd, image, esAdmin);
    if (aulasProfesor.isNotEmpty) {
      for (var aula in aulasProfesor) {
        // Verificar si el aula ya existe
        var aulaResult = await dbDriver.comprobarAula(aula);
        // Si el aula no existe, insertarla
        if (aulaResult!.isEmpty) {
          await dbDriver.insertarAula(aula);
        }
        await dbDriver.insertarImparteEn(aula, nombre, apellidos);
      }
    }
  }

  // ----------------------------------------------------
  Future<List<Map<String, Map<String, dynamic>>>?> comprobarEstudianteController(
      String nombre, String apellidos) async {
    return await dbDriver.comprobarEstudiante(nombre, apellidos);
  }

  // ----------------------------------------------------
  Future<List<Map<String, Map<String, dynamic>>>> comprobarPersonalController(
      String nombre, String apellidos) async {
    return await dbDriver.comprobarPersonal(nombre, apellidos);
  }

  // ----------------------------------------------------
  Future<List<Map<String, Map<String, dynamic>>>>
      comprobarPersonalCorreoController(String correo) async {
    return await dbDriver.comprobarPersonalCorreo(correo);
  }

    Future<List<Map<String, Map<String, dynamic>>>> listaAulas() async {
    return await dbDriver.listaAulas();
  }

  // ----------------------------------------------------
  void llevarMostrarUsuarios(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/userList');
  }
}