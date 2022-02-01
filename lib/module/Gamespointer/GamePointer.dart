import 'package:flutter/material.dart';

class GamePointer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Pointscore(),
        Rewgame( icon:  Icon(Icons.style,size: 40,),text:  "Jokar"),
        SizedBox(height: 30,),
        Rewgame(icon:  Icon(Icons.sports_basketball,size: 40,),text: "football"),
        SizedBox(height: 30,),
        Rewgame( icon: Icon(Icons.sports_volleyball,size: 40,),text:  "volleyball"),
        SizedBox(height: 30,),
      ],
    );
  }

  Row Rewgame({required Widget icon,required String text}) {
    return Row(children:  [
      icon,
      const SizedBox(width: 10,),
      Text(text,style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),),
    ],);
  }
}

class Pointscore extends StatelessWidget {
  const Pointscore({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.maxFinite,
      decoration:const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.contain,
              image:  NetworkImage(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQufWDW-0IRpTHh_Z743acLbNuDLNH4TfL8qPsbf96bUa8IdrlkcouDa-E4-VDUpbIpf38&usqp=CAU",
              ))),
    );
  }
}
