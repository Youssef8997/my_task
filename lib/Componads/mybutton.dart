import 'package:flutter/material.dart';
Widget mybutton({
  required Widget,
  required GestureTapCallback function,

}) {
  return Container(
    height: 50,
    width:150,
    decoration: BoxDecoration(
      color:Color(0xff6096BA),
       borderRadius: BorderRadius.circular(25.0),

    ),
    child: MaterialButton(
      onPressed: function,
      child: Widget,

    ),
  );
}
