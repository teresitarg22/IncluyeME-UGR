class Tarea {
  String titulo;
  List<Paso> pasos;

  Tarea({required this.titulo, this.pasos = const []});

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'pasos': pasos.map((paso) => paso.toJson()).toList(),
    };
  }
}

class Paso {
  String descripcion;
  String imagen; // Ruta del archivo en assets

  Paso({required this.descripcion, required this.imagen});

  Map<String, dynamic> toJson() {
    return {
      'descripcion': descripcion,
      'imagen': imagen,
    };
  }
}
