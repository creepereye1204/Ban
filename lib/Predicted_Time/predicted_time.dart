import 'dart:async';
import 'dart:convert';
import 'package:workmanager/workmanager.dart';
import 'package:ban/Function/function.dart';
import 'package:ban/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:flutter_svg/svg.dart';
final Predicted_Time_Background=Image_Path['Predicted_Time_Background'];

class Predicted_Time extends StatefulWidget {
  const Predicted_Time({Key? key}) : super(key: key);

  @override
  State<Predicted_Time> createState() => _Predicted_TimeState();
}

class _Predicted_TimeState extends State<Predicted_Time> {

  @override
  void initState() {
    // ForegroundService().start();
    timer_That_Will_Be_Used_In_Predicted=Timer.periodic(Duration(seconds: 10), (timer) {

      Get_Predicted_Arriaval_Time(Exact_Bus, Exact_Station).then((value){
        Responded_Predicted_Value=jsonDecode(value);


      });
      if(this.mounted){
        setState(() {

        });
      }

    });
    super.initState();
  }
  @override
  void dispose() {
    timer_That_Will_Be_Used_In_Predicted?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      appBar: AppBar(actions: <Widget>[ ElevatedButton(onPressed: () {
        Workmanager().cancelAll();
        ForegroundService().stop();
      }, child: Icon(Icons.cancel_outlined),),]),
      body: Stack(
      children: [
        SvgPicture.asset
          (
          Predicted_Time_Background!,
          fit: BoxFit.cover,
        ),
        Positioned.fill(


            child: Align(alignment: Alignment.center,child: Text(Responded_Predicted_Value.toString(),style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50,
              color: Colors.deepPurpleAccent
            ),)))
      ],
    ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.exit_to_app),
        ),

    ),);
  }
}
