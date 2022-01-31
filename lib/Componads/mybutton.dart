import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
Widget mybutton({
  required Widget,
  required GestureTapCallback function,

}) {
  return Container(
    height: 50,
    width:150,
    decoration: BoxDecoration(
      color: HexColor("#6096BA"),
       borderRadius: BorderRadius.circular(25.0),

    ),
    child: MaterialButton(
      onPressed: function,
      child: Widget,

    ),
  );
}
