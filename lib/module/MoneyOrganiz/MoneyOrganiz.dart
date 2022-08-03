import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/Componads/my%20textformfild.dart';
import 'package:my_task/Componads/mybutton.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../Model/Model.dart';
import '../../resorces/Resorces.dart';

class moneyOraganize extends StatefulWidget {
  @override
  State<moneyOraganize> createState() => _moneyOraganizeState();
}

class _moneyOraganizeState extends State<moneyOraganize> {
  var salaryController = TextEditingController();
  var scrollController = ScrollController();
  var gaining = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
        listener: (context, state) {},
        builder: (context, state) {
          var cuibt = layoutCuibt.get(context);
          var size = MediaQuery
              .of(context)
              .size;
          double precent = (cuibt.salaryAfter / cuibt.salary);
          return ConditionalBuilder(
            condition: cuibt.salary != 0&&cuibt.users.isNotEmpty,
            builder: (context) =>
                SafeArea(
                  top: true,
                  bottom: false,
                  right: false,
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width,
                      height: size.height,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/Image/businessWallpepar.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          Flexible(child: precentgeCircular(size, precent,)),
                          Flexible(
                            flex: 2,
                              child: showCategoryByGridView(context, cuibt)),
                         const  SizedBox(height: 25)
                        ],
                      ),
                    ),
                  ),
                ),
            fallback: (context) =>
                Container(

                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/Image/businessWallpepar.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Enter your salary",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 30.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadiusDirectional.circular(
                                    25.0)),
                            child: TextFormField(
                                controller: salaryController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Write your salary",
                                    prefixIcon: Icon(
                                      Icons.attach_money,
                                      color: Colors.green,
                                    )),
                                onFieldSubmitted: (String) =>
                                    cuibt.setSalary(String)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          );
        });
  }

  Widget showCategoryByGridView(context, layoutCuibt cuibt) {
    return GridView.count(
      shrinkWrap: true,
      controller: scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      scrollDirection: Axis.horizontal,
      crossAxisCount: 3,
      children: List.generate(
          layoutCuibt
              .get(context)
              .users[0]["status"] == "Single"
              ? layoutCuibt
              .get(context)
              .singleCategory
              .length
              : layoutCuibt
              .get(context)
              .marriedCategory
              .length,
              (index) =>
              categoryAvatar(
                  layoutCuibt
                      .get(context)
                      .users[0]["status"] == "Single"
                      ? layoutCuibt
                      .get(context)
                      .singleCategory[index]
                      : layoutCuibt
                      .get(context)
                      .marriedCategory[index],
                  context, cuibt)),
    );
  }

  Column categoryAvatar(CategoryModel model, context, layoutCuibt cuibt) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            layoutCuibt
                .get(context)
                .catagoryController
                .text = model.photo!;
            // to make differance between if the user gain or lost money
            if (layoutCuibt
                .get(context)
                .catagoryController
                .text ==
                "lib/Image/gainMoney.webp") {
              setState(() {
                gaining = true;
              });
            } else {
              setState(() {
                gaining = false;
              });
            }
            showBottomSheet(context, cuibt);
          },
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.8),
                borderRadius: BorderRadiusDirectional.circular(30.0)),
            child: Column(
              children: [
                const SizedBox(
                  height: 3,
                ),
                CircleAvatar(
                  radius: 53,
                  backgroundColor: Colors.redAccent.shade700,
                  foregroundColor: Colors.white,
                  child: CircleAvatar(
                    foregroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      model.photo!,
                    ),
                    radius: 50.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                Text(
                  model.title!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget precentgeCircular(Size size,
      double percent,) {
    return SizedBox(
      height: size.height * .3,
      width: size.width * .9,
      child: CircularPercentIndicator(
        radius: 250,
        lineWidth: 12,
        linearGradient: const LinearGradient(colors: [
          Colors.tealAccent,
          Colors.blue,
        ]),
        percent: percent > 1 ? 1 : percent,
        center: Text("${(percent * 100).ceil()}%",
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        arcBackgroundColor: Colors.white54,
        animation: true,
        addAutomaticKeepAlive: true,
        animationDuration: 1200,
        animateFromLastPercent: false,
        curve: Curves.easeInCubic,
        arcType: ArcType.FULL,
      ),
    );
  }

  Future showBottomSheet(context, layoutCuibt cuibt) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      context: context,
      builder: (context) {
        final String category = cuibt.handleCategory(
            cuibt.catagoryController.text);
        return SafeArea(
          top: true,
          child: Material(
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
              child: gaining
                  ? Form(
                key:cuibt.dialogFormKey,
                    child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    const Text(
                      "Gain Money",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.black),
                    ),
                    Mytextfield(
                        Controlr: cuibt.titleController,
                        hint: "How you gain this money?",
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter a title";
                        }
                        return null;
                      }

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Mytextfield(
                              keybordtype: TextInputType.none,
                              Controlr: cuibt.dataController,
                              hint: "When?",
                              func: () =>
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-11-07'),
                                  ).then((value) {
                                    value??=DateTime.now();
                                    cuibt.budgetDate(value);
                                  }),
                                validator: (value){
                                  if(value.isEmpty){
                                    return "Please enter a Time";
                                  }
                                  return null;
                                }

                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Mytextfield(
                              Enabled: false,
                              hint: category,
                            )),
                      ],
                    ),
                    Mytextfield(
                        keybordtype: const TextInputType.numberWithOptions(),
                        Controlr: cuibt.moneyController,
                        hint: "How much you gain?",
                        validator: (value){
                          if(value.isEmpty){
                            return "Please enter a money";
                          }
                          return null;
                        }


                    ),

                    mybutton(
                        Widget: const Text("Okay!"),
                        function: () {
                          if(cuibt.dialogFormKey.currentState!.validate()){
                            cuibt.insertBudget(
                                title: cuibt.titleController.text,
                                money:
                                double.parse(cuibt.moneyController.text),
                                data: cuibt.dataController.text,
                                category: cuibt.catagoryController.text)
                                .then((value) {
                              Navigator.pop(context);
                              setState(() {
                                gaining = false;
                              });
                            });
                          }

                        }),
                ],
              ),
                  )
                  : Form(
                key: cuibt.dialogFormKey,
                    child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    const Text(
                      "Why you spend money ?",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.black),
                    ),
                    Mytextfield(
                        Controlr: cuibt.titleController,
                        hint: "Reason for spending money ?",
                    validator: (value){
                      if(value.isEmpty){
                        return "Please enter a title";
                      }
                      return null;
                    }
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Mytextfield(
                              keybordtype: TextInputType.none,
                              Controlr: cuibt.dataController,
                              hint: "When?",
                              func: () =>
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-11-07'),
                                  ).then((value) {
                                    value ??= DateTime.now();
                                    cuibt.budgetDate(value);
                                  }),
                                validator: (value){
                                  if(value.isEmpty){
                                    return "Please enter a Time";
                                  }
                                  return null;
                                }
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Mytextfield(
                              Enabled: false,
                              hint: category,
                            )),
                      ],
                    ),
                    Mytextfield(
                        keybordtype: const TextInputType.numberWithOptions(),
                        Controlr: cuibt.moneyController,
                        hint: "How much did you spend ?",
                    validator:(value){
                      if(value.isEmpty){
                        return "Please enter a money";
                      }
                      return null;
                    }
                    ),

                    mybutton(
                        Widget: const Text("Okay!"),
                        function: () {
                          if(cuibt.dialogFormKey.currentState!.validate()){
                            if (double.parse(cuibt.moneyController.text) >
                                cuibt.salaryAfter) {
                              Navigator.pop(context);
                              showDialog(
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) =>
                                      AlertDialog(
                                        title: const Text("Alert"),
                                        backgroundColor: Colors.white,
                                        content: const Text(
                                            "you cant do that bc you don't have enough money ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        actions: [
                                          Container(
                                            width: double.maxFinite,
                                            decoration: BoxDecoration(
                                              color: ColorManger.TaskMedColors,
                                              borderRadius:
                                              BorderRadiusDirectional
                                                  .circular(25.0),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  cuibt.titleController.clear();
                                                  cuibt.descController.clear();
                                                  cuibt.moneyController.clear();
                                                  cuibt.dataController.clear();
                                                  cuibt.catagoryController
                                                      .clear();
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: const Text("okay!",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  )),
                                              style: const ButtonStyle(
                                                animationDuration:
                                                Duration(milliseconds: 900),
                                              ),
                                            ),
                                          )
                                        ],
                                      ));
                            } else {
                              cuibt
                                  .insertBudget(
                                  title: cuibt.titleController.text,
                                  money: double.parse(
                                      cuibt.moneyController.text),
                                  data: cuibt.dataController.text,
                                  category: cuibt.catagoryController.text)
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            }
                          }

                        }),
                ],
              ),
                  ),
            ),
          ),
        );
      },
    );
  }
}