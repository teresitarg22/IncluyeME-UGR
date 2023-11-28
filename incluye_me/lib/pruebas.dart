

import 'package:incluye_me/model/database_driver.dart';
import 'package:incluye_me/model/teacher.dart';
import 'package:incluye_me/model/general_task.dart';

main() async {

  DataBaseDriver dbDriver =  DataBaseDriver();

  var result = await dbDriver.getPaso(1);
  print(result);

  dbDriver.close();

}