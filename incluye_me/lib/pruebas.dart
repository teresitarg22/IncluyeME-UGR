

import 'dart:convert';

import 'package:incluye_me/globals/globals.dart';
import 'package:incluye_me/model/student.dart';
import 'dart:io';
import 'dart:typed_data';

Future<void> main() async {
  var contenido = await dbDriver.requestTables();

  contenido = await dbDriver.requestStructure("estudiante");
  print(contenido);
  contenido = await dbDriver.request("Select tipo_letra from estudiante");
  print(contenido);



  //Convierte la imagen a base64




  //Cambia la imagen de teresa
  //await dbDriver.request("UPDATE estudiante SET foto = decode('$base64Image', 'base64') WHERE nombre = 'Juliana'");

  /*
  String nombre = "Alba";
  String apellidos = "Guisado";
  String imagenesContrasenia = "2,4,7";
  String contrasena = "studentpassword";
  String correo = "alba@email.com";
  String tipoLetra = "Arial";
  String mayMin = "Minúsculas";
  String selectedOptions = "";
  bool sabeLeer = false;
  Uint8List? imageBytes = await readImageAsUint8List("assets/imagenes_para_perfiles/chica3.png");
  String base64Image = base64Encode(imageBytes as List<int>);

  await dbDriver.request(
      "INSERT INTO estudiante (nombre, apellidos, contrasenia_iconos, contrasenia, correo, foto, "
          "tipo_letra, maymin, formato, sabe_leer) VALUES ('$nombre', '$apellidos', '$imagenesContrasenia', "
          "'$contrasena', '$correo', decode('$base64Image', 'base64') ,  '$tipoLetra', "
          "'$mayMin', '$selectedOptions', '$sabeLeer')");
   */

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
