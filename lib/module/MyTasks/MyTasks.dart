// ignore_for_file: file_names

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_task/Componads/componads.dart';
import 'package:my_task/Componads/mybutton.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../../Translition/locale_kays.g.dart';
import '../../resorces/Resorces.dart';
import '../AddTasks/AddTasks.dart';
  bool notRepeated = true;
  bool isDaily = false;
  bool isWeekly = false;
  bool isMonthly = false;
class HomeTasks extends StatefulWidget {
  const HomeTasks({super.key});

  @override
  State<HomeTasks> createState() => _HomeTasksState();
}

class _HomeTasksState extends State<HomeTasks> {
  var _date = DateFormat.yMMMd().format(DateTime.now());
  var myBanner;

  @override
  void initState() {
    BannerAd(
      adUnitId: 'ca-app-pub-7041190612164401/1452686778',
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (Ad ad) {
          setState(() {
            myBanner = ad;
          });
        },
      ),
    ).load();
    setState(() {
      notRepeated = true;
      isDaily = false;
      isWeekly = false;
      isMonthly = false;
      //to get data from data base when the user open to the page
      if(layoutCuibt.get(context).datab.isOpen){

        layoutCuibt.get(context).insertTaskIntoVar("Never",datab: layoutCuibt.get(context).datab);

      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
      listener: (context, state) {},
      builder: (context, state) {
        var size = MediaQuery.of(context).size;
        var tasks = layoutCuibt.get(context).tasks;
        var cuibt = layoutCuibt.get(context);
        return wallPaperContainer(
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (myBanner != null)
                    SizedBox(
                      height: size.height * 0.06,
                      width: size.width,
                      child: AdWidget(ad: myBanner),
                    ),
                  //calender date to show tasks for that day
                  if (notRepeated)
                    dateCalendar(context, size),
                  // row of buttons to add tasks and hi massage,
                  textUpContainer(context, size, cuibt),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  if (tasks.isEmpty)
                    Center(
                      heightFactor: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          LocaleKeys.dontHaveTask.tr(),
                          style: const TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w900),
                        ),
                      ),
                    )
                  else
                    taskCard(tasks, size),
                ],
              ),
            ),
            pathImage: "lib/Image/wallpaper.jpg",
            size: size);
      },
    );
  }

  Expanded taskCard(List<Map<dynamic, dynamic>> tasks, Size size) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.all(size.height * 0.02),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return cardModel(tasks[index], context, index, size);
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 1,
              ),
          itemCount: tasks.length),
    );
  }

  Padding cardModel(tasks, context, index, Size size) {
    //to get the color of the task depend on the priority
    var color;
    if (tasks["priority"] == "low") color = ColorManger.TaskLowColors;
    if (tasks["priority"] == "medium") color = ColorManger.TaskMedColors;
    if (tasks["priority"] == "high") color = ColorManger.taskHighColors;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        //to get the task details and to edit the task on dialog
        onTap: () => settingDialog(context, tasks, color, index),
        child: Dismissible(
            key: Key(tasks["id"].toString()),
            onDismissed: (direction) {
              //to delete the task from the database
              layoutCuibt.get(context).delete(id: tasks["id"],rpeted: tasks["repeat"]);
              final snackBar = SnackBar(
                content: Text(
                  "you deleted task number ${tasks["id"]}",
                ),
                backgroundColor: Colors.pink,
                duration: const Duration(milliseconds: 800),
                elevation: 10.0,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Container(
              padding:
                  const EdgeInsetsDirectional.only(start: 15, top: 5, end: 10),
              height: 95,
              width: double.infinity - 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0), color: color),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * .5,
                        child: Text(
                          "${tasks["title"]}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time_outlined),
                      Text(
                        "${tasks["time"]}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      "${tasks["repeat"]}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * .5,
                        child: Text(
                          "${tasks["desc"]}",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      if(tasks["repeat"] == "Weekly")
                        SizedBox(
                          width: 70,
                          child: Text(
                            layoutCuibt.get(context).handleWeekDays(tasks["WeekDay"]),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      if(tasks["repeat"] != "Weekly")
                      const Icon(Icons.event),
                      if(tasks["repeat"] != "Weekly")
                      SizedBox(
                        width: 70,
                        child: Text(
                          "${tasks["data"]}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Container dialogContainer(color, tasks, context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 15, top: 5, end: 10),
      height: 280,
      width: 300,
      clipBehavior: Clip.antiAlias,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(25), color: color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width / 2,
            height: 60,
            child: Text(
              "${tasks["title"]}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: size.width / 2,
            height: 52,
            child: Text(
              "${tasks["desc"]}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[900],
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.event, size: 20),
              SizedBox(
                width: 120,
                child: Text(
                  "${tasks["data"]}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(Icons.access_time_outlined),
              Text(
                "${tasks["time"]}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myButton(
                  text: const Icon(Icons.edit),
                  function: () {
                    setState(() {
                      title.text = tasks["title"];
                      desc.text = tasks["desc"];
                      time.text = tasks["time"];
                      date.text = tasks["data"];
                      layoutCuibt.get(context).repeated = tasks["repeat"];
                      layoutCuibt.get(context).Weekday =int.parse(tasks["WeekDay"]) ;
                      layoutCuibt.get(context).currentStep = 2;
                    });
                    navigator(
                        context: context,
                        returnPage: true,
                        page: Tasks(id: tasks["id"]));
                  }),
            ],
          )
        ],
      ),
    );
  }

  Row textUpContainer(context, Size size, layoutCuibt cuibt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: TextButton(
            onPressed: () {
              showBottomSheet(context);
            },
            child: Row(
              children: [
                const Icon(
                  Icons.filter_alt_sharp,
                  size: 30,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${LocaleKeys.Filters.tr()},...",
                  style: GoogleFonts.ptSerif(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 20),
          child: myButton(
              text: Text("${LocaleKeys.AddTask.tr()}....",
                  style: const TextStyle(color: Colors.white)),
              function: () => cuibt.onPressedAdd(context)),
        )
      ],
    );
  }

  SizedBox dateCalendar(BuildContext context, Size size) {
    return SizedBox(
      height: 90,
      width: size.width,
      child: DatePicker(DateTime.now(),
          initialSelectedDate: DateTime.now(),
          selectionColor: Colors.black,
          selectedTextColor: Colors.white,
          locale: context.locale.languageCode, onDateChange: (value) {
        setState(() {
          _date = DateFormat.yMMMd("en").format(value);
          layoutCuibt.get(context).onDate = _date;
          layoutCuibt
              .get(context)
              .insertTaskIntoVar("Never",datab: layoutCuibt.get(context).datab);
        });
      }),
    );
  }

  Future showBottomSheet(
    context,
  ) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isScrollControlled: false,
      context: context,
      builder: (context) {
        return Material(
          type: MaterialType.button,
          color: Colors.blueGrey[500],
          animationDuration: const Duration(milliseconds: 600),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: const BorderRadiusDirectional.only(
              topEnd: Radius.circular(
                40.0,
              ),
              topStart: Radius.circular(
                40.0,
              )),
          child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                      topEnd: Radius.circular(
                        25.0,
                      ),
                      topStart: Radius.circular(
                        25.0,
                      ))),
              child: ListTileTheme(
                style: ListTileStyle.drawer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                iconColor: Colors.black,
                textColor: Colors.black,
                selectedTileColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.Filters.tr(),
                        style: GoogleFonts.ptSerif(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                        title: Text(LocaleKeys.Never.tr(),
                            style: GoogleFonts.ptSerif(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w900)),
                        leading: const Icon(
                          Icons.today,
                          size: 30,
                          color: Colors.black,
                        ),
                        selected: notRepeated,
                        onTap: () {
                          setState(() {
                            notRepeated = true;
                            isDaily = false;
                            isWeekly = false;
                            isMonthly = false;
                          });
                          layoutCuibt
                              .get(context)
                              .insertTaskIntoVar("Never",datab: layoutCuibt.get(context).datab);
                          Navigator.pop(context);
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                        title: Text(LocaleKeys.Daily.tr(),
                            style: GoogleFonts.ptSerif(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w900)),
                        leading: const Icon(
                          Icons.today,
                          size: 30,
                          color: Colors.black,
                        ),
                        selected: isDaily,
                        onTap: () {
                          setState(() {
                            isDaily = true;
                            isWeekly = false;
                            isMonthly = false;
                            notRepeated = false;

                          });
                          layoutCuibt
                              .get(context)
                              .insertTaskIntoVar("daily",datab: layoutCuibt.get(context).datab);
                          Navigator.pop(context);
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text(LocaleKeys.Weekly.tr(),
                          style: GoogleFonts.ptSerif(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w900)),
                      leading: const Icon(
                        Icons.calendar_view_week_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                      onTap: () {
                        setState(() {
                          isDaily = false;
                          isWeekly = true;
                          isMonthly = false;
                          notRepeated = false;

                        });
                        layoutCuibt
                            .get(context)
                            .insertTaskIntoVar("Weekly",datab: layoutCuibt.get(context).datab);
                        Navigator.pop(context);
                      },
                      selected: isWeekly,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text(LocaleKeys.Monthly.tr(),
                          style: GoogleFonts.ptSerif(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w900)),
                      leading: const Icon(
                        Icons.calendar_month_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                      onTap: () {
                        setState(() {
                          isDaily = false;
                          isWeekly = false;
                          isMonthly = true;
                          notRepeated = false;

                        });
                        layoutCuibt
                            .get(context)
                            .insertTaskIntoVar("Monthly",datab: layoutCuibt.get(context).datab);
                        Navigator.pop(context);
                      },
                      selected: isMonthly,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  settingDialog(context, tasks, color, index) {
    return showDialog(
        context: context,
        builder: (context) {
          return BlurryContainer(
            height: double.maxFinite,
            width: double.maxFinite,
            blur: 6,
            child: AlertDialog(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              backgroundColor: Colors.white.withOpacity(0),
              elevation: 0,
              content: dialogContainer(color, tasks, context),
            ),
          );
        });
  }
}
