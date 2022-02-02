import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MoneyOraganize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
var size=MediaQuery.of(context).size;
double precent=.9;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        precentge_circular(size, precent),
        Catogry_Avatar()
      ],
    );
  }

  Column Catogry_Avatar() {
    return Column(
        children: [
          CircleAvatar(
            radius:51,
            backgroundColor: Colors.pinkAccent,
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://static.mbshosting.co.uk/eis-bw/media/New%20brand%20icons/PNGs/House%20illustration%201.png",),
              radius: 50.0,
              backgroundColor: Colors.white,


            ),
          ),
          Text("Home Servec",style: TextStyle(fontWeight: FontWeight.bold),),
        ],
      );
  }

  SizedBox precentge_circular(Size size, double precent) {
    return SizedBox(
        height:size.height*.3,
        width: double.infinity,
        child:  CircularPercentIndicator(
          radius: 200,
          lineWidth: 10,
          percent: precent,
          center:  Text("${(precent*100).ceil()}%"),
          progressColor: HexColor("#ED9797"),
          animation: true,
          addAutomaticKeepAlive: true,
          animationDuration: 1200,
          animateFromLastPercent: false,
          curve: Curves.easeInCubic,
           arcType: ArcType.FULL,
        ),
      );
  }
}
