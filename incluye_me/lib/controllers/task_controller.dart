import '../model/logic_database.dart';

// -------------------------------------------

class Controller {
  final LogicDatabase _logicDatabase = LogicDatabase();

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

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> listaTareasComanda() async {
    return await _logicDatabase.listaTareasComanda();
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> listaTareasGenerales() async {
    return await _logicDatabase.listaTareasGenerales();
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> listaTareasMaterial() async {
    return await _logicDatabase.listaTareasMaterial();
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> listaTareas() async {
    return await _logicDatabase.listaTareas();
  }

  // -----------------------------
  Future<void> eliminarTarea(int id) async {
    await _logicDatabase.eliminarTarea(id);
  }

  // -----------------------------
  Future<String> tipoTarea(int id) async {
    var general = await _logicDatabase.esTareaGeneral(id);
    var material = await _logicDatabase.esTareaMaterial(id);
    var comanda = await _logicDatabase.esTareaComanda(id);

    if (general.isNotEmpty) {
      return "general";
    } else if (material.isNotEmpty) {
      return "material";
    } else if (comanda.isNotEmpty) {
      return "comanda";
    }

    return "error";
  }
}
