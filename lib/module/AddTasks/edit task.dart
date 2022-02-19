import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:my_task/Componads/my%20textformfild.dart';
import 'package:my_task/module/MyTasks/MyTasks.dart';
import 'package:my_task/module/homelayout/layoutCuibt/cuibt.dart';
import 'package:my_task/module/homelayout/layoutCuibt/loginstates.dart';

var datel = TextEditingController();
var timed = TextEditingController();
var now=DateTime.now();
class EditTask extends StatefulWidget {
  final id;
   EditTask({ this.id}) ;

  @override
  State<EditTask> createState() => _EditTaskState(id:id);
}
@override
Future<void> initState() async {
  timed.text =TimeOfDay.now().toString();
}
class _EditTaskState extends State<EditTask> {
  final id;
  _EditTaskState({ this.id}) ;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<layoutCuibt, mytasks>(
        listener: (context, state) {},
        builder: (context, state) {
          var cuibt = layoutCuibt.get(context);
          return Scaffold(
            appBar: appbar(),
            body: SingleChildScrollView(
              child: Stack(
                children: [Wallpaperstack(size),
                  buildStepper(cuibt,id)],
              ),
            ),
          );
        });
  }

  SizedBox Wallpaperstack(Size size) {
    return SizedBox(
      height: size.height - 106,
      width: size.width,
      child: Image.asset("lib/Image/AddtaskBack.jpg", fit: BoxFit.fill),
    );
  }

  Stepper buildStepper(layoutCuibt cuibt,id) {
    return Stepper(
      currentStep: cuibt.currentStep,
      type: StepperType.vertical,
      steps: [
        Step(
          title: Text("title", style: TextStyle(color: Colors.white)),
          content: Mytextfield(
              hint: "Write title of your task......",Enabled: false),
          state: cuibt.currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text("description"),
          content: Mytextfield(
              hint: "Write description of your task......",Enabled: false),
          state: cuibt.currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text("Time"),
          content: InkWell(
            onTap: () {
              showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  initialEntryMode: TimePickerEntryMode.input
              )
                  .then((value) {
                    setState(() {
                      timed.text = value!.format(context).toString();
                    });
              });
            },
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.access_time)),
                SizedBox(
                  width: 10,
                ),
                Text("Enter time "),
              ],
            ),
          ),
          state: cuibt.currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text("date"),
          content: InkWell(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.parse('2022-11-07'),
              ).then((value) {
                setState(() {
                  datel.text =DateFormat.yMMMd().format(value!);
                });


              });
            },
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined),
                SizedBox(
                  width: 10,
                ),
                Text("Enter date "),
              ],
            ),
          ),
          state: cuibt.currentStep > 3 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text("repeat"),
          content: DropdownButton(
              hint: Text("${cuibt.firstvalue} repeat",
                  style: TextStyle(color: Colors.black)),
              items: [
                DropdownMenuItem(
                  child: const Text("5 Min"),
                  value: "5 Min",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: const Text("10 Min"),
                  value: "10 Min",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: const Text("30 Min"),
                  value: "30 Min",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: const Text("1 hour"),
                  value: "1 hour",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: const Text("Daily"),
                  value: "Daily",
                  enabled: true,
                ),
              ],
              value: cuibt.firstvalue,
              onChanged: (Object? value) => cuibt.changevaluerepeat(value)),
          state: cuibt.currentStep > 4 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text("priority"),
          content: DropdownButton(
              hint: Text("${cuibt.Scondvalue} priority",
                  style: TextStyle(color: Colors.black)),
              items: [
                DropdownMenuItem(
                  child: const Text("high,"),
                  value: "high",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: const Text("medium"),
                  value: "medium",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: const Text("low"),
                  value: "low",
                  enabled: true,
                ),
              ],
              value: cuibt.Scondvalue,
              onChanged: (Object? value) => cuibt.changevaluepri(value)),
          state: cuibt.currentStep > 5 ? StepState.complete : StepState.indexed,
        ),
      ],
      onStepContinue: () => cuibt.OnPressedContStepperEdit(context: context,id:1,),
      onStepCancel: () => cuibt.OnPressedcacselStepper(context),
    );
  }

  AppBar appbar() {
    return AppBar(
      backgroundColor: maincolor,
      title: Text("Edit Task".toUpperCase()),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("lib/Image/man avatar.jpg"),
          ),
        ),
      ],
    );
  }
}
