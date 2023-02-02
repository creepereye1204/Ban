

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ban/main.dart';
import '../Home/home.dart';
import 'dart:async';


class BAN extends StatelessWidget {
  const BAN({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Arrival Notification (BAN)',
      home: Start_Screen(),
    );
  }
}


class Start_Screen extends StatefulWidget {
  const Start_Screen({Key? key}) : super(key: key);

  @override
  State<Start_Screen> createState() => _Start_ScreenState();
}

class _Start_ScreenState extends State<Start_Screen> {
  @override
  Widget build(BuildContext context) {
    final Start_Screen_Path=Image_Path['Start_Screen'];
    final Screen_Height=MediaQuery.of(context).size.height;
    final Screen_Widht=MediaQuery.of(context).size.width;


    return WillPopScope
      (

        onWillPop: () async =>false,

            child: SvgPicture.asset
              (
              Start_Screen_Path!,
              height: Screen_Height,
              width: Screen_Widht,
              fit: BoxFit.cover,
              ),

      );

  }
  @override
  void initState() {
    Timer(Duration(milliseconds: 1500),(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
    });
  }
}
