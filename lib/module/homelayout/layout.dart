import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

            appBar: AppBar(
              systemOverlayStyle:const  SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.light,

              ),
              toolbarHeight: 0,

            ),
extendBodyBehindAppBar:true,
            key: cuibt.kayscafold,
             body:cuibt.body[cuibt.MyIndex],
              bottomNavigationBar: BottomNavyBar(
                containerHeight: 60,
             itemCornerRadius: 25.0,
            curve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 900),
            selectedIndex:cuibt.MyIndex,
            showElevation: false, // use this to remove appBar's elevation
            onItemSelected: (index){cuibt.ChangeIndex(index);},
            items: cuibt.ItemNav
              ),

          );
        }
    );

  }
  SizedBox Wallpaperstack(Size size,context) {
    return SizedBox(

      height:(MediaQuery.of(context).size.height-60),
      width: size.width,
      child: Image.asset("lib/Image/wallpaper.jpg", fit: BoxFit.fill),

    );
  }
}
