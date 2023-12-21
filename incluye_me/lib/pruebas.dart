

import 'dart:convert';

import 'package:incluye_me/globals/globals.dart';
import 'package:incluye_me/model/student.dart';
import 'dart:io';
import 'dart:typed_data';

Future<void> main() async {
  var contenido = await dbDriver.listaTareasGenerales();
  print(contenido);

  dbDriver.close();
}

Future<Uint8List?> readImageAsUint8List(String imagePath) async {
  try {
    // Crea un objeto File desde la ruta de la imagen
    File imageFile = File(imagePath);

    // Lee el archivo como bytes
    Uint8List imageBytes = await imageFile.readAsBytes();
    return imageBytes;
  } catch (e) {
    // Maneja cualquier error que pueda ocurrir
    print("Error al leer la imagen: $e");
    return null;
  }
}
