import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/module/homelayout/layoutCuibt/cuibt.dart';
import 'package:my_task/module/homelayout/layoutCuibt/loginstates.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
class homelayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cuibt=layoutCuibt.get(context);
    return BlocConsumer<layoutCuibt,mytasks>
      (
        listener: (context,state){},
        builder: (context,state){
          return Scaffold(
            key: cuibt.kayscafold,
            appBar:cuibt.MyIndex!=1?cuibt.appbar[cuibt.MyIndex]:AppBar(
              toolbarHeight: 0.0,
            ),
             body:cuibt.body[cuibt.MyIndex],
              bottomNavigationBar: BottomNavyBar(
                containerHeight: 60,
            animationDuration: Duration(milliseconds: 300),
            selectedIndex:cuibt.MyIndex,
            showElevation: true, // use this to remove appBar's elevation
            onItemSelected: (index){cuibt.ChangeIndex(index);},
            items: cuibt.ItemNav
              ),

          );
        }
    );
  }
}
