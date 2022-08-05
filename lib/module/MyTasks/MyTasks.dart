
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/Componads/mybutton.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../../Translition/locale_kays.g.dart';
import '../../resorces/Resorces.dart';
import '../AddTasks/AddTasks.dart';


class HomeTasks extends StatefulWidget {
  const HomeTasks({super.key});

  @override
  State<HomeTasks> createState() => _HomeTasksState();
}

class _HomeTasksState extends State<HomeTasks> {
  var _date = DateFormat.yMMMd().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
      listener: (context, state) {},
      builder: (context, state) {
        var size = MediaQuery.of(context).size;
        var _tasks = layoutCuibt.get(context).tasks;
        var cuibt = layoutCuibt.get(context);
        return wallPaperContainer(
            Child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //calender date to show tasks for that day
                  dateCalendar(context, size),
                  // row of buttons to add tasks and hi massage,
                  textUpContainer(context, size,cuibt),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  if (_tasks.isEmpty)
                     Center(
                        heightFactor: 5,
                        child:  Padding(
                          padding: const EdgeInsets.all(15),
                          child:  Text(
                            LocaleKeys.dontHaveTask.tr(),
                            style: const TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.w900),
                          ),
                        ))
                  else
                    taskCard(_tasks, size)
                ],
              ),
            ),
            pathImage: "lib/Image/wallpaper.jpg",
            size: size);
      },
    );
  }

  Container taskCard(List<Map<dynamic, dynamic>> tasks, Size size) {
    return Container(
      padding: const EdgeInsetsDirectional.only(
          start: 10.0, top: 20, bottom: 20, end: 30),
      width: size.width,
      height: size.height * 0.6,
      child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            /*if (tasks[index]["data"] == _date) {*/
              return cardModel(tasks[index], context, index,size);
         /*   } else {
              return const SizedBox(
                height: 0,
              );
            }*/
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 1,
              ),
          itemCount: tasks.length),
    );
  }


  Padding cardModel(tasks, context, index,Size size) {
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
            key: Key("${tasks["id"].toString()}"),
            onDismissed: (direction) {
              //to delete the task from the database
              layoutCuibt.get(context).delete(id: tasks["id"]);
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
              height: 85,
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
                        width: size.width *.5,
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
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width *.5,
                        child: Text(
                          "${tasks["desc"]}",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[300],
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.event),
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
              mybutton(
                  Widget: const Icon(Icons.edit),
                  function: () {
                    setState(() {
                      layoutCuibt.get(context).currentStep = 2;
                    });
                    Nevigator(
                        context: context,
                        bool: true,
                        page: Tasks(id: tasks["id"]));
                  }),
            ],
          )
        ],
      ),
    );
  }

  Row textUpContainer(context, Size size,layoutCuibt cuibt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            LocaleKeys.hallo.tr(),
            style: GoogleFonts.ptSerif(
                color: Colors.black,
                fontSize: 30.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 20),
          child: mybutton(
              Widget:  Text("${LocaleKeys.AddTask.tr()}....",
                  style: const TextStyle(color: Colors.white)),
              function: ()=>cuibt.onPressedAdd(context)),
        )
      ],
    );
  }

  SizedBox dateCalendar(context, Size size) {
    return SizedBox(
      height: 80,
      width: size.width,
      child: DatePicker(
          DateTime.now(),
          initialSelectedDate: DateTime.now(),
          selectionColor: Colors.black,
          selectedTextColor: Colors.white, onDateChange: (value) {
        setState(() {
          _date = DateFormat.yMMMd("en").format(value);
          layoutCuibt.get(context).onDate = _date;
          layoutCuibt.get(context).insertTaskIntoVar();
        });
      }),
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
