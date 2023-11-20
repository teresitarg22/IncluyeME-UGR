import 'package:incluye_me/globals/globals.dart';


// -------------------------------------------

class Controller {

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> listaEstudiantes() async {
    return await dbDriver.listaEstudiantes();
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> listaPersonal() async {
    return await dbDriver.listaPersonal();
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> getEstudiante(
      String nombre, String apellidos) async {
    return await dbDriver.comprobarEstudiante(nombre, apellidos);
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> getPersonal(
      String nombre, String apellidos) async {
    return await dbDriver.comprobarPersonal(nombre, apellidos);
  }

  // -----------------------------
  Future<bool> esAdmin(String nombre, String apellidos) async {
    var value = await dbDriver.comprobarPersonal(nombre, apellidos);

    if (value.isNotEmpty) {
      var personalData = value[0]['personal'];

      if (personalData != null && personalData['es_admin'] == true) {
        return true;
      }
    }

    return false;
  }

  // -----------------------------
  Future<bool> esUsuarioEstudiante(String nombre, String apellidos) async {
    var value = await dbDriver.comprobarEstudiante(nombre, apellidos);

    if (value.isNotEmpty) {
      var estudianteData = value[0]['estudiante'];

      if (estudianteData != null &&
          estudianteData['nombre'] == nombre &&
          estudianteData['apellidos'] == apellidos) {
        return true;
      }
    }

    return false;
  }

  // -----------------------------
  Future<void> eliminarEstudiante(String nombre, String apellidos) async {
    await dbDriver.eliminarEstudiante(nombre, apellidos);
  }
}
