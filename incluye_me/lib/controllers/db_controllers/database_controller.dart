import 'package:postgres/postgres.dart';

final connection = PostgreSQLConnection(
  'flora.db.elephantsql.com', // host de la base de datos
  5432, // puerto de la base de datos
  'srvvjedp', // nombre de la base de datos
  username: 'srvvjedp', // nombre de usuario de la base de datos
  password:
  'tuZz6S15UozErJ7aROYQFR3ZcThFJ9MZ', // contraseña del usuario de la base de datos
);

Future<void> main() async {
  await connection.open();
  print("Tablas");
  final result = await connection.query('SELECT table_name FROM information_schema.tables WHERE table_schema = \'public\'');
  print(result);
  
  print ("Usuarios");
  final result2 = await connection.query('SELECT * FROM usuario');
  //Print formated result
  print(result2);

  /*
  print ("Profesores");
  final result3 = await connection.query('SELECT * FROM personal');
  //Print formated result
  print(result3);

  print ("Aula");
  final result4 = await connection.query('SELECT * FROM aula');
  //Print formated result
  print(result4);

  print ("Estudiante");
  final result5 = await connection.query('SELECT * FROM estudiante');
  //Print formated result
  print(result5);

  print ("Imparte en");
  final result6 = await connection.query('SELECT * FROM imparte_en');
  //Print formated result
  print(result6);
  */
  
  await connection.close();
}