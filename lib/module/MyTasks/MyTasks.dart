import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:ease/animations/hero_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/Componads/mybutton.dart';
import 'package:my_task/module/homelayout/layoutCuibt/cuibt.dart';
import 'package:my_task/module/homelayout/layoutCuibt/loginstates.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../AddTasks/AddTasks.dart';
import '../AddTasks/edit task.dart';

int indexl = 0;

class HomeTasks extends StatefulWidget {
  @override
  State<HomeTasks> createState() => _HomeTasksState();
}

class _HomeTasksState extends State<HomeTasks> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<layoutCuibt, mytasks>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasj = layoutCuibt.get(context).tasks;
        return Column(
          mainAxisSize: MainAxisSize.max,

          children: [
            Stack(

              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Wallpaperstack(size,),
                Textupcontenar(context,size),
                data(context,size),
                if (tasj.isEmpty)
                  Positioned(
                      top: 250,
                      left:50,
                      right: 50,
                      child: Text(
                        "you dont have any task today🥰,I wish nice day to you ❤️",
                        style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w900),
                      ))
                else
                  buldcard(tasj)
              ],
            )
          ],
        );
      },
    );
  }

  Container buldcard(List<Map<dynamic, dynamic>> tasj) {
    return Container(
      padding: const EdgeInsetsDirectional.only(
          start: 10.0, top: 20, bottom: 20, end: 30),
      width: double.infinity,
      height: 450,
      child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (tasj[index]["data"] == ondate || tasj[index]["data"] == "")
              return Hero(
                tag:1,
                  child: TaskCard(tasj[index], context,index));
            else
              return SizedBox(
                height: 0,
              );
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 1,
              ),
          itemCount: tasj.length),
    );
  }

  emptycard() {
    return Container(
        padding: const EdgeInsetsDirectional.only(
          start: 10.0,
          top: 20,
          bottom: 20,
        ),
        width: double.infinity,
        height: 450,
        decoration: BoxDecoration(
          color: HexColor("#ED9797"),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(100),
          ),
        ),
        child: const Center(
          child: Text("you dont have any task,wish a good day to you 🥰🌚 ",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              )),
        ));
  }

  Padding TaskCard(TASKS, context,index) {
    var color;
    if (TASKS["priority"] == "low") color = TaskLowColors;
    if (TASKS["priority"] == "medium") color = TaskMedColors;
    if (TASKS["priority"] == "high") color = taskHighColors;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onLongPress: () {
          HeroDialogRoute(builder:(context)=>dialogcontainer(color, TASKS,context));
        },
        child: Dismissible(
          key: Key("${TASKS["id"].toString()}"),
          onDismissed: (direction) {
            layoutCuibt.get(context).delete(id: TASKS["id"]);
            final snackBar = SnackBar(
              content: Text(
                "you deleted task number ${TASKS["id"]}",
              ),
              backgroundColor: Colors.pink,
              duration: const Duration(milliseconds: 800),
              elevation: 10.0,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: container(color, TASKS),
        ),
      ),
    );
  }

  Container container(color, TASKS) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 15, top: 5, end: 10),
      height: 85,
      width: double.infinity - 40,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius:  BorderRadius.circular(30.0),
          color: color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${TASKS["title"]}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.access_time_outlined),
              Text(
                "${TASKS["time"]}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Text(
                "${TASKS["desc"]}",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.event),
              SizedBox(
                width: 70,
                child: Text(
                  "${TASKS["data"]}",
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
    );
  }

  Hero dialogcontainer(color, TASKS,context) {
    var size=MediaQuery.of(context).size;
    return Hero(
      tag: 1,
      child: Container(
        padding: const EdgeInsetsDirectional.only(start: 15, top: 5, end: 10),
        height: 250,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(30), color: color),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width/2,
              height: 35,
              child: Text(
                "${TASKS["title"]}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: size.width/2,
              height: 52,
              child: Text(
                "${TASKS["desc"]}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(
                    fontSize: 20,
                    color: Colors.grey[900],
                    fontWeight: FontWeight.bold),
              ),
            ),

            Row(
              children: [
                const Icon(Icons.event,size: 20),
                SizedBox(
                  width: 120,
                  child: Text(
                    "${TASKS["data"]}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                const Icon(Icons.access_time_outlined),
                Text(
                  "${TASKS["time"]}",
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
                    Widget: Icon(Icons.edit),
                    function: () {
                      setState(() {
                        layoutCuibt.get(context).currentStep=2;
                      });
                      NEV(context: context,bool: true,page: EditTask(id:TASKS["id"]));
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container emptydialogcontainer(color, TASKS) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 15, top: 5, end: 10),
      height: 200,
      width: double.infinity - 40,
      clipBehavior: Clip.antiAlias,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(25), color: color),
    );
  }

  SizedBox Wallpaperstack(Size size) {
    var size=MediaQuery.of(context).size;
    return SizedBox(

      height:size.height-60,
      width: size.width,
      child: Image.asset("lib/Image/wallpaper.jpg", fit: BoxFit.fill),
    );
  }

  Positioned Textupcontenar(context,Size size) {
    return Positioned(
      top: 125,
      left: 10,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "hallo again,...",
            style: GoogleFonts.ptSerif(
                color: Colors.black,
                fontSize: 30.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 10,right: 20),
            child: mybutton(

                Widget: const Text("Add task...",
                    style: const TextStyle(color: Colors.white)),
                function: () {
                  NEV(bool: true, context: context, page: AddTasks());
                }),
          )
        ],
      ),
    );
  }

  var ondate = DateFormat.yMMMd().format(DateTime.now());

  Positioned data(context,Size size) {
    return Positioned(
      top: 40,
      left: 10,
      child: SizedBox(
        height: 80,
        width: size.width,
        child: DatePicker(DateTime.now(),
            initialSelectedDate: DateTime.now(),
            selectionColor: Colors.black,
            selectedTextColor: Colors.white, onDateChange: (value) {
          setState(() {
            ondate = DateFormat.yMMMd().format(value);
            print(ondate.toString());
            layoutCuibt.get(context).Ondate = ondate;
            layoutCuibt.get(context).getDataTasksAfterChange();
          });
        }),
      ),
    );
  }

  settingDialog(context, TASKS, color,index) {
    var size=MediaQuery.of(context).size;
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
              content:
                  dialogcontainer(color, TASKS,context),
            ),
          );
        });
  }
}
