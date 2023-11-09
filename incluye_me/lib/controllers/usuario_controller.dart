import '../model/logic_database.dart';
import 'package:flutter/material.dart';

class Controller {
  final LogicDatabase _logicDatabase = LogicDatabase();

   Future<void> loadUsersIds(var estudiantes, var supervisor, var usuarios) async {
    estudiantes = await _logicDatabase.listaEstudiantes(); 
    supervisor = await _logicDatabase.listaPersonal() ; 
    usuarios.addAll(estudiantes);
    usuarios.addAll(supervisor);
  
   }
} 


