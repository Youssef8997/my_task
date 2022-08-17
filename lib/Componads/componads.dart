import 'package:flutter/material.dart';

Future navigator({page, context, returnPage = false}) {
      return Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> page),(Route route)=>returnPage);
}

Container wallPaperContainer({required child,required pathImage,required Size size}){
  return Container(
    height: size.height,
    width: size.width,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(pathImage),
        fit: BoxFit.fill,
      ),
    ),
    child: child,
  );

}