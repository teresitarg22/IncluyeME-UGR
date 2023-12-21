

import 'package:incluye_me/globals/globals.dart';
import 'package:incluye_me/model/student.dart';

Future<void> main() async {
  var contenido = await dbDriver.getTareaCompletada(669);
  print(contenido);

  dbDriver.close();
}