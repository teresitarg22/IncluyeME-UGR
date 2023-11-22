

import 'package:incluye_me/model/database_driver.dart';

main() async {

  DataBaseDriver dbDriver =  DataBaseDriver();

  var result = await dbDriver.request("Select * from tarea");
  print(result);
  
  dbDriver.close();

}