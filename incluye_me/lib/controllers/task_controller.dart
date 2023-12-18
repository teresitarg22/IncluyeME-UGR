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
  Future<void> addMaterialToStudent (String nombreEntero, String aula, List<String> material, List<int> cantidad, List<String> hecho) async {
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
    
    await dbDriver.insertarTareaMaterial(mail, nombre, apellidos, aula, materialInt, cantidad, hecho);
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> getTarea(int id) async {
    return await dbDriver.getTarea(id);
  }

  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> getTareaAsignadaPorEstudiante(
      String nombre, String apellidos) async {
    return await dbDriver.getTareasAsignadas(nombre, apellidos);
  }

  // -----------------------------
  Future<bool> esTareaCompletada(int id) async {
    var completada = await dbDriver.getTareaCompletada(id);

    if (completada.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //---------------------------------
  Future<bool> esTareaSemamal(int id) async {
    var semanal = await dbDriver.getTareaSemanal(id);

    if (semanal.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //---------------------------------
  Future<String> alumnoAsignado(int id) async {
    var asignado = await getTareaAsignada(id);
    if (asignado.isNotEmpty) {
      return asignado[0]['asignada']?['nombre_alumno'] +
          " " +
          asignado[0]['asignada']?['apellido_alumno'];
    } else {
      return "";
    }
  }
  
  // -----------------------------
  Future<List<Map<String, Map<String, dynamic>>>> getListMaterial(int id) async {
    List<Map<String, Map<String, dynamic>>> lista = await dbDriver.getListMaterial(id);
    
    List<String> temp_list = [];

    for (int i = 0; i < lista[0]['tarea_material']!['material'].length; i++)
    {
      List<Map<String, Map<String, dynamic>>> temp = await dbDriver.materialIDToNombre(lista[0]['tarea_material']!['material'][i]);
      temp_list.add(temp[0]['lista_material']!['nombre']);
    }
    lista[0]['tarea_material']!['material'] = temp_list;
    return lista;
  }

  Future<void> saveHechoMaterial(List<bool> hecho, int ID) async {
    String hecho_list = "{${hecho[0]}";
    for(int i = 1; i<hecho.length; i++)
    {
        hecho_list = "$hecho_list, ${hecho[i]}";
    }
    hecho_list = "$hecho_list}";
    await dbDriver.saveHechoMaterial(hecho_list, ID);
  }

  Future<void> taskDone(int ID) async {
    await dbDriver.taskDone(ID);
  }
}
