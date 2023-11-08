import 'dart:convert';

import 'package:postgres/postgres.dart';

void main() {
  var driver = DataBaseDriver();
  driver.connect();

  //Pide solo los campos de la tabla estudiante

  print('--------------------------------------------------');
  print('Pide solo los campos de la tabla estudiante');
  print('--------------------------------------------------');


  DataBaseDriver().connect().request("SELECT * FROM personal").then((value) =>
      print(value)
  );
  
  DataBaseDriver().connect().verifyPassword("profesor1@email.com", "12345").then((value) => print(value));

  





}


class DataBaseDriver {
  PostgreSQLConnection? connection;

  DataBaseDriver connect() {
    connection = PostgreSQLConnection(
      'flora.db.elephantsql.com', // host de la base de datos
      5432, // puerto de la base de datos
      'srvvjedp', // nombre de la base de datos
      username: 'srvvjedp', // nombre de usuario de la base de datos
      password:
      'tuZz6S15UozErJ7aROYQFR3ZcThFJ9MZ', // contraseña del usuario de la base de datos
    );
    return this;
  }

  close() {
    connection?.close();
  }

  Future<List<Map<String, Map<String, dynamic>>>> request(String query) async {
    List<Map<String, Map<String, dynamic>>> results = [];

    try {
      // Verificar si la conexión está cerrada antes de intentar abrirla
      if (connection!.isClosed) {
        await connection!.open();
        print('Connected to the database');
      }

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
    print("-------------$email----------");
    print("-------------$password----------");

    var result = await request("SELECT contrasenia FROM personal WHERE correo = '$email'");

    if (result.isEmpty) {
      return false;
    }

    var passwd = result[0]['personal']?["contrasenia"];

    return passwd == password;
  }



}
