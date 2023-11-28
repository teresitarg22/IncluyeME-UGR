import 'package:incluye_me/globals/globals.dart';
import 'package:incluye_me/model/general_task.dart';
// -------------------------------------------

class Controller {
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
  Future<List<Map<String, Map<String, dynamic>>>> listaTareasComanda() async {
    return await dbDriver.listaTareasComanda();
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> listaTareasGenerales() async {
    return await dbDriver.listaTareasGenerales();
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> listaTareasMaterial() async {
    return await dbDriver.listaTareasMaterial();
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> listaTareas() async {
    return await dbDriver.listaTareas();
  }

  // -----------------------------
  Future<void> eliminarTarea(int id) async {
    await dbDriver.eliminarTarea(id);
  }

  // -----------------------------
  Future<String> tipoTarea(int id) async {
    var general = await dbDriver.esTareaGeneral(id);
    var material = await dbDriver.esTareaMaterial(id);
    var comanda = await dbDriver.esTareaComanda(id);

    if (general.isNotEmpty) {
      return "general";
    } else if (material.isNotEmpty) {
      return "material";
    } else if (comanda.isNotEmpty) {
      return "comanda";
    }

    return "error";
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> getTareaGeneral(
      int id) async {
    return await dbDriver.getTareaGeneral(id);
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> getTareaMaterial(
      int id) async {
    return await dbDriver.getTareaMaterial(id);
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> getTareaComanda(
      int id) async {
    return await dbDriver.getTareaComanda(id);
  }

  // -----------------------------
  Future<bool> esTareaAsignada(int id) async {
    var asignada = await dbDriver.esTareaAsignada(id);

    if (asignada.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> getTareaAsignada(
      int id) async {
    return await dbDriver.getTareaAsignada(id);
  }

  // -----------------------------
  Future<void> addTareaGeneral(List<int> indicesPasos, String nombre, String propietario) async {
    await dbDriver.insertarTareaGeneral(indicesPasos, nombre, propietario);
  }

  Future<List<int>> insertarPasosYObtenerIds(List<Paso> pasos) async {
    List<int> ids = [];
    for (var paso in pasos) {
      int id = await dbDriver.insertarPaso(paso);
      ids.add(id);
    }
    return ids;
  }

  Future<List<Paso>> obtenerDetallesPasos(List<int> idsPasos) async {
    List<Paso> detallesPasos = [];
    for (var idPaso in idsPasos) {
      Paso paso = await dbDriver.getPaso(idPaso);
      detallesPasos.add(paso);
    }
    return detallesPasos;
  }

  // -----------------------------
}
