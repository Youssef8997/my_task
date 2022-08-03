import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';


class homelayout extends StatefulWidget {
  @override
  State<homelayout> createState() => _homelayoutState();
}

class _homelayoutState extends State<homelayout> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Notifications'),
              content:
                  const Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          AwesomeNotifications().actionStream.listen((notification) async {
            if (notification.channelKey == "tasks1") {
              if(Platform.isIOS){
                await  AwesomeNotifications().incrementGlobalBadgeCounter();

              }
              setState(() {
                layoutCuibt.get(context).MyIndex = 0;
              });
              layoutCuibt.get(context).delete(id: notification.id!);
            }
            if (notification.channelKey == "chatBoot") {
              setState(() {
                layoutCuibt.get(context).MyIndex = 3;
              });

            }
            if (notification.channelKey == "Budget") {
              setState(() {
                layoutCuibt.get(context).MyIndex = 1;
              });

            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var cuibt = layoutCuibt.get(context);
    return BlocConsumer<layoutCuibt, mytasks>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.light,
              ),
              toolbarHeight: 0,
            ),
            extendBodyBehindAppBar: true,
            key: cuibt.kayScaffold,
            body: cuibt.body[cuibt.MyIndex],
            bottomNavigationBar: BottomNavyBar(
                containerHeight: 60,
                itemCornerRadius: 25.0,
                curve: Curves.fastOutSlowIn,
                animationDuration: const Duration(milliseconds: 900),
                selectedIndex: cuibt.MyIndex,
                showElevation: false, // use this to remove appBar's elevation
                onItemSelected: (index) {
                  cuibt.ChangeIndex(index);
                },
                items: cuibt.ItemNav),
          );
        });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  SizedBox Wallpaperstack(Size size, context) {
    return SizedBox(
      height: (MediaQuery.of(context).size.height - 60),
      width: size.width,
      child: Image.asset("lib/Image/wallpaper.jpg", fit: BoxFit.fill),
    );
  }
}
