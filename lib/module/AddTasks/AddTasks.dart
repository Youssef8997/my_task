import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/Componads/my%20textformfild.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:my_task/module/homelayout/layoutCuibt/cuibt.dart';
import 'package:my_task/module/homelayout/layoutCuibt/loginstates.dart';

var title = TextEditingController();
var desc = TextEditingController();
var date = TextEditingController();
var time = TextEditingController();
var now = DateTime.now();

class Tasks extends StatefulWidget {
  final int ?id;
  const Tasks({super.key,this.id});

  @override
  State<Tasks> createState() => _TasksState(id: id);
}

class _TasksState extends State<Tasks> {
  final int ?id;
  _TasksState({this.id});
  @override
  void initState() {
    time.text = DateFormat('HH:mm').format(now);
    date.text = DateFormat.yMMMd().format(now);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
        listener: (context, state) {},
        builder: (context, state) {
          var size = MediaQuery.of(context).size;
          var cuibt = layoutCuibt.get(context);
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: appbar(),
            body: wallPaperContainer(
              Child: buildStepper(cuibt),
              pathImage: "lib/Image/AddtaskBack.jpg",
              size: size,
            ),
          );
        });
  }

  Form buildStepper(layoutCuibt cuibt) {
    return Form(
      key: cuibt.addTask,
      child: Stepper(

        currentStep: cuibt.currentStep,
        type: StepperType.vertical,
        steps: [
          Step(
            title: const Text("title",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            content: Mytextfield(
              hint: "Write title of your task......",
              Controlr: title,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please write title";
                }
                return null;
              },
            ),
            state:
                cuibt.currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("description",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            content: Mytextfield(
              hint: "Write description of your task......",
              Controlr: desc,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please write description";
                }
                return null;
              },
            ),
            state:
                cuibt.currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("Time",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            content: InkWell(
              onTap: () {
                showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.input)
                    .then((value) {
                  time.text = value!.format(context).toString();
                });
              },
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.access_time)),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Enter time ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            state:
                cuibt.currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("date",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            content: InkWell(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.parse('2022-11-07'),
                ).then((value) {
                  date.text = DateFormat.yMMMd().format(value!);
                });
              },
              child: Row(
                children: const [
                  Icon(Icons.calendar_today_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Enter date ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            state:
                cuibt.currentStep > 3 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("repeat"),
            content: DropdownButton(
                hint: Text("${cuibt.firstValue} repeat",
                    style: const TextStyle(color: Colors.black)),
                items: const [
                  DropdownMenuItem(
                    child: Text("5 Min"),
                    value: "5 Min",
                    enabled: true,
                  ),
                  DropdownMenuItem(
                    child: Text("10 Min"),
                    value: "10 Min",
                    enabled: true,
                  ),
                  DropdownMenuItem(
                    child: Text("30 Min"),
                    value: "30 Min",
                    enabled: true,
                  ),
                  DropdownMenuItem(
                    child: Text("1 hour"),
                    value: "1 hour",
                    enabled: true,
                  ),
                  DropdownMenuItem(
                    child: Text("Daily"),
                    value: "Daily",
                    enabled: true,
                  ),
                ],
                value: cuibt.firstValue,
                onChanged: (Object? value) => cuibt.changevaluerepeat(value)),
            state:
                cuibt.currentStep > 4 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("priority",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            content: DropdownButton(
                hint: Text("${cuibt.scondValue} priority",
                    style: const TextStyle(color: Colors.black)),
                items: const [
                  DropdownMenuItem(
                    child: Text("high,"),
                    value: "high",
                    enabled: true,
                  ),
                  DropdownMenuItem(
                    child: Text("medium"),
                    value: "medium",
                    enabled: true,
                  ),
                  DropdownMenuItem(
                    child: Text("low"),
                    value: "low",
                    enabled: true,
                  ),
                ],
                value: cuibt.scondValue,
                onChanged: (Object? value) => cuibt.changevaluepri(value)),
            state:
                cuibt.currentStep > 5 ? StepState.complete : StepState.indexed,
          ),
        ],
        onStepContinue: () =>id==null? cuibt.onPressedContinue(context):cuibt.pressedContinueEdit(context: context,id:id,),
        onStepCancel: () => cuibt.onPressedCancel(context),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back,color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.transparent,
      title: "Add Task".text.make().shimmer(
            duration: const Duration(seconds: 2),
          ),
      centerTitle: true,
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("lib/Image/manavatar.jpg"),
          ),
        ),
      ],
    );
  }
}
