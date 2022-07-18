import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:my_task/Componads/Com.dart';

import '../../resorces/Resorces.dart';
import '../on_boarding_screen/onBoarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: ColorManger.TaskMedColors,
      extendBodyBehindAppBar:true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarContrastEnforced: true,
          systemStatusBarContrastEnforced: true,
          statusBarColor:  Colors.transparent,
          systemNavigationBarColor:Colors.teal,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent
        ),
        backgroundColor: Colors.transparent,
        elevation:  0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
        Center(
          child:Lottie.asset(
              "lib/Image/Splash json.json",
            controller: _controller,
            reverse: true,
            repeat: true,
            onLoaded: (composition) {
              _controller
              ..duration = composition.duration
              ..forward().then((value) => Nevigator(context: context,page:const OnBoarding(),bool: false));
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
