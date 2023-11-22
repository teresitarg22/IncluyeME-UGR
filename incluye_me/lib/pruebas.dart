

import 'package:incluye_me/model/database_driver.dart';
import 'package:incluye_me/model/teacher.dart';

main() async {

  DataBaseDriver dbDriver =  DataBaseDriver();

  var result = await dbDriver.requestDataFromPersonal("profesor1@email.com");

  var teacherData = result[0]['personal'];
  print(Teacher.fromJson(teacherData!).toString());

  
  dbDriver.close();

}