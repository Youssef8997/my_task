import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/module/homelayout/layout.dart';
import 'package:my_task/module/homelayout/layoutCuibt/cuibt.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sherdprefrence.init();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
                    systemNavigationBarColor:maincolor,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.dark,

                  ),
                  backgroundColor: maincolor,
                  centerTitle: true,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic

                  ))),
          home: homelayout(),
        ));
  }
}
