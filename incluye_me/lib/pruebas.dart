

import 'package:incluye_me/globals/globals.dart';
import 'package:incluye_me/model/student.dart';

Future<void> main() async {
  var contenido = await dbDriver.listaTareasGenerales();
  print(contenido);

  dbDriver.close();
}