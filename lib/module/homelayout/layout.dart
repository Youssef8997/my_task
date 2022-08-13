import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../Translition/locale_kays.g.dart';
import '../AddTasks/AddTasks.dart';

class homelayout extends StatefulWidget {
  @override
  State<homelayout> createState() => _homelayoutState();
}

class _homelayoutState extends State<homelayout> {
  var quickActions = const QuickActions();
  final bannar=BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/3419835294'
          : 'ca-app-pub-3940256099942544/2934735716',
      listener: BannerAdListener(),
      request: AdRequest());

  @override
  void initState() {
    super.initState();

    //  QuickAction button which appears when you long press the app icon
    quickActions.setShortcutItems(const [
      ShortcutItem(
          type: "New Task",
          localizedTitle: "New Task",
          icon: "baseline_add_black_24dp"),
      ShortcutItem(
          type: "money",
          localizedTitle: "Spent Money",
          icon: "baseline_attach_money_black_24dp",

      ),
    ]);
    quickActions.initialize((type) {
      if (type == "New Task") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Tasks()));
      }
      if (type == "money") {
        setState(() {
          layoutCuibt.get(context).MyIndex = 1;
        });
      }

    });
    //to ask for permission to access the notification
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
              setState(() {
                layoutCuibt.get(context).MyIndex = 0;
              });

              print(notification.dismissedDate);
/*
              layoutCuibt.get(context).delete(id: notification.id!,rpeted: "Never");
*/
            }
            if (notification.channelKey == "chatBoot") {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const Tasks()));
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
    return BlocConsumer<layoutCuibt, mytasks>(
        listener: (context, state) {},
        builder: (context, state) {
          var cuibt = layoutCuibt.get(context);
          List<BottomNavyBarItem> navigationItem = [
            BottomNavyBarItem(
              icon: Image.asset(
                "lib/Image/icon.jpg",
                height: 30,
                width: 25,
              ),
              title: Text(LocaleKeys.Tasks.tr()),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
                icon: const Icon(
                  Icons.account_balance_wallet,
                ),
                title: Text(LocaleKeys.Balance.tr()),
                activeColor: Colors.cyan),
            BottomNavyBarItem(
                icon: const Icon(
                  Icons.insert_chart,
                ),
                title: Text(LocaleKeys.analytics.tr()),
                activeColor: Colors.pink),
            BottomNavyBarItem(
                icon: const Icon(
                  Icons.settings,
                ),
                title: Text(LocaleKeys.Settings.tr()),
                activeColor: Colors.blue),
          ];
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.light,
              ),
              toolbarHeight:0,
            ),
            extendBodyBehindAppBar: true,
            key: cuibt.kayScaffold,
            body: cuibt.body[cuibt.MyIndex],
            bottomNavigationBar: BottomNavyBar(
                containerHeight: 60,
                itemCornerRadius: 25.0,
                curve: Curves.fastOutSlowIn,
                animationDuration: const Duration(milliseconds: 600),
                selectedIndex: cuibt.MyIndex,
                showElevation: false, // use this to remove appBar's elevation
                onItemSelected: (index) {

                  cuibt.ChangeIndex(index);
                },
                items: navigationItem),
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
