import 'package:flutter/material.dart';
Widget myButton({
  required text,
  required GestureTapCallback function,

}) {
  return Container(
    height: 50,
    width:150,
    decoration: BoxDecoration(
      color:const Color(0xff6096BA),
       borderRadius: BorderRadius.circular(25.0),

    ),
    child: MaterialButton(
      onPressed: function,
      child: text,

    ),
  );
}
