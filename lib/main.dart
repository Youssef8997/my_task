import 'dart:typed_data';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/module/SpalshScreen/Spalsh.dart';
import 'Translition/codegen_loader.g.dart';
import 'lib/sherdeprefrence/sherdhelp.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(color: Colors.transparent,);
  };
  await EasyLocalization.ensureInitialized();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'tasks1',
        channelName: 'Task',
        channelDescription: 'task',
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        ledColor: Colors.white,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
        groupSort: GroupSort.Asc,
        vibrationPattern: Int64List(1000),
        groupAlertBehavior: GroupAlertBehavior.All,
        soundSource: "resource://raw/alarm",
        criticalAlerts:true

      ),
      NotificationChannel(
        channelKey: 'tasksNever',
        channelName: 'Task',
        channelDescription: 'task',
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        ledColor: Colors.white,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
        groupSort: GroupSort.Asc,
        vibrationPattern: Int64List(1000),
        groupAlertBehavior: GroupAlertBehavior.All,
        soundSource: "resource://raw/alarm",
        criticalAlerts:true

      ),
      NotificationChannel(
        channelKey: 'chatBoot',
        channelName: 'chatBoot1',
        channelDescription: 'create task by chat boot',
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        ledColor: Colors.white,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        vibrationPattern: Int64List(800),
        criticalAlerts: true,
        soundSource: "resource://raw/remindernotifications",

      ),
      NotificationChannel(
        channelKey: 'Budget',
        channelName: 'Money',
        channelDescription: 'create financial transaction',
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        ledColor: Colors.white,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        vibrationPattern: Int64List(1000),
        criticalAlerts: true,
        soundSource: "resource://raw/remindernotifications",

      ),
    ],
  );
  await sherdprefrence.init();
  bool? isFirstTime = sherdprefrence.getdate(key: "spalsh");
  runApp(
    EasyLocalization(
        supportedLocales:const [
          Locale('en'),
          Locale('ar')
        ],
        path: 'Asset/Translition', // <-- change the path of the translation files
        fallbackLocale:const Locale('en'),
        assetLoader: const CodegenLoader(),
        child:MyApp(isFirstTime)
    ),
  );

}
// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool? firstTime;
  MyApp(this.firstTime, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) => layoutCuibt()..createDataBase()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
              appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                      systemNavigationBarContrastEnforced: true,
                      systemStatusBarContrastEnforced: true,
                      statusBarColor: Colors.transparent,
                      systemNavigationBarColor: Colors.teal,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.dark,
                      systemNavigationBarDividerColor: Colors.transparent),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic))),
          home: SplashScreen(
              firstTime: firstTime ?? true,),
        ));
  }
}
