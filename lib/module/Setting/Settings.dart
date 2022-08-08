import 'dart:developer';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Translition/locale_kays.g.dart';
import '../bootChat/bootChat.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
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
                    child: Text(LocaleKeys.Settings.tr(),
                        style: const TextStyle(
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
                    title: Text(
                      LocaleKeys.DarkMood.tr(),
                      style: const TextStyle(
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
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.g_translate, size: 25),
                    children: [
                      ListTile(
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          style: ListTileStyle.drawer,
                          leading: const Icon(Icons.language,
                              size: 25, color: Colors.black),
                          title: const Text(
                            "Arabic",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          onTap: () =>
                              _cuibt.changeLocale(context, const Locale("ar"))),
                      ListTile(
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          style: ListTileStyle.drawer,
                          leading: const Icon(Icons.language,
                              size: 25, color: Colors.black),
                          title: const Text(
                            "English",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          onTap: () =>
                              _cuibt.changeLocale(context, const Locale("en"))),
                    ],
                  ),
                  const SizedBox(height: 35),
                  ExpansionTile(
                    subtitle: Text(
                      LocaleKeys.ReminderDesc.tr(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Text(
                      LocaleKeys.Reminder.tr(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.alarm, size: 25),
                    children: [
                      ExpansionTile(
                        title: Text(
                          LocaleKeys.AddTaskReminder.tr(),
                          style: const TextStyle(
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
                        title: Text(
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
                        "income money",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      leading: const Icon(Icons.attach_money, size: 25),
                      subtitle: Text(
                        "Select the date to get the money per month",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ListTile(
                          title: Text(
                            "reset Budget",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Icon(Icons.restart_alt_sharp,
                              size: 25, color: Colors.blue[700]),
                          style: ListTileStyle.drawer,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('are you get your salary'),
                                content: const Text(
                                    'Our app would like to reset your budget'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      sherdprefrence.setdate(
                                          key: "ResetBudget", value: false);
                                    },
                                    child: const Text(
                                      'Don\'t Allow',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      layoutCuibt.get(context).changPercent(
                                          sherdprefrence.getdate(
                                              key: "salary"));
                                    },
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
                          },
                        ),
                        SizedBox(height: 10),
                        if (_cuibt.changeIncome == false)
                          ListTile(
                            title: Text(
                              "Change your monthly income",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: const Icon(Icons.attach_money,
                                size: 25, color: Colors.teal),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            style: ListTileStyle.drawer,
                            onTap: () {
                              setState(() {
                                _cuibt.changeIncome = !_cuibt.changeIncome;
                              });
                            },
                          ),
                        if (_cuibt.changeIncome == true)
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadiusDirectional.circular(25.0)),
                              child: TextFormField(
                                  controller: _cuibt.salaryController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: LocaleKeys.SalaryHint.tr(),
                                      prefixIcon: const Icon(
                                        Icons.attach_money,
                                        color: Colors.green,
                                      )),
                                  onFieldSubmitted: (salary) =>
                                      _cuibt.setSalary(salary)),
                            ),
                          )
                      ],
                      onExpansionChanged: (value) {
                        print(value);
                        if (value == false) {
                          setState(() {
                            _cuibt.changeIncome = false;
                          });
                        }
                      }),
                  const SizedBox(height: 35),
                  ExpansionTile(
                    title: Text(
                      LocaleKeys.ContactUs.tr(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.contacts_rounded, size: 25),
                    subtitle: Text(
                      "Contact us for any help or suggestions",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      ListTile(
                        title: Text("facebook",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                        leading: Image.asset("lib/Image/facebook.png",
                            fit: BoxFit.cover, height: 25, width: 25),
                        style: ListTileStyle.drawer,
                        onTap: () {
                          _cuibt.faceBook();
                        },
                      ),
                      ListTile(
                        title: Text("instagram",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                        leading: Image.asset("lib/Image/Instagram.png",
                            fit: BoxFit.cover, height: 25, width: 25),
                        style: ListTileStyle.drawer,
                        onTap: () {
                          _cuibt.instagram();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  ExpansionTile(
                    title: Text(
                      LocaleKeys.AboutUs.tr(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.person, size: 25),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "i'm youssef ahmed ✌️ \ni'm have a big dream to make a app that help people ❤️\nand manage their money and there time and there is a lot of thing that i want to do to make this app better and better 💪 ",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 35),
                  ListTile(
                    title: Text(LocaleKeys.ChatWithUs.tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    leading:
                        const Icon(Icons.chat, size: 25, color: Colors.black),
                    style: ListTileStyle.drawer,
                    onTap: () {
                      Nevigator(
                          bool: true,
                          page: const RobotChat(),
                          context: context);
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
