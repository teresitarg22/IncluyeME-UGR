import 'user.dart';

class Estudiante extends User {
  String tipo_letra;
  String maymin;
  String formato;
  String contrasenia_iconos;
  bool sabeLeer;

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
}
