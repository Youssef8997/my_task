// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_task/Componads/componads.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:shimmer/shimmer.dart';

import '../../Componads/my_text_form.dart';
import '../../Translition/locale_kays.g.dart';
import '../MyTasks/MyTasks.dart';

var title = TextEditingController();
var desc = TextEditingController();
var date = TextEditingController();
var time = TextEditingController();
var now = DateTime.now();

class Tasks extends StatefulWidget {
  final int? id;

  const Tasks({super.key, this.id});

  @override
  State<Tasks> createState() => _TasksState(id: id);
}

class _TasksState extends State<Tasks> {
  final int? id;

  _TasksState({this.id});

  var Interstitial;

  @override
  void initState() {
    if (id == null) {
      time.text = DateFormat('H:mm a', "en").format(now);
      date.text = DateFormat.yMMMd("en").format(now);
      layoutCuibt.get(context).repeated = "Never";
      layoutCuibt.get(context).priorityed = "medium";
    }
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-7041190612164401/5151161150',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            setState(() {
              Interstitial = ad;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
          },
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
        listener: (context, state) {},
        builder: (context, state) {
          var size = MediaQuery.of(context).size;
          var cuibt = layoutCuibt.get(context);
          List repeated = [
            LocaleKeys.Never.tr(),
            LocaleKeys.Daily.tr(),
            LocaleKeys.Weekly.tr(),
            LocaleKeys.Monthly.tr(),
          ];
          List values = [
            "Never",
            "Daily",
            "Weekly",
            "Monthly",
          ];
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: appbar(),
            body: wallPaperContainer(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.12,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) => categoryAvatar(
                              repeated[i], size, cuibt, values[i]),
                          separatorBuilder: (context, _) => const SizedBox(
                            width: 25,
                          ),
                          itemCount: 4,
                        ),
                      ),
                      if (cuibt.repeated == "Never") neverStepper(cuibt),
                      if (cuibt.repeated == "Daily") DailyStepper(cuibt),
                      if (cuibt.repeated == "Weekly") weeklyStepper(cuibt),
                      if (cuibt.repeated == "Monthly") neverStepper(cuibt),
                    ],
                  ),
                ),
              ),
              pathImage: "lib/Image/AddtaskBack.jpg",
              size: size,
            ),
          );
        });
  }

  Stepper neverStepper(layoutCuibt cuibt) {
    return Stepper(
      currentStep: cuibt.currentStep,
      type: StepperType.vertical,
      steps: [
        Step(
          title: Text(LocaleKeys.Title.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: myTextForm(
            hint: "${LocaleKeys.TitleHint.tr()}......",
            controller: title,
            validator: (value) {
              if (value.isEmpty) {
                return "Please write title";
              }
              return null;
            },
          ),
          state: cuibt.currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.Description.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: myTextForm(
            hint: "${LocaleKeys.DescriptionHint.tr()}......",
            controller: desc,
            validator: (value) {
              if (value.isEmpty) {
                return "Please write description";
              }
              return null;
            },
          ),
          state: cuibt.currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.Date.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: InkWell(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1),
              ).then((value) {
                date.text = DateFormat.yMMMd("en").format(value!);
              });
            },
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined),
                const SizedBox(
                  width: 10,
                ),
                Text(LocaleKeys.EnterDate.tr(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          state: cuibt.currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.time.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: InkWell(
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: id == null
                    ? TimeOfDay.now()
                    : TimeOfDay.fromDateTime(
                        DateTime(
                            cuibt.handleTime()["year"],
                            cuibt.handleTime()["month"],
                            cuibt.handleTime()["day"],
                            cuibt.handleTime()["hour"],
                            cuibt.handleTime()["minute"]),
                      ),
                initialEntryMode: TimePickerEntryMode.dial,
                helpText: LocaleKeys.EnterTime.tr(),
              ).then((value) {
                value ??= TimeOfDay.now();
                time.text = value.format(context).toString();
              });
            },
            child: Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.access_time)),
                const SizedBox(
                  width: 10,
                ),
                Text(LocaleKeys.EnterTime.tr(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          state: cuibt.currentStep > 3 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.priority.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: DropdownButton(
              hint: Text("${cuibt.priorityed} priority",
                  style: const TextStyle(color: Colors.black)),
              items: [
                DropdownMenuItem(
                  value: "high",
                  enabled: true,
                  child: Text(LocaleKeys.High.tr()),
                ),
                DropdownMenuItem(
                  value: "medium",
                  enabled: true,
                  child: Text(LocaleKeys.Medium.tr()),
                ),
                DropdownMenuItem(
                  value: "low",
                  enabled: true,
                  child: Text(LocaleKeys.Low.tr()),
                ),
              ],
              value: cuibt.priorityed,
              onChanged: (Object? value) => cuibt.changevaluepri(value)),
          state: cuibt.currentStep > 4 ? StepState.complete : StepState.indexed,
        ),
      ],
      onStepContinue: () {
        id == null
            ? cuibt.onPressedContinue(context, myInterstitial: Interstitial)
            : cuibt.pressedContinueEdit(
                context: context, id: id, myInterstitial: Interstitial);
      },
      onStepCancel: () => cuibt.onPressedCancel(context),
    );
  }

  Stepper DailyStepper(layoutCuibt cuibt) {
    return Stepper(
      currentStep: cuibt.currentStep,
      type: StepperType.vertical,
      steps: [
        Step(
          title: Text(LocaleKeys.Title.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: myTextForm(
            hint: "${LocaleKeys.TitleHint.tr()}......",
            controller: title,
            validator: (value) {
              if (value.isEmpty) {
                return "Please write title";
              }
              return null;
            },
          ),
          state: cuibt.currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.Description.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: myTextForm(
            hint: "${LocaleKeys.DescriptionHint.tr()}......",
            controller: desc,
            validator: (value) {
              if (value.isEmpty) {
                return "Please write description";
              }
              return null;
            },
          ),
          state: cuibt.currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.dateReminder.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: InkWell(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1),
              ).then((value) {
                date.text = DateFormat.yMMMd("en").format(value!);
              });
            },
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined),
                const SizedBox(
                  width: 10,
                ),
                Text(LocaleKeys.EnterDate.tr(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          state: cuibt.currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.time.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: InkWell(
            onTap: () {
              showTimePicker(
                      context: context,
                      initialTime: id == null
                          ? TimeOfDay.now()
                          : TimeOfDay.fromDateTime(
                              DateTime(
                                  cuibt.handleTime()["year"],
                                  cuibt.handleTime()["month"],
                                  cuibt.handleTime()["day"],
                                  cuibt.handleTime()["hour"],
                                  cuibt.handleTime()["minute"]),
                            ),
                initialEntryMode: TimePickerEntryMode.dial,
                helpText: LocaleKeys.EnterTime.tr(),
              )
                  .then((value) {
                value ??= TimeOfDay.now();
                time.text = value.format(context).toString();
              });
            },
            child: Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.access_time)),
                const SizedBox(
                  width: 10,
                ),
                Text(LocaleKeys.EnterTime.tr(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          state: cuibt.currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.priority.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: DropdownButton(
              hint: Text("${cuibt.priorityed} priority",
                  style: const TextStyle(color: Colors.black)),
              items: [
                DropdownMenuItem(
                  value: "high",
                  enabled: true,
                  child: Text(LocaleKeys.High.tr()),
                ),
                DropdownMenuItem(
                  value: "medium",
                  enabled: true,
                  child: Text(LocaleKeys.Medium.tr()),
                ),
                DropdownMenuItem(
                  value: "low",
                  enabled: true,
                  child: Text(LocaleKeys.Low.tr()),
                ),
              ],
              value: cuibt.priorityed,
              onChanged: (Object? value) => cuibt.changevaluepri(value)),
          state: cuibt.currentStep > 3 ? StepState.complete : StepState.indexed,
        ),
      ],
      onStepContinue: () {
        id == null
            ? cuibt.onPressedContinue(context, myInterstitial: Interstitial)
            : cuibt.pressedContinueEdit(
                context: context, id: id, myInterstitial: Interstitial);
      },
      onStepCancel: () => cuibt.onPressedCancel(context),
    );
  }

  Stepper weeklyStepper(layoutCuibt cuibt) {
    return Stepper(
      currentStep: cuibt.currentStep,
      type: StepperType.vertical,
      steps: [
        Step(
          title: Text(LocaleKeys.Title.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: myTextForm(
            hint: "${LocaleKeys.TitleHint.tr()}......",
            controller: title,
            validator: (value) {
              if (value.isEmpty) {
                return "Please write title";
              }
              return null;
            },
          ),
          state: cuibt.currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.Description.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: myTextForm(
            hint: "${LocaleKeys.DescriptionHint.tr()}......",
            controller: desc,
            validator: (value) {
              if (value.isEmpty) {
                return "Please write description";
              }
              return null;
            },
          ),
          state: cuibt.currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.time.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: InkWell(
            onTap: () {
              showTimePicker(
                      context: context,
                      initialTime: id == null
                          ? TimeOfDay.now()
                          : TimeOfDay.fromDateTime(
                              DateTime(
                                  cuibt.handleTime()["year"],
                                  cuibt.handleTime()["month"],
                                  cuibt.handleTime()["day"],
                                  cuibt.handleTime()["hour"],
                                  cuibt.handleTime()["minute"]),
                            ),
                initialEntryMode: TimePickerEntryMode.dial,
                helpText: LocaleKeys.EnterTime.tr(),              )
                  .then((value) {
                value ??= TimeOfDay.now();
                time.text = value.format(context).toString();
              });
            },
            child: Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.access_time)),
                const SizedBox(
                  width: 10,
                ),
                Text(LocaleKeys.EnterDate.tr(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          state: cuibt.currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.dayOfWeek.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: DropdownButton(
              hint: Text("${cuibt.Weekday}",
                  style: const TextStyle(color: Colors.black)),
              items: [
                DropdownMenuItem(
                  value: 7,
                  enabled: true,
                  child: Text(LocaleKeys.Sunday.tr()),
                ),
                DropdownMenuItem(
                  value: 1,
                  enabled: true,
                  child: Text(LocaleKeys.Monday.tr()),
                ),
                DropdownMenuItem(
                  value: 2,
                  enabled: true,
                  child: Text(LocaleKeys.Tuesday.tr()),
                ),
                DropdownMenuItem(
                  value: 3,
                  enabled: true,
                  child: Text(LocaleKeys.Wednesday.tr()),
                ),
                DropdownMenuItem(
                  value: 4,
                  enabled: true,
                  child: Text(LocaleKeys.Thursday.tr()),
                ),
                DropdownMenuItem(
                  value: 5,
                  enabled: true,
                  child: Text(LocaleKeys.Friday.tr()),
                ),
                DropdownMenuItem(
                  value: 6,
                  enabled: true,
                  child: Text(LocaleKeys.Saturday.tr()),
                ),
              ],
              value: cuibt.Weekday,
              onChanged: (Object? value) => cuibt.changeValueWeekDay(value)),
          state: cuibt.currentStep > 3 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(LocaleKeys.priority.tr(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: DropdownButton(
              hint: Text("${cuibt.priorityed} priority",
                  style: const TextStyle(color: Colors.black)),
              items: [
                DropdownMenuItem(
                  value: "high",
                  enabled: true,
                  child: Text(LocaleKeys.High.tr()),
                ),
                DropdownMenuItem(
                  value: "medium",
                  enabled: true,
                  child: Text(LocaleKeys.Medium.tr()),
                ),
                DropdownMenuItem(
                  value: "low",
                  enabled: true,
                  child: Text(LocaleKeys.Low.tr()),
                ),
              ],
              value: cuibt.priorityed,
              onChanged: (Object? value) => cuibt.changevaluepri(value)),
          state: cuibt.currentStep > 4 ? StepState.complete : StepState.indexed,
        ),
      ],
      onStepContinue: () {
        id == null
            ? cuibt.onPressedContinue(context, myInterstitial: Interstitial)
            : cuibt.pressedContinueEdit(
                context: context, id: id, myInterstitial: Interstitial);
      },
      onStepCancel: () => cuibt.onPressedCancel(context),
    );
  }

  Column categoryAvatar(title, Size size, layoutCuibt cuibt, values) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              cuibt.repeated = values;
            });
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: cuibt.repeated == values
                    ? Colors.teal
                    : Colors.redAccent.shade700,
                foregroundColor: Colors.white,
                child: CircleAvatar(
                  foregroundColor: Colors.white,
                  radius: 38.0,
                  backgroundColor: Colors.white,
                  child: Text(
                    "$title",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ],
    );
  }

  AppBar appbar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
          layoutCuibt.get(context).currentStep = 0;
          layoutCuibt.get(context).insertTaskIntoVar("Never",datab: layoutCuibt.get(context).datab);
setState(() {
  notRepeated = true;
  isDaily = false;
  isWeekly = false;
  isMonthly = false;
});
        },
      ),
      backgroundColor: Colors.transparent,
      title: Shimmer.fromColors(
        baseColor: Colors.black,
        highlightColor: Colors.grey,
        child: Text(
          LocaleKeys.AddTask.tr(),
          style: const TextStyle(color: Colors.black),
        ),
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
