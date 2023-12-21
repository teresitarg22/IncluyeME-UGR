import 'user.dart';

class Estudiante extends User {
  String tipo_letra;
  String maymin;
  String formato;
  String contrasenia_iconos;
  bool sabeLeer;

  factory Estudiante.fromJson(Map<String, dynamic> jsonRaw) {
    var json = jsonRaw['estudiante'];
    return Estudiante(
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      correo: json['correo'],
      foto: json['foto'],
      contrasenia: json['contrasenia'],
      tipo_letra: json['tipo_letra'],
      maymin: json['maymin'],
      formato: json['formato'],
      contrasenia_iconos: json['contrasenia_iconos'],
      sabeLeer: json['sabe_leer']
    );
  }

  static List<Estudiante> fromJsonList(List<dynamic> jsonList) {
    List<Estudiante> lista = [];
    for (var json in jsonList) {
      lista.add(Estudiante.fromJson(json));
    }
    return lista;
  }

  Estudiante({
    required nombre,
    required apellidos,
    required correo,
    required foto,
    required contrasenia,
    required this.tipo_letra,
    required this.maymin,
    required this.formato,
    required this.contrasenia_iconos,
    required this.sabeLeer,
  }) : super(
          nombre: nombre ?? '',
          apellidos: apellidos ?? '',
          correo: correo ?? '',
          foto: foto ?? '',
          contrasenia: contrasenia ?? '',
        );

  getPasswordAsList() {
    return contrasenia_iconos.split(",").map((e) => int.parse(e)).toList();
  }
}
