import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/module/Login/Login.dart';
import '../../resorces/Resorces.dart';
import '../homelayout/layout.dart';
import '../on_boarding_screen/onBoarding.dart';
class SplashScreen extends StatefulWidget {
  late bool firstTime;
  late bool isLogin;
   SplashScreen({super.key, required this.firstTime, required this.isLogin});

  @override
  State<SplashScreen> createState() => _SplashScreenState(firstTime: firstTime,isLogin: isLogin);
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
late bool? firstTime;
late bool? isLogin;
  _SplashScreenState({required this.firstTime,required this.isLogin});
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    firstTime ??= false;
    isLogin ??= false;
    log("firstTime:$firstTime ,isLogin:$isLogin");
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManger.TaskMedColors,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarContrastEnforced: true,
            systemStatusBarContrastEnforced: true,
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.teal,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarDividerColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                "lib/Image/Splash json.json",
                controller: _controller,
                reverse: true,
                repeat: true,
                onLoaded: (composition) {
                  if (firstTime==false) {
                    log("Im in FIRST TIME");
                    _controller
                      ..duration = composition.duration
                      ..forward().then((value) => Nevigator(
                          context: context,
                          page: const OnBoarding(),
                          bool: false));
                  }
                  if(firstTime==true){
                   if (isLogin == false) {
                    _controller
                      ..duration = composition.duration
                      ..forward().then((value) => Nevigator(
                          context: context,
                          page:  Login(),
                          bool: false));
                  }
                   else{
                     _controller
                       ..duration = composition.duration
                       ..forward().then((value) => Nevigator(
                           context: context,
                           page:  homelayout(),
                           bool: false));
                   }
                  }

                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
