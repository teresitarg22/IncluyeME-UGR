

class Aula   {
  String nombre;
  var foto ; 


 factory Aula.fromJson(Map<String, dynamic> json) {
    return Aula(
      foto: json ['personal']['foto'],
      nombre: json['imparte_en']['nombre_aula'],
    );
  }

  static List<Aula> fromJsonList(List<dynamic> jsonList) {
    List<Aula> lista = [];
    for (var json in jsonList) {
      lista.add(Aula.fromJson(json));
    }
    return lista;
  }

   @override
  String toString() {
    return '$nombre';
  }



  Aula({
    required this.nombre,
    required this.foto
  }) ;  
  
}
