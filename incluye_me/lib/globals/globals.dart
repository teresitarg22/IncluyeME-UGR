import 'package:incluye_me/model/database_driver.dart';
import 'package:incluye_me/model/student.dart';
import 'package:incluye_me/model/teacher.dart';

int currentBottomNavigationBarIndex = 0;
DataBaseDriver dbDriver = DataBaseDriver();

Teacher? teacher; // Si es nulo, no hay ningún profesor logueado
Estudiante? student_global; // Si es nulo, no hay ningún estudiante logueado
int imageHeight = 256;
int imageWidth = 256;

List<Estudiante>? studentList;
