import 'dart:convert';
import 'dart:typed_data';

class Tarea {
  String titulo;
  List<int> indicesPasos;
  String propietario;
  List<Paso> pasos = [];

  Tarea({required this.titulo, this.indicesPasos = const [], required this.propietario});

  @override
  String toString() {
    return 'Tarea(titulo: $titulo, indicesPasos: $indicesPasos, propietario: $propietario)';
  }

  factory Tarea.fromJson(Map<String, dynamic> json_raw) {
    //Null check
    if (json_raw.isEmpty) {
      return Tarea(
        titulo: '',
        indicesPasos: [],
        propietario: '',
      );
    }
    var json = json_raw[0]['tareas'];
    print(json);
    //Imprime los datos separados de la variable json
    return Tarea(
      titulo: json?['titulo'],
      indicesPasos: json?['indicesPasos'].cast<int>(),
      propietario: json?['propietario'],
    );
  }

  // Nuevo método para establecer los pasos
  void setPasos(List<Paso> nuevosPasos) {
    pasos = nuevosPasos;
  }
}

class Paso {
  String descripcion;
  String propietario;
  Uint8List imagen;

  Paso({required this.descripcion, required this.propietario, required this.imagen});

  factory Paso.fromJson(List<Map<String, Map<String, dynamic>>> json_raw) {
    //Null check
    if (json_raw.isEmpty) {
      return Paso(
        descripcion: '',
        propietario: '',
        imagen: Uint8List(0),
      );
    }
    var json = json_raw[0]['pasos'];
    print(json);
    //Imprime los datos separados de la variable json
    return Paso(
      descripcion: json?['descripcion'],
      propietario: json?['propietario'],
      imagen: json?['imagen'] ?? Uint8List(0),
    );
  }
}
