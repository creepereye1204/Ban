import 'dart:convert';
import 'package:ban/Home/home.dart';
import 'package:http/http.dart' as http;
import 'package:ban/main.dart';
final int Int=0;
final Unexpected_Error='Unexpected Error';









Future<String> Get_Bus_List (Bus_Number) async{

  Map<String,String> ask={'BUS_NUMBER':Bus_Number};
  final uri = Uri.http(My_Server,'/GetBusList');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: ask ,
  );


  return utf8.decode(response.bodyBytes);
}

Future<String> Get_Bus_Station_List (Bus_ID) async{
  Map<String,String> ask={'Bus_RouteId':Bus_ID};
  final uri = Uri.http(My_Server,'/GetStationList');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: ask ,
  );


  return utf8.decode(response.bodyBytes);
}


Future<String> Get_Bus_Location_List (Bus_ID) async{
  Map<String,String> ask={'Bus_RouteId':Bus_ID};
  final uri = Uri.http(My_Server,'/Bus_Location_List');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: ask ,
  );


  return utf8.decode(response.bodyBytes);
}

Future<String> Get_Predicted_Arriaval_Time(RouteID,StationID)async{
  logger.wtf(RouteID+'     '+StationID);


  Map<String,String> ask={'Station_id':StationID,'Route_id':RouteID};
  final uri = Uri.http(My_Server,'/Predict_Bus_Time');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: ask ,
  );



  return utf8.decode(response.bodyBytes);

}


Future<String> Go_Server_And_Get_Our_Goal(StationID,RouteID,Get_Or_Set)async{
  Map<String,String> ask={'Station_id':StationID,'Route_id':RouteID,'Get_Or_Set':Get_Or_Set};
  final uri = Uri.http(My_Server,'/Get_Our_Goal');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: ask ,
  );
  logger.e(utf8.decode(response.bodyBytes)+'asdasdasd');
  return utf8.decode(response.bodyBytes);
}