
import 'dart:convert';

import 'package:ban/Function/function.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:workmanager/workmanager.dart';

import '../Palette/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ban/main.dart';
import '../Station List/station_list.dart';
import 'package:ban/Function/function.dart';
String Title_Text='Bus Arrival Notification';
String Search='';




class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime? CurrentBackPressTime;
  final Home_Body_Background=Image_Path['Home_Body_Background'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (CurrentBackPressTime == null ||
            now.difference(CurrentBackPressTime!) >
                const Duration(seconds: 2)) {
          CurrentBackPressTime = now;
          Fluttertoast.showToast(
              msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: const Color(0xff6E6E6E),
              fontSize: 20,
              toastLength: Toast.LENGTH_SHORT);
          return false;
        }
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[ ElevatedButton(style: ElevatedButton.styleFrom(
            backgroundColor: Palette.Basic
          ), onPressed: () {
            Workmanager().cancelAll();
            ForegroundService().stop();
          }, child: Icon(Icons.cancel_outlined),)],
          backgroundColor: Palette.Basic,
          automaticallyImplyLeading: false,
          title: RichText(
            text: TextSpan(
                text: Title_Text,
                style: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 25,
                    color: Palette.Title,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold
                )

            ),

          ),
        ),
        body: Stack(
          children: <Widget>[
            SvgPicture.asset
              (
              Home_Body_Background!,
              fit: BoxFit.cover,
            ),
            Container(

              margin: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 40.0),


              child: TextFormField(
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (value){
                  Bus_List.clear();
                  Sub_Bus_List.clear();
                  Bus_Station_List.clear();
                  setState(()
                  {

                    if(Search.length!=0)
                    {
                      Title_Text=Search;
                      setState(() {
                        Get_Bus_List(Search).then((value) {
                          if(value[1]=='!'){
                            Responded_Value=Unexpected_Error;
                          }
                          else{
                            Responded_Value=jsonDecode(value);
                          }


                          if(Responded_Value==Unexpected_Error){
                            Bus_List.add('해당하는 버스를 찾지 못했습니다..');
                            Sub_Bus_List.add('없음...');
                            Title_Text='그런거 없어요..ㅠ';
                          }
                          else{
                            for(int i =0;i<(Responded_Value.length);i++)
                            {
                              Bus_List.add(Responded_Value[i][2].toString()+' :'+Responded_Value[i][1][0].toString());
                              Sub_Bus_List.add(Responded_Value[i][1][2].toString()+' ~ '+Responded_Value[i][1][3]+'  \n 배차간격:['+Responded_Value[i][1][4]+'분]'+'  \n ['+Responded_Value[i][1][1].toString()+']');
                            }
                          }
                          logger.i(Bus_List);
                          setState(() {

                          });
                        }
                        );
                      });;
                    }
                    else
                    {
                      Title_Text='입력해주세요';
                    }
                  });
                },
                onChanged: (value){
                  Search=value.toString();
                },
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Colors.greenAccent
                ),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Palette.Basic,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    suffixIcon: Container(


                      child: OutlinedButton(

                        onPressed:()
                        {

                          Bus_List.clear();
                          Sub_Bus_List.clear();
                          Bus_Station_List.clear();
                          setState(()
                          {

                            if(Search.length!=0)
                            {
                              Title_Text=Search;
                              setState(() {
                                Get_Bus_List(Search).then((value) {
                                  if(value[1]=='!'){
                                    Responded_Value=Unexpected_Error;
                                  }
                                  else{
                                    Responded_Value=jsonDecode(value);
                                  }


                                  if(Responded_Value==Unexpected_Error){
                                    Bus_List.add('해당하는 버스를 찾지 못했습니다..');
                                    Sub_Bus_List.add('없음...');
                                    Title_Text='그런거 없어요..ㅠ';
                                  }
                                  else{
                                    for(int i =0;i<(Responded_Value.length);i++)
                                    {
                                      Bus_List.add(Responded_Value[i][2].toString()+' :'+Responded_Value[i][1][0].toString());
                                      Sub_Bus_List.add(Responded_Value[i][1][2].toString()+' ~ '+Responded_Value[i][1][3]+'  \n 배차간격:['+Responded_Value[i][1][4]+'분]'+'  \n ['+Responded_Value[i][1][1].toString()+']');
                                    }
                                  }
                                  logger.i(Bus_List);
                                  setState(() {

                                  });
                                }
                                );
                              });;
                            }
                            else
                            {
                              Title_Text='입력해주세요';
                            }

                          });
                        },

                        child: Text('검색'),
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),

                            textStyle: const TextStyle(
                              fontSize: 40,
                            )

                        ),
                      ),
                    )
                ),
              ),
            ),

            Positioned(
              top: 150,
              child: Container(
                  width: 410,//원래 700..
                  height: 600,

                  child: ListView.separated(
                      itemCount: Bus_List.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          onTap: (){

                            Exact_Bus=Responded_Value[index][0].toString();


                            ListView_touched_List.clear();
                            Bus_touched_List.clear();
                            Bus_Station_List.clear();
                            Bus_Location_List.clear();
                            if(Sub_Bus_List[0]!='없음...')
                              {
                                Get_Bus_Station_List(Responded_Value[index][0].toString()).then((value){
                                  Responded_Station_Value=jsonDecode(value);
                                  for(int i=0;i<Responded_Station_Value.length;i++)
                                    {
                                      Bus_Station_List.add((Responded_Station_Value[i][1][1]=='N'?'↓\t':'↺\t')+Responded_Station_Value[i][1][0]+(Responded_Station_Value[i][1][1]=='N'?'':'\t[회차지점]'));
                                    }

                                }).then((value){
                                  Get_Bus_Location_List(Responded_Value[index][0].toString()).then((value){
                                    Responded_Location_value=jsonDecode(value);
                                    logger.i(Responded_Location_value);
                                    int num=0;
                                    for(int i=0;i<Responded_Station_Value.length;i++){
                                      if(Responded_Station_Value[i][0]==Responded_Location_value[num][0]){
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
                                    logger.e(Bus_Location_List);

                                  for(int i=0;i<Bus_Location_List.length;i++)
                                    {
                                      Bus_touched_List.add(false);
                                      ListView_touched_List.add(false);
                                    }
                                  }).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>const Station_List())));
                                }
                                );

                              }
                          },
                          title: Text(Bus_List[index],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          subtitle: Text(Sub_Bus_List[index],style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),/////////////////////////////////////////수정 필
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      }
                  )
              ),
            )






          ],
        ),
      ),
    );
  }
}
