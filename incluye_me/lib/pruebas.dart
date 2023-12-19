

import 'package:incluye_me/globals/globals.dart';
import 'package:incluye_me/model/student.dart';

Future<void> main() async {
  var contenido = await dbDriver.requestTables();
  print(contenido);

  contenido = await dbDriver.requestStructure("estudiante");
  print(contenido);
  contenido = await dbDriver.request("Select * from estudiante");

  //Modifica el registro Teresa y le pone el valor a contraseña_iconos a 123

  List<Estudiante> estudiantes = Estudiante.fromJsonList(contenido);


  for (var estudiante in estudiantes) {
    print(estudiante.contrasenia_iconos);
    // Convertir la contraseña a una lista de enteros con parseInt
    var contrasenia = estudiante.contrasenia_iconos.split(",").map((e) => int.parse(e)).toList();
    print(contrasenia);
  }

  dbDriver.close();
}