import 'dart:convert';

import 'package:postgres/postgres.dart';


class DataBaseDriver {
  final PostgreSQLConnection? connection = PostgreSQLConnection(
  'flora.db.elephantsql.com', // host de la base de datos
  5432, // puerto de la base de datos
  'srvvjedp', // nombre de la base de datos
  username: 'srvvjedp', // nombre de usuario de la base de datos
  password:
  'tuZz6S15UozErJ7aROYQFR3ZcThFJ9MZ', // contraseña del usuario de la base de datos;
  );// ;

  // Constructor

  connect() async {
    if (connection?.isClosed == true) await connection?.open();
  }

  close() {
    connection?.close();
  }

  Future<List<Map<String, Map<String, dynamic>>>> request(String query) async {
    List<Map<String, Map<String, dynamic>>> results = [];
    await connect();

    try {
      results = await connection!.mappedResultsQuery(query);
    } catch (e) {
      print('Error: $e');
    } finally {
      // No cerrar la conexión aquí
      print('Query executed');
    }

    return results;
  }

  Future<List<Map<String, Map<String, dynamic>>>> requestStructure(String table) async {
    return await request("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '$table'");
  }

  Future<List<Map<String, Map<String, dynamic>>>> requestTables() async {
    return await request("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE'");
  }

  Future<List<Map<String, Map<String, dynamic>>>> requestDataFromPersonal(String email) async {
    return await request("SELECT nombre,apellidos,correo,foto,es_admin FROM personal WHERE correo = '$email'");
  }

  Future<bool> verifyPassword(String email, String password) async {
    var result = await request("SELECT contrasenia FROM personal WHERE correo = '$email'");
    if (result.isEmpty) {
      return false;
    }
    var passwd = result[0]['personal']?["contrasenia"];
    return passwd == password;
  }

  Future<void> registrarEstudiante(
      String nombre,
      String apellidos,
      String? imagenesContrasenia,
      String? correo,
      String? contrasena,
      var imageHex,
      String tipoLetra,
      String mayMin,
      var selectedOptions,
      bool sabeLeer) async {
    await request(
        "INSERT INTO estudiante (nombre, apellidos, contrasenia_iconos, contrasenia, correo, foto, tipo_letra, maymin, formato, sabe_leer) VALUES ('$nombre', '$apellidos', '$imagenesContrasenia', '$contrasena', '$correo',  E'\\\\x$imageHex',  '$tipoLetra', '$mayMin', '$selectedOptions', '$sabeLeer')");
  }

  // ----------------------------------------------------
  //Registrar profesor en la base de datos
  Future<void> registrarProfesor(String nombre, String apellidos, String correo,
      var contrasena, var foto, bool esAdmin) async {
    await request(
        "INSERT INTO personal (nombre, apellidos, contrasenia, correo, foto, es_admin) VALUES ('$nombre', '$apellidos', '$contrasena', '$correo', '$foto', '$esAdmin')");
  }

  // ----------------------------------------------------
  // Comprobar si estudiante ya existe por nombre y apellidos
  Future<List<Map<String, Map<String, dynamic>>>> comprobarEstudiante(
      String nombre, String apellidos) async {
    return await request(
        "SELECT * FROM estudiante WHERE nombre = '$nombre' AND apellidos = '$apellidos'");
  }

  // ----------------------------------------------------
  // Comprobar si existe personal por nombre y apellidos (profesor o administrador)
  Future<List<Map<String, Map<String, dynamic>>>> comprobarPersonal(
      String nombre, String apellidos) async {
    return await request(
        "SELECT * FROM personal WHERE nombre = '$nombre' AND apellidos = '$apellidos'");
  }

  // ----------------------------------------------------
  // Comprobar si existe personal por correo
  Future<List<Map<String, Map<String, dynamic>>>> comprobarPersonalCorreo(
      String correo) async {
    return await request("SELECT * FROM personal WHERE correo = '$correo'");
  }

  // ----------------------------------------------------
  // Comprobar si un aula ya existe por su nombre.
  Future<List<Map<String, Map<String, dynamic>>>> comprobarAula(
      String nombre) async {
    return await request("SELECT * FROM aula WHERE nombre = '$nombre'");
  }

  // ----------------------------------------------------
  // Insertar Aula.
  Future<void> insertarAula(String nombre) async {
    await request("INSERT INTO aula (nombre) VALUES ('$nombre')");
  }

  // ----------------------------------------------------
  // Insertar en la tabla imparte_en el nombre y apeliidos  del profesor y el nombre del aula
  Future<void> insertarImparteEn(
      String nombre, String apellidos, String aula) async {
    await request(
        " INSERT INTO imparte_en (nombre_aula, nombre_personal, apellidos_personal) VALUES ('$aula', '$nombre', '$apellidos')");
  }

  // ----------------------------------------------------
  Future<List<Map<String, Map<String, dynamic>>>> Login(
      String email, String password) async {
    return await request(
        "SELECT * FROM personal WHERE correo = '$email' AND contrasenia = '$password'");
  }

  // ----------------------------------------------------
  //Funcion para sacar lista de estudiantes.
  Future<List<Map<String, Map<String, dynamic>>>> listaEstudiantes() async {
    return await request("SELECT * FROM estudiante");
  }

  // ----------------------------------------------------
  // Funcion para sacar lista de personal.
  Future<List<Map<String, Map<String, dynamic>>>> listaPersonal() async {
    return await request("SELECT * FROM personal");
  }

  // ----------------------------------------------------
  // Funcion para elimiar estudiante.
  Future<void> eliminarEstudiante(String nombre, String apellidos) async {
    await request(
        "DELETE FROM estudiante WHERE nombre = '$nombre' AND apellidos = '$apellidos'");
  }

}
