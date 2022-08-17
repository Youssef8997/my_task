import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:shimmer/shimmer.dart';
import '../../Translition/locale_kays.g.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
 var myBanner;
@override
  void initState() {
  BannerAd(
    adUnitId: 'ca-app-pub-7041190612164401/7202609420',
    size: AdSize.fullBanner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdFailedToLoad:(Ad ad, LoadAdError error) {
        myBanner=null;
      },
      onAdLoaded: (Ad ad) {
        setState(() {
          myBanner = ad;

        });
      },

    ),
  ).load();
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
      listener: (context, state) {},
      builder: (context, state) {
        var cuibt = layoutCuibt.get(context);
        var size = MediaQuery.of(context).size;

        return Container(
          height: size.height,
          width: size.width,
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
                  if(myBanner!=null)
                    SizedBox(
                      width:size.width,
                      height: size.height*.06,
                      child: AdWidget(
                        ad: myBanner,
                      )),
                  const SizedBox(height: 35),
                  Shimmer.fromColors(
                    baseColor: Colors.black,
                    highlightColor: Colors.grey[400]!,
                    period: const Duration(milliseconds: 1000),
                    child: Text(LocaleKeys.Settings.tr(),
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center),
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
                            "العربيه",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          onTap: () =>
                              cuibt.changeLocale(context, const Locale("ar"))),
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
                              cuibt.changeLocale(context, const Locale("en"))),
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
                        leading: const Icon(Icons.add, size: 30, color: Colors.black),
                        trailing: Switch.adaptive(
                          autofocus: true,
                          value: cuibt.taskReminder,
                          onChanged: (value) =>
                              cuibt.cancelTaskReminder(value),
                          splashRadius: 30,
                          activeColor: Colors.lightBlueAccent[700],
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
                            size: 30, color: Colors.lightGreenAccent),
                        trailing: Switch.adaptive(
                          autofocus: true,
                          value: cuibt.moneyReminder,
                          onChanged: (value) =>
                              cuibt.cancelMoneyReminder(value),
                          splashRadius: 30,
                          activeColor: Colors.lightBlueAccent[700],
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
                        LocaleKeys.IncomeMoney.tr(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      leading: const Icon(Icons.attach_money, size: 25),
                      subtitle: Text(
                        LocaleKeys.IncomeMoneyDesc.tr(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ListTile(
                          title: Text(
                            LocaleKeys.resetBudget.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: const Icon(Icons.restart_alt_sharp,
                              size: 25, color: Colors.black),
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
                        const SizedBox(height: 10),
                        if (cuibt.changeIncome == false)
                          ListTile(
                            title: Text(
                              LocaleKeys.ChangeIncome.tr(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: const Icon(Icons.attach_money,
                                size: 30, color: Colors.lightGreenAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            style: ListTileStyle.drawer,
                            onTap: () {
                              setState(() {
                                cuibt.changeIncome = !cuibt.changeIncome;
                              });
                            },
                          ),
                        if (cuibt.changeIncome == true)
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadiusDirectional.circular(25.0)),
                              child: TextFormField(
                                  controller: cuibt.salaryController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: LocaleKeys.SalaryHint.tr(),
                                      prefixIcon: const Icon(
                                        Icons.attach_money,
                                        color: Colors.green,
                                      )),
                                  onFieldSubmitted: (salary) =>
                                      cuibt.setSalary(salary)),
                            ),
                          )
                      ],
                      onExpansionChanged: (value) {
                        if (value == false) {
                          setState(() {
                            cuibt.changeIncome = false;
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
                      LocaleKeys.descContact.tr(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      ListTile(
                        title: Text(LocaleKeys.Facebook.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                        leading: Image.asset("lib/Image/facebook.png",
                            fit: BoxFit.cover, height: 25, width: 25),
                        style: ListTileStyle.drawer,
                        onTap: () {
                          cuibt.faceBook();
                        },
                      ),
                      ListTile(
                        title: Text(LocaleKeys.instagram.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                        leading: Image.asset("lib/Image/Instagram.png",
                            fit: BoxFit.cover, height: 25, width: 25),
                        style: ListTileStyle.drawer,
                        onTap: () {
                          cuibt.instagram();
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
                      Text(LocaleKeys.DevelopedBy.tr(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(LocaleKeys.Version.tr(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  const SizedBox(height: 35),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
