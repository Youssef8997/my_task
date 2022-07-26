import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_task/Componads/my%20textformfild.dart';

import '../../Model/Model.dart';
import '../homelayout/layoutCuibt/cuibt.dart';
import '../homelayout/layoutCuibt/loginstates.dart';

class RobotChat extends StatefulWidget {
  const RobotChat({super.key});

  @override
  State<RobotChat> createState() => _RobotChatState();
}

class _RobotChatState extends State<RobotChat> {
  @override
  void initState() {
    setState(() {
      layoutCuibt.get(context).robotChat.add(layoutCuibt.get(context).robotResponded[0]);
    });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
      listener: (context, state) {},
      builder: (context, state) {
        var Size = MediaQuery.of(context).size;
        var cuibt = layoutCuibt.get(context);
        return Container(
          padding: EdgeInsets.only(top: 10),
          height: Size.height,
          width: Size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/Image/chatWallpaper.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Flexible(
                child: ListView.separated(
                    itemBuilder: (context,I){
                      if(cuibt.robotChat[I].user=="user")
                        {
                          return userMassage(cuibt.robotChat[I]);
                        }
                      else {
                        return rebootMassage(cuibt.robotChat[I]);

                      }
                    },
                    separatorBuilder:(context,_)=>const SizedBox(height: 10),
                    itemCount: cuibt.robotChat.length
                ),
              ),
              SizedBox(
                height: 50,
                width: Size.width,
                child: Mytextfield(hint: "type your massage",suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      cuibt.robotChat.add(RobotChatModel(
                          cuibt.chatField.text,
                          "user",
                          DateFormat('hh:mm').format(DateTime.now())
                      ));
                    });
                    cuibt.chatField.clear();
                  },
                  icon: const Icon(Icons.send,color: Colors.teal),
                ),Controlr: cuibt.chatField,keybordtype: TextInputType.text),
              ),
            ],
          ),
        );
      },
    );

  }
@override
  void dispose() {
  setState(() {
    layoutCuibt.get(context).robotChat=[];
  });
    super.dispose();
}
  Widget userMassage(RobotChatModel massage) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Container(
            decoration:  const BoxDecoration(
                color: Colors.teal,
                borderRadius:  BorderRadiusDirectional.all(Radius.circular(25.0))),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              children: [
                Text(
                  "${massage.massage}  ",
                  style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                ),
                Text(
                  "${massage.time}  ",
                  style: const TextStyle(color: Colors.grey, fontSize: 17,fontWeight: FontWeight.w700,),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      );

  Widget rebootMassage( RobotChatModel massage) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Container(
            decoration:const BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius:  BorderRadiusDirectional.all(Radius.circular(25.0))),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${massage.massage} ",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "${massage.time}  ",
                  style: const TextStyle(color: Colors.black87, fontSize: 17,fontWeight: FontWeight.w700,),
                  textAlign: TextAlign.right,
                ),

              ],
            ),
          ),
        ),
      );
}
