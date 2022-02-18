import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Future NEV({ page, context, bool=false}){
  return Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> page),(Route route)=>bool);
}
Color maincolor=HexColor("#f4c3c3");
Color taskHighColors=HexColor("#eb7777");
Color TaskMedColors=HexColor("#468faf");
Color TaskLowColors=HexColor("#8eb5f0");
