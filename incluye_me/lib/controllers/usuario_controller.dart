import '../model/logic_database.dart';
import 'package:flutter/material.dart';

class Controller {
  final LogicDatabase _logicDatabase = LogicDatabase();

  Future<List<Map<String, Map<String, dynamic>>>> listaEstudiantes() async {
    return await _logicDatabase.listaEstudiantes();
  }

  Future<List<Map<String, Map<String, dynamic>>>> listaPersonal() async {
    return await _logicDatabase.listaPersonal();
  }

  Future<List<Map<String, Map<String, dynamic>>>> getEstudiante(
      String nombre, String apellidos) async {
    return await _logicDatabase.comprobarEstudiante(nombre, apellidos);
  }

  Future<List<Map<String, Map<String, dynamic>>>> getPersonal(
      String nombre, String apellidos) async {
    return await _logicDatabase.comprobarPersonal(nombre, apellidos);
  }

  Future<bool> esAdmin(String nombre, String apellidos) async {
    var value = await _logicDatabase.comprobarPersonal(nombre, apellidos);

    if (value.isNotEmpty) {
      var personalData = value[0]['personal'];

      if (personalData != null && personalData['es_admin'] == true) {
        return true;
      }
    }

    return false;
  }

  Future<bool> esUsuarioEstudiante(String nombre, String apellidos) async {
    var value = await _logicDatabase.comprobarEstudiante(nombre, apellidos);

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
}
