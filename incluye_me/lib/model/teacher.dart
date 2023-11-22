

//Clase que representa un profesor


class Teacher {
  String photo;
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
}