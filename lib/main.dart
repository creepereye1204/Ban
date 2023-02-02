import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ban/Function/function.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:workmanager/workmanager.dart';
import 'Notification_Service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'Start Screen/start_screen.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
final Map<String,String> Image_Path={'Start_Screen':'assets/images/start_screen.svg','Home_Body_Background':'assets/images/Home_Body_Background.svg','Station_List_Background':'assets/images/Station_List_Background.svg','Predicted_Time_Background':'assets/images/Predicted_Time_Background.svg'};
final logger=Logger(printer: PrettyPrinter());
final My_Server='Private';


Timer ?timer;
Timer ?timer_That_Will_Be_Used_In_Predicted;
String Exact_Bus='';//중요!
String Exact_Station='';
String Picked_Bus='';

List<String> Bus_List=[];
List<String> Sub_Bus_List=[];
List<String> Bus_Station_List=[];
List<List<String>> Bus_Location_List=[];
List<bool> Bus_touched_List=[];
List<bool> ListView_touched_List=[];
dynamic Responded_Value='';
dynamic Responded_Station_Value='';
dynamic Responded_Location_value='';
dynamic Responded_Predicted_Value='';

const Notification_Task = "Notification_Task";






void startForegroundService() async {
  ForegroundService().start();
  logger.i('forge');
}
void callbackDispatcher() {
  var gogo=true;
  dynamic Stacked_Bus='';
  dynamic Station='';
  List<String> Start_End=[];
  int Countter=0;
  String Current_Station='';
  bool Stucked=false;
  bool Start_Task=false;
  bool Kick_Back=false;
  Workmanager().executeTask((task, inputData) async{
    switch (task) {
      case Notification_Task :
        int num=1000;
        NotificationService().initializeNotification();
        logger.wtf('시...작!');

        await Get_Bus_Station_List(inputData!['1'][0]).then((value){
          Station=jsonDecode(value);
        });


        while(gogo) {
          logger.e('시...작!');
          logger.e(inputData!['1'][0].toString());
          sleep(Duration(seconds: 1));





          await Get_Bus_Location_List(inputData!['1'][0].toString()).then((value) {
            Stacked_Bus=jsonDecode(value);
            logger.i(Stacked_Bus);
            //////////////////////////////////////////////////////
            Start_End.clear();
            for(int i=0;i<Stacked_Bus.length;i++){
              logger.i(Stacked_Bus[i][1]);
              logger.e(inputData!['1'][2]);
              if(Stacked_Bus[i][1]==inputData!['1'][2]){
                Current_Station=Stacked_Bus[i][0];
              }

            }
            Countter++;
            for(int i=0;i<Station.length;i++){
              logger.wtf(Station[i].toString());
              logger.w(Current_Station);
              if(Station[i][0].toString()==Current_Station){
                Kick_Back=true;
              }
              else if(Station[i][0].toString()==inputData['1'][1]){
                Kick_Back=false;
                break;
              }
              else if(Kick_Back){
                for(int j=0;j<Stacked_Bus.length;j++){
                  if(Stacked_Bus[j][0]==Station[i][0].toString()){
                    Countter++;
                  }
                }
              }
            }
            logger.i('This is Graph');
            logger.i(Countter);
            //////////////////////////////////////////////////
            sleep(Duration(seconds: 2));
            logger.i(Countter.toString(),'이거 버스임');

          if(Countter<2){
            Start_Task=true;
          }
          });
          Countter=0;


          if(Start_Task) {
            await Get_Predicted_Arriaval_Time(
                inputData!['1'][0].toString(), inputData!['1'][1].toString())
                .then((value) =>
            num = int.parse(jsonDecode(value)[0]))
                .then((value) => logger.i(num))
                .then((value) => sleep(Duration(seconds: 3)))
                .then((value) {
              if (num < 4) {
                NotificationService().showNotification(
                    2, 'Hi Guys', 'I am Mahdi');

                gogo = false;
              }
            });
          }

          }


        }

    return Future.value(true);
  });

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]);
  runApp(const BAN());
  // startForegroundService();
}

