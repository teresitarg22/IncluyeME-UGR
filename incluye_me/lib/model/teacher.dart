//Clase que representa un profesor

class Teacher {
  var photo;
  bool isAdmin;
  String name;
  String surnames;
  String correo;

  Teacher({
    required this.photo,
    required this.isAdmin,
    required this.name,
    required this.surnames,
    required this.correo,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      photo: json['foto'],
      isAdmin: json['es_admin'],
      name: json['nombre'],
      surnames: json['apellidos'],
      correo: json['correo'],
    );
  }

  factory Teacher.fromJsonRaw(Map<String, dynamic> jsonRaw) {
    var json = jsonRaw['personal'];
    return Teacher(
      photo: json['foto'],
      isAdmin: json['es_admin'],
      name: json['nombre'],
      surnames: json['apellidos'],
      correo: json['correo'],
    );
  }

  static List<Teacher> fromJsonList(List<dynamic> jsonList) {
    List<Teacher> lista = [];
    for (var json in jsonList) {
      lista.add(Teacher.fromJson(json));
    }
    return lista;
  }

  static List<Teacher> fromJsonRawList(List<dynamic> jsonList) {
    List<Teacher> lista = [];
    for (var json in jsonList) {
      lista.add(Teacher.fromJsonRaw(json));
    }
    return lista;
  }

  @override
  String toString() {
    return 'Teacher{photo: $photo, isAdmin: $isAdmin, name: $name, surnames: $surnames, correo: $correo}';
  }

  getName() {
    return name;
  }

  getSurnames() {
    return surnames;
  }
}
