
import 'dart:typed_data';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/module/SpalshScreen/Spalsh.dart';
import 'package:my_task/module/homelayout/layoutCuibt/cuibt.dart';
import 'Componads/Com.dart';
import 'lib/sherdeprefrence/sherdhelp.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
 AwesomeNotifications().initialize(
   null,
   [
     NotificationChannel(
       channelKey: 'tasks1',
       channelName: 'Task',
       channelDescription: 'task',
       importance:NotificationImportance.Max,
       channelShowBadge: true,
       enableLights: true,
       enableVibration: true,
       playSound: true,
       ledColor: Colors.white,
       defaultRingtoneType: DefaultRingtoneType.Alarm,
       groupSort:GroupSort.Asc,
       vibrationPattern:Int64List(1000),
       groupAlertBehavior: GroupAlertBehavior.All,
soundSource: "resource://raw/alart_sound",
     ),

   ],
 );
  await sherdprefrence.init();
  bool?  IsfirstTime=sherdprefrence.getdate(key: "spalsh");
  bool? IsLogin=sherdprefrence.getdate(key: "login");

  runApp(MyApp(IsfirstTime,IsLogin));

}

class MyApp extends StatelessWidget {
  bool? firstTime;
  bool?isLogin;
  MyApp(this.firstTime,this.isLogin);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => layoutCuibt()..Crdatab()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    systemNavigationBarContrastEnforced: true,
                    systemStatusBarContrastEnforced: true,
                    statusBarColor:  Colors.transparent,

                    systemNavigationBarColor:Colors.teal,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.dark,
                    systemNavigationBarDividerColor: Colors.transparent

                  ),
                  backgroundColor:Colors.transparent,
                  elevation:  0,
                  centerTitle: true,
                  titleTextStyle:  TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic

                  ))),
          home:  SplashScreen(firstTime: firstTime??false,isLogin: isLogin??false),
        ));
  }
}
