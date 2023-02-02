import 'dart:async';
import 'dart:convert';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:ban/Function/function.dart';
import 'package:ban/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ban/Predicted_Time/predicted_time.dart';
import '../Notification/notification_setting.dart';


class Station_List extends StatefulWidget {
  const Station_List({Key? key}) : super(key: key);

  @override
  State<Station_List> createState() => _Station_ListState();

}

class _Station_ListState extends State<Station_List> {
  final Station_List_Background=Image_Path['Station_List_Background'];
  @override
  void initState() {
    timer=Timer.periodic(Duration(seconds: 10),(timer){
      logger.e('A');


      Bus_Location_List.clear();
      Get_Bus_Location_List(Exact_Bus).then((value){
        Responded_Location_value=jsonDecode(value);
        int num=0;
        for(int i=0;i<Bus_touched_List.length;i++){
          Bus_touched_List[i]=false;
        }
        for(int i=0;i<Responded_Station_Value.length;i++){
          if(Responded_Station_Value[i][0]==Responded_Location_value[num][0]){
            if(Picked_Bus==Responded_Location_value[num][1]){
              logger.wtf(Picked_Bus.length);

              Bus_touched_List[i]=true;
            }
            Bus_Location_List.add([Responded_Location_value[num][0],Responded_Location_value[num][1],Responded_Location_value[num][2]]);
            if(num<Responded_Location_value.length-1)
            {
              num=num+1;
            }

          }
          else{
            Bus_Location_List.add(['Null','','']);
          }

        }
        if(this.mounted){
          setState(() {

          });
        }

      });




    });
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(

        appBar: AppBar(actions: <Widget>[ElevatedButton(onPressed: () {
          Workmanager().cancelAll();
          ForegroundService().stop();
        }, child: Icon(Icons.cancel_outlined),),]),
        body: Stack(
          children: [
            SvgPicture.asset
              (
              Station_List_Background!,
              fit: BoxFit.cover,
            ),
            ListView.separated(
                itemCount: Bus_Station_List.length,
                itemBuilder: (context,index){
                  return ListTile(
                    onTap: ()
                    {

                      Exact_Station=Responded_Station_Value[index][0].toString();





                      setState(() {
                        bool One_Clicked=true;
                        ListView_touched_List[index]=ListView_touched_List[index]?false:true;
                        for(int i=0;i<ListView_touched_List.length;i++)
                        {
                          if(Bus_touched_List[i]){
                            One_Clicked=false;
                          }
                          if(i!=index)
                          {
                            ListView_touched_List[i]=false;
                          }
                        }



                        Get_Predicted_Arriaval_Time(Exact_Bus, Exact_Station).then((value){
                          if(One_Clicked){
                            Responded_Predicted_Value=jsonDecode(value);
                            logger.i(Responded_Predicted_Value);
                            Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context)=>const Predicted_Time()
                            ));
                          }
                          else{
                            Responded_Predicted_Value=jsonDecode(value);
                            logger.i(Responded_Predicted_Value);
                            ForegroundService().start();
                            Get_Bus_Location_List(Exact_Bus).then((value){
                              Responded_Location_value=jsonDecode(value);
                              Workmanager().cancelAll();
                              Workmanager().registerOneOffTask(
                                  "10",
                                  Notification_Task,
                                  inputData: {'1':[Exact_Bus,Exact_Station,Picked_Bus]}//여기 수정해야함~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!

                              );
                              // Navigator.push(context, MaterialPageRoute(builder:(context)=>const notification_setting() ));
                            });
                          }


                        });



                      });
                    },
                    title: Text(Bus_Station_List[index],style: TextStyle(color: ListView_touched_List[index]?Colors.cyanAccent:null,fontSize: 20,fontWeight: FontWeight.bold),),
                    subtitle: Text(Bus_Location_List[index][1]+(Bus_Location_List[index][1]!=''?'\t잔여자석:':'')+'\t'+Bus_Location_List[index][2]),
                    trailing: Bus_Location_List[index][0]=='Null'?null:IconButton(icon: Icon(Icons.directions_bus_sharp), color: Bus_touched_List[index]?Colors.pink:null,onPressed: () {
                      setState(() {
                        Picked_Bus=Bus_Location_List[index][1];//여기 확인 해보셈
                        logger.i(Picked_Bus);
                        Bus_touched_List[index]=Bus_touched_List[index]?false:true;
                        for(int i=0;i<Bus_touched_List.length;i++)
                        {
                          if(i!=index)
                          {
                            Bus_touched_List[i]=false;
                          }
                        }
                      });
                    },),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                }
            ),

          ],
        )
    ),
    );
  }
}
