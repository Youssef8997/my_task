import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/module/homelayout/layoutCuibt/cuibt.dart';

import '../../Componads/mybutton.dart';
import '../homelayout/layoutCuibt/loginstates.dart';
class analytics extends StatefulWidget {
  @override
  State<analytics> createState() => _analyticsState();
}

class _analyticsState extends State<analytics> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt,mytasks>
      (
        listener: (context,state){},
        builder: (context,state){
          var size=MediaQuery.of(context).size;
          return Stack0salary(size,context);
        }
    );
  }

  Widget Stack0salary(Size size, context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Wallpaperstack(size),
        Textupmoney("${layoutCuibt.get(context).sallaryAfter} LE"),
        Positioned(
          top: 100,
          bottom: 0,
          child: SizedBox(
              height: size.height * .75,
              width: size.width,
              child: ConditionalBuilder(
                condition: layoutCuibt.get(context).Budget.isNotEmpty,
                builder: (context) => ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    itemBuilder: (context, index) => Dismissible(
                      key: Key(layoutCuibt.get(context).Budget[index]["title"].toString()),
                      onDismissed: (direction) {
                        layoutCuibt.get(context).deletebudget(id: layoutCuibt.get(context).Budget[index]["id"],index: index);
                        final snackBar = SnackBar(
                          content: Text(
                            "you deleted task number ${layoutCuibt.get(context).Budget[index]["id"]}",
                          ),
                          backgroundColor: Colors.pink,
                          duration: const Duration(milliseconds: 800),
                          elevation: 10.0,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: BudgetCont(
                          size, layoutCuibt.get(context).Budget[index]),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 1,
                    ),
                    itemCount: layoutCuibt.get(context).Budget.length),
                fallback: (context) => Padding(
                  padding: const EdgeInsets.only(left: 50, top: 200),
                  child: Text("you dont spent money yet ,good boy🥰",
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic)),
                ),
              )),
        )
      ],
    );
  }

  Positioned Textupmoney(value) {
    return Positioned(
        top: 50,
        right: 20,
        child: Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30.0,
              fontStyle: FontStyle.italic,
              color: Colors.white),
        ));
  }

  SizedBox Wallpaperstack(Size size) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Image.asset("lib/Image/businessWallpepar.jpg", fit: BoxFit.fill),
    );
  }
  Padding BudgetCont(Size size, budget) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          //date of budget
          RotatedBox(
              quarterTurns: 1,
              child: Text(
                "${budget["data"]}",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              )),
          const SizedBox(
            width: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 100,
            width: size.width - 45,
            decoration: BoxDecoration(
                color: TaskLowColors,
                borderRadius: BorderRadiusDirectional.circular(50.0),
                boxShadow: [
                  BoxShadow(
                    color: TaskMedColors,
                    spreadRadius: .2,
                    offset: const Offset(3, 4),
                    blurRadius: 2,
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CatogryShow(budget),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: 170,
                        child: Text("${budget["title"]}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 21.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        height: 20,
                        width: 80,
                        child: Text("${budget["MONEY"]} LE",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 21.0, fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    SizedBox(height: 10),
                    Row(children: [
                      SizedBox(
                        width: 170,
                        child: Text(
                          "${budget["desc"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Text("${budget["MONEYAfter"]} LE",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700])),
                    ]),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  CircleAvatar CatogryShow(model) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.pinkAccent,
      foregroundColor: Colors.white,
      child: CircleAvatar(
        foregroundColor: Colors.white,
        backgroundImage: AssetImage(
          model["catogry"],
        ),
        radius: 35,
        backgroundColor: Colors.white,
      ),
    );
  }

}


