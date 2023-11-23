import 'package:incluye_me/model/database_driver.dart';
import 'package:incluye_me/model/teacher.dart';

int currentBottomNavigationBarIndex = 0;
DataBaseDriver dbDriver =  DataBaseDriver();
Teacher? teacher; //Si es nulo, no hay ningún profesor logueado
