
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/module/Login/Login.dart';
import 'package:my_task/module/SpalshScreen/Spalsh.dart';
import 'package:my_task/module/homelayout/layout.dart';
import 'package:my_task/module/homelayout/layoutCuibt/cuibt.dart';
import 'lib/sherdeprefrence/sherdhelp.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sherdprefrence.init();
  await AndroidAlarmManager.initialize();
  var isSpalsh=sherdprefrence.getdate(key: "spalsh");
  var isLogin=sherdprefrence.getdate(key: "login");
  print(isLogin);
  Widget widget;
  if(isSpalsh==null) {
    widget = Spalsh();
  }

  else if (isLogin==null)
    widget=Login();
    else widget=homelayout();
  runApp(MyApp(widget));

}

class MyApp extends StatelessWidget {
  final widget;
  MyApp(this.widget);


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

              appBarTheme: AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    systemNavigationBarContrastEnforced: true,
                    systemStatusBarContrastEnforced: true,
                    statusBarColor: maincolor,
                    systemNavigationBarColor:Colors.teal,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.dark,
                    systemNavigationBarDividerColor: Colors.transparent

                  ),
                  backgroundColor: maincolor,
                  centerTitle: true,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic

                  ))),
          home: widget,
        ));
  }
}
