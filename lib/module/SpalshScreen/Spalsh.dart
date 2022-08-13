import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:my_task/Componads/Com.dart';
import '../../resorces/Resorces.dart';
import '../homelayout/layout.dart';
import '../on_boarding_screen/onBoarding.dart';
// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  late bool firstTime;
   SplashScreen({super.key, required this.firstTime,});

  @override
  State<SplashScreen> createState() => _SplashScreenState(firstTime: firstTime);
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
late bool? firstTime;
  _SplashScreenState({required this.firstTime});
  var rewardedAd;
  @override
  void initState() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-7041190612164401/4845136872',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
          },

        ));
    _controller = AnimationController(vsync: this);
    firstTime ??= true;

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
                  if (firstTime==true) {
                    log("Im in FIRST TIME");
                    _controller
                      ..duration = composition.duration
                      ..forward().then((value) => Nevigator(
                          context: context,
                          page: const OnBoarding(),
                          bool: false));
                  }
                   else{
                     _controller
                       ..duration = composition.duration
                       ..forward().then((value) {
                         Nevigator(
                             context: context,
                             page: homelayout(),
                             bool: false);
                         if(rewardedAd!=null) {
                           rewardedAd.show(
                               onUserEarnedReward: (AdWithoutView ad,
                                   RewardItem rewardItem) {});
                         }
                       });
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
