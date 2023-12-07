import 'package:incluye_me/globals/globals.dart';

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
  Future<void> monstrarTareaMaterial (String mail, DateTime fecha) async {
    await dbDriver.monstrarTareaMaterial (mail, fecha);
  }

  Future<List<Map<String, Map<String, dynamic>>>> monstrarListaMaterial () async {
    return await dbDriver.monstrarListaMaterial ();
  }

  // -----------------------------
  Future<void> addMaterialToStudent (String nombreEntero, String aula, List<String> material, List<int> cantidad) async {
    String nombre;
    String apellidos;
    List<String> partes = nombreEntero.split(" ");
    List<int> materialInt = [];
    nombre = partes[0];
    apellidos = partes[1];
    if (partes.length == 3) {
      apellidos = apellidos + " " + partes[2];
    }
    List<Map<String, Map<String, dynamic>>> estudiante = await dbDriver.comprobarEstudiante(nombre, apellidos);
    String mail =  estudiante[0]["estudiante"]!["correo"];

    for (int i = 0; i < material.length; i++)
    {
      List<Map<String, Map<String, dynamic>>> mat = await dbDriver.materialNombreToID(material[i]);
      materialInt.add(mat[0]["lista_material"]!["id"]) ;
    }
    
    await dbDriver.insertarTareaMaterial(mail, aula, materialInt, cantidad);
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> getTarea(int id) async {
    return await dbDriver.getTarea(id);
  }
}
