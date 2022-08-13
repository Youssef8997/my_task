import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/Componads/my%20textformfild.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:shimmer/shimmer.dart';

import '../../Translition/locale_kays.g.dart';

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
    time.text = DateFormat('H:mm a', "en").format(now);
    date.text = DateFormat.yMMMd("en").format(now);
    layoutCuibt.get(context).repeated = "Never";
    layoutCuibt.get(context).priorityed = "medium";
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-7041190612164401/5151161150',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            setState(() {
              Interstitial = ad;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
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
            LocaleKeys.Daily.tr(),
            LocaleKeys.Weekly.tr(),
            LocaleKeys.Monthly.tr(),
            LocaleKeys.Never.tr()
          ];
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: appbar(),
            body: wallPaperContainer(
              Child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.12,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) =>
                              categoryAvatar(repeated[i], size, cuibt),
                          separatorBuilder: (context, _) => SizedBox(
                            width: 25,
                          ),
                          itemCount: 4,
                        ),
                      ),
                      if (cuibt.repeated == "Never") NeverStepper(cuibt),
                      if (cuibt.repeated == "Daily") DailyStepper(cuibt),
                      if (cuibt.repeated == "Weekly") weeklyStepper(cuibt),
                      if (cuibt.repeated == "Monthly") NeverStepper(cuibt),
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

  Stepper NeverStepper(layoutCuibt cuibt) {
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
          content: Mytextfield(
            hint: "${LocaleKeys.TitleHint.tr()}......",
            Controlr: title,
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
          content: Mytextfield(
            hint: "${LocaleKeys.DescriptionHint.tr()}......",
            Controlr: desc,
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
          title: Text(
              cuibt.repeated == "Never" ? LocaleKeys.Date.tr() : "date of task",
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
                      initialTime: TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.input)
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
                  child: Text(LocaleKeys.High.tr()),
                  value: "high",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text(LocaleKeys.Medium.tr()),
                  value: "medium",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text(LocaleKeys.Low.tr()),
                  value: "low",
                  enabled: true,
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
          content: Mytextfield(
            hint: "${LocaleKeys.TitleHint.tr()}......",
            Controlr: title,
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
          content: Mytextfield(
            hint: "${LocaleKeys.DescriptionHint.tr()}......",
            Controlr: desc,
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
          title: Text("date of start reminder",
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
                      initialTime: TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.input)
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
                  child: Text(LocaleKeys.High.tr()),
                  value: "high",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text(LocaleKeys.Medium.tr()),
                  value: "medium",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text(LocaleKeys.Low.tr()),
                  value: "low",
                  enabled: true,
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
          content: Mytextfield(
            hint: "${LocaleKeys.TitleHint.tr()}......",
            Controlr: title,
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
          content: Mytextfield(
            hint: "${LocaleKeys.DescriptionHint.tr()}......",
            Controlr: desc,
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
                      initialTime: TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.input)
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
          title: Text("day of week",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: DropdownButton(
              hint: Text("${cuibt.repeated}",
                  style: const TextStyle(color: Colors.black)),
              items: [
                DropdownMenuItem(
                  child: Text("Sunday"),
                  value: "7",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text("Monday"),
                  value: "1",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text("Tuesday"),
                  value: "2",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text("Wednesday"),
                  value: "3",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text("Thursday"),
                  value: "4",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text("Friday"),
                  value: "5",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text("Saturday"),
                  value: "6",
                  enabled: true,
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
                  child: Text(LocaleKeys.High.tr()),
                  value: "high",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text(LocaleKeys.Medium.tr()),
                  value: "medium",
                  enabled: true,
                ),
                DropdownMenuItem(
                  child: Text(LocaleKeys.Low.tr()),
                  value: "low",
                  enabled: true,
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

  Column categoryAvatar(title, Size size, layoutCuibt cuibt) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              cuibt.repeated = title;
            });
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: cuibt.repeated == title
                    ? Colors.teal
                    : Colors.redAccent.shade700,
                foregroundColor: Colors.white,
                child: CircleAvatar(
                  foregroundColor: Colors.white,
                  child: Text(
                    "$title",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w900),
                  ),
                  radius: 35.0,
                  backgroundColor: Colors.white,
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
