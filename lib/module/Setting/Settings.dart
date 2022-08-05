import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:shimmer/shimmer.dart';
import '../../Translition/locale_kays.g.dart';
import '../bootChat/bootChat.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cuibt = layoutCuibt.get(context);
        var _size = MediaQuery.of(context).size;
        return Container(
          height: _size.height,
          width: _size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/Image/SettingWallpaper.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: ExpansionTileTheme(
              data: const ExpansionTileThemeData(
                iconColor: Colors.white,
                textColor: Colors.white,
                collapsedTextColor: Colors.black,
                collapsedIconColor: Colors.black,
              ),
              child: ListView(
                children: [
                  const SizedBox(height: 35),
                  Shimmer.fromColors(
                    child:  Text(LocaleKeys.Settings.tr(),
                        style:const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center),
                    baseColor: Colors.black,
                    highlightColor: Colors.grey[400]!,
                    period: const Duration(milliseconds: 1000),
                  ),
                  const SizedBox(height: 35),
                  ExpansionTile(
                    title:  Text(
                      LocaleKeys.DarkMood.tr(),
                      style:const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: const Icon(Icons.nightlight_round, size: 25),
                    trailing: Switch.adaptive(
                      autofocus: true,
                      value: _cuibt.isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _cuibt.isDarkMode = value;
                          log("${_cuibt.isDarkMode}");
                        });
                      },
                      splashRadius: 30,
                      activeColor: Colors.teal,
                      activeTrackColor: Colors.grey,
                    ),
                    textColor: Colors.black,
                    iconColor: Colors.black,
                  ),
                  const SizedBox(height: 35),
                   ExpansionTile(
                    title: Text(
                      LocaleKeys.language.tr(),
                      style:
                        const   TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.g_translate, size: 25),
                    children:  [
                      ListTile(
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        style: ListTileStyle.drawer,
                        leading:
                        const Icon(Icons.language, size: 25, color: Colors.black),
                        title: const Text(
                          "Arabic",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        onTap: ()=>_cuibt.changeLocale(context,const  Locale("ar"))
                      ),
                      ListTile(
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        style: ListTileStyle.drawer,
                        leading:
                           const Icon(Icons.language, size: 25, color: Colors.black),
                        title:const  Text(
                          "English",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        onTap: ()=>_cuibt.changeLocale(context,const  Locale("en"))
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  ExpansionTile(
                    subtitle:  Text(
                      LocaleKeys.ReminderDesc.tr(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title:  Text(
                      LocaleKeys.Reminder.tr(),
                      style:
                       const    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.alarm, size: 25),
                    children: [
                      ExpansionTile(
                        title:  Text(
                          LocaleKeys.AddTaskReminder.tr(),
                          style:const  TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading:
                            Icon(Icons.add, size: 30, color: Colors.blue[700]),
                        trailing: Switch.adaptive(
                          autofocus: true,
                          value: _cuibt.taskReminder,
                          onChanged: (value) =>
                              _cuibt.cancelTaskReminder(value),
                          splashRadius: 30,
                          activeColor: Colors.teal,
                          activeTrackColor: Colors.grey,
                        ),
                        textColor: Colors.black,
                        iconColor: Colors.black,
                      ),
                      ExpansionTile(
                        title:  Text(
                          LocaleKeys.AddMoneyReminder.tr(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: const Icon(Icons.attach_money,
                            size: 30, color: Colors.teal),
                        trailing: Switch.adaptive(
                          autofocus: true,
                          value: _cuibt.moneyReminder,
                          onChanged: (value) =>
                              _cuibt.cancelMoneyReminder(value),
                          splashRadius: 30,
                          activeColor: Colors.teal,
                          activeTrackColor: Colors.grey,
                        ),
                        textColor: Colors.black,
                        iconColor: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                   ExpansionTile(
                    title: Text(
                      LocaleKeys.ContactUs.tr(),
                      style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading:const Icon(Icons.contacts_rounded, size: 25),
                  ),
                  const SizedBox(height: 35),
                   ExpansionTile(
                    title: Text(
                      LocaleKeys.AboutUs.tr(),
                      style:
                      const  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.person, size: 25),
                  ),
                  const SizedBox(height: 35),
                   ListTile(
                    title:  Text( LocaleKeys.ChatWithUs.tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    leading: const Icon(Icons.chat, size: 25, color: Colors.black),
                    style: ListTileStyle.drawer,
                    onTap: (){
                      Nevigator(bool: true,page:const  RobotChat(),context: context);
                    },


                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
