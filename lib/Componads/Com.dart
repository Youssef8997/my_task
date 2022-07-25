import 'package:flutter/material.dart';

Future Nevigator({page, context, bool = false}) {
  return Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => page), (Route route) => bool);
}

Container wallPaperContainer({required Child,required pathImage,required Size size}){
  return Container(
    height: size.height,
    width: size.width,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(pathImage),
        fit: BoxFit.fill,
      ),
    ),
    child: Child,
  );

}