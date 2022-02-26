import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/Componads/my%20textformfild.dart';
import 'package:my_task/Componads/mybutton.dart';
import 'package:my_task/module/homelayout/layoutCuibt/cuibt.dart';
import 'package:my_task/module/homelayout/layoutCuibt/loginstates.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MoneyOraganize extends StatefulWidget {
  @override
  State<MoneyOraganize> createState() => _MoneyOraganizeState();
}

class _MoneyOraganizeState extends State<MoneyOraganize> {
  @override
  var SalaryContoralr = TextEditingController();
  var scrollControlar = ScrollController();
  var gaining = false;

  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
        listener: (context, state) {},
        builder: (context, state) {
          var cuibt = layoutCuibt.get(context);
          var size = MediaQuery.of(context).size;
          return ConditionalBuilder(
            condition: cuibt.sallary != 0,
            builder: (context) => SafeArea(
              child: PageView(
                allowImplicitScrolling: true,
                scrollBehavior: ScrollBehavior(
                    androidOverscrollIndicator:
                        AndroidOverscrollIndicator.stretch),
                controller: cuibt.controlar,
                scrollDirection: Axis.horizontal,
                children: [
                  EndWidget(size, cuibt.sallaryAfter, context),
                  Stack0salary(size, cuibt.sallary, context)
                ],
              ),
            ),
            fallback: (context) => Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Wallpaperstack(size),
                Textupmoney("Enter your salary!           "),
                Positioned(
                  top: 200,
                  right: 20,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadiusDirectional.circular(25.0)),
                    child: TextFormField(
                        controller: SalaryContoralr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write your salary",
                            prefixIcon: Icon(
                              Icons.attach_money,
                              color: Colors.green,
                            )),
                        onFieldSubmitted: (String) =>
                            cuibt.changesallary(String)),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget EndWidget(size, sallaryAfter, context) {
    var cuibt = layoutCuibt.get(context);
    double precent = (cuibt.sallaryAfter / cuibt.sallary);
    return Stack(
      children: [
        Wallpaperstack(size),
        Positioned(
            right: 0,
            top: 230,
            width: 100,
            child: mybutton(
                Widget: Icon(CupertinoIcons.arrow_turn_down_right, size: 30.0),
                function: () {
                  setState(() {
                    cuibt.controlar.nextPage(
                        duration: Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic);
                  });
                })),
        precentge_circular(size, precent,),
        Positioned(
          bottom: 0,
          top: 300,
          left: 5,
          right: 0,
          child: SizedBox(
              width: 200,
              height: 500,
              child: ShowCatogeryByGridView(sallaryAfter, context)),
        )
      ],
    );
  }

  Widget Stack0salary(Size size, sallary, context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Wallpaperstack(size),
        Positioned(
          left: 5,
          top: 40,
          width: 100,
          child: mybutton(
              Widget: Icon(CupertinoIcons.arrow_turn_down_left, size: 30.0),
              function: () {
                setState(() {
                  layoutCuibt.get(context).controlar.previousPage(
                      duration: Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic);
                });
              }),
        ),
        Textupmoney("${layoutCuibt.get(context).sallaryAfter} LE"),
        Positioned(
          top: 100,
          bottom: 0,
          child: SizedBox(
              height: size.height * .75,
              width: size.width,
              child: ConditionalBuilder(
                condition: layoutCuibt.get(context).Budget.isNotEmpty,
                builder: (context) => ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    itemBuilder: (context, index) => Dismissible(
                      key: Key(layoutCuibt.get(context).Budget[index]["title"].toString()),
                      onDismissed: (direction) {
                        layoutCuibt.get(context).deletebudget(id: layoutCuibt.get(context).Budget[index]["id"]);
                        final snackBar = SnackBar(
                          content: Text(
                            "you deleted task number ${layoutCuibt.get(context).Budget[index]["id"]}",
                          ),
                          backgroundColor: Colors.pink,
                          duration: const Duration(milliseconds: 800),
                          elevation: 10.0,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: BudgetCont(
                          size, layoutCuibt.get(context).Budget[index]),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 1,
                        ),
                    itemCount: layoutCuibt.get(context).Budget.length),
                fallback: (context) => Padding(
                  padding: const EdgeInsets.only(left: 50, top: 200),
                  child: Text("you dont spent money yet ,good boy🥰",
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic)),
                ),
              )),
        )
      ],
    );
  }

  Padding BudgetCont(Size size, budget) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          //date of budget
          RotatedBox(
              quarterTurns: 1,
              child: Text(
                "${budget["data"]}",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              )),
          const SizedBox(
            width: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 100,
            width: size.width - 45,
            decoration: BoxDecoration(
                color: TaskLowColors,
                borderRadius: BorderRadiusDirectional.circular(50.0),
                boxShadow: [
                  BoxShadow(
                    color: TaskMedColors,
                    spreadRadius: .2,
                    offset: const Offset(3, 4),
                    blurRadius: 2,
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CatogryShow(budget),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: 170,
                        child: Text("${budget["title"]}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 21.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        height: 20,
                        width: 80,
                        child: Text("${budget["MONEY"]} LE",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 21.0, fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    SizedBox(height: 10),
                    Row(children: [
                      SizedBox(
                        width: 170,
                        child: Text(
                          "${budget["desc"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Text("${budget["MONEYAfter"]} LE",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700])),
                    ]),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Positioned Textupmoney(value) {
    return Positioned(
        top: 50,
        right: 20,
        child: Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30.0,
              fontStyle: FontStyle.italic,
              color: Colors.white),
        ));
  }

  Widget ShowCatogeryByGridView(sallary, context) {
    return GridView.count(
      controller: scrollControlar,
      addAutomaticKeepAlives: false,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(
          layoutCuibt.get(context).Users[0]["status"]=="Single"?SingleCategory.length:MarriedCategory.length, (index) => Catogry_Avatar(layoutCuibt.get(context).Users[0]["status"]=="Single"?SingleCategory[index]:MarriedCategory[index], context)),
    );
  }

  Column Catogry_Avatar(CategoryModel model, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.9),
              borderRadius: BorderRadiusDirectional.circular(30.0)),
          child: Column(
            children: [
              SizedBox(
                height: 3,
              ),
              InkWell(
                onTap: () {
                  layoutCuibt.get(context).Catogerye(model.Photo);
                  if (layoutCuibt.get(context).catagoryContoralr.text ==
                      "lib/Image/gain money.webp") {
                    setState(() {
                      gaining = true;
                    });
                  } else
                    setState(() {
                      gaining = false;
                    });
                  showbottomshet(context);
                },
                child: CircleAvatar(
                  radius: 53,
                  backgroundColor: Colors.redAccent.shade700,
                  foregroundColor: Colors.white,
                  child: CircleAvatar(
                    foregroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      model.Photo!,
                    ),
                    radius: 50.0,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              Text(
                model.title!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ],
    );
  }

  CircleAvatar CatogryShow(model) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.pinkAccent,
      foregroundColor: Colors.white,
      child: CircleAvatar(
        foregroundColor: Colors.white,
        backgroundImage: AssetImage(
          model["catogry"],
        ),
        radius: 35,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget precentge_circular(
    Size size,
    double precent,
  ) {
    return SizedBox(
      height: size.height * .3,
      width: double.infinity,
      child: CircularPercentIndicator(
        radius: 200,
        lineWidth: 10,
        linearGradient: LinearGradient(colors: [
          Colors.tealAccent,
          Colors.blue,
        ]),
        percent: precent > 1 ? 1 : precent,
        center: Text("${(precent * 100).ceil()}%",
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

  SizedBox Wallpaperstack(Size size) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Image.asset("lib/Image/businessWallpepar.jpg", fit: BoxFit.fill),
    );
  }

  Future showbottomshet(context) {
    return showFlexibleBottomSheet(
      isExpand: true,
      isDismissible: true,
      isCollapsible: true,
      isModal: true,
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 1,
      context: context,
      builder: buildBottomSheet,
      anchors: [0, 0.5, 1],
    );
  }

  Widget buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    var cuibt = layoutCuibt.get(context);
    var cat = "Gained money";
    if (cuibt.catagoryContoralr.text == "lib/Image/House illustration 1.png") {
      cat = "Home";
    }
    if (cuibt.catagoryContoralr.text == "lib/Image/Clothing-Logo-Vector.png") {
      cat = "Clothing";
    }
    if (cuibt.catagoryContoralr.text == "lib/Image/helthcare.jpg") {
      cat = "Health Care";
    }
    if (cuibt.catagoryContoralr.text ==
        "lib/Image/group-young-friends-having-fun-together-vector-26803087.jpg") {
      cat = "Fun";
    }
    if (cuibt.catagoryContoralr.text ==
        "lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg") {
      cat = "Travel";
    }
    if (cuibt.catagoryContoralr.text == "lib/Image/logo-template-44-.jpg") {
      cat = "Money Saving";
    }
    return SafeArea(
      child: Material(
        type: MaterialType.button,
        color: Colors.blueGrey.shade400,
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
                  topEnd: const Radius.circular(
                    25.0,
                  ),
                  topStart: Radius.circular(
                    25.0,
                  ))),
          child: gaining
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      " استلفت اي يسطا",
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.black),
                    ),
                    Mytextfield(
                        Controlr: cuibt.titleContoralr,
                        hint: "اخدتهم منين يسطا ؟؟"),
                    Mytextfield(
                        Controlr: cuibt.desContoralr,
                        hint: "وهتصرفهم في اي دي يسطا  ؟؟"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Mytextfield(
                          Controlr: cuibt.dataContoralr,
                          hint: "امتااااا ؟؟",
                          func: () => showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2022-11-07'),
                          ).then((value) => cuibt.budgetdate(value)),
                        )),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Mytextfield(
                          Enabled: false,
                          hint: "  $cat",
                        )),
                      ],
                    ),
                    Mytextfield(
                        Controlr: cuibt.moneyContoralr,
                        hint: "وعلي كدا اخدت كام بقي ؟؟"),
                    mybutton(
                        Widget: const Text("  قشطا"),
                        function: () {
                          cuibt
                              .insertbudget(
                                  title: cuibt.titleContoralr.text,
                                  desc: cuibt.desContoralr.text,
                                  MONEY:
                                      double.parse(cuibt.moneyContoralr.text),
                                  data: cuibt.dataContoralr.text,
                                  catogry: cuibt.catagoryContoralr.text)
                              .then((value) {
                            Navigator.pop(context);
                            setState(() {
                              gaining = false;
                            });
                          });
                        }),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "صرفت اي يسطا النهارده",
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.black),
                    ),
                    Mytextfield(
                        Controlr: cuibt.titleContoralr,
                        hint: "صرفت فلوسك في اي ؟؟"),
                    Mytextfield(
                        Controlr: cuibt.desContoralr,
                        hint: "ولي صرفت افلوس دي يسطا  ؟؟"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Mytextfield(
                          Controlr: cuibt.dataContoralr,
                          hint: "امتااااا ؟؟",
                          func: () => showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2022-11-07'),
                          ).then((value) => cuibt.budgetdate(value)),
                        )),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Mytextfield(
                          Enabled: false,
                          hint: "  $cat",
                        )),
                      ],
                    ),
                    Mytextfield(
                        Controlr: cuibt.moneyContoralr,
                        hint: "وعلي كدا صرفت كام بقي ؟؟"),
                    mybutton(
                        Widget: const Text("  قشطا"),
                        function: () {
                          if (double.parse(cuibt.moneyContoralr.text) >
                              cuibt.sallaryAfter) {
                            Navigator.pop(context);
                            showDialog(
                                useSafeArea: true,
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("Alert"),
                                      backgroundColor: Colors.white,
                                      content: const Text(
                                          "you cant do that bc you dont have enough money ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                                      actions: [
                                        Container(
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            color: TaskMedColors,
                                            borderRadius:
                                                BorderRadiusDirectional
                                                    .circular(25.0),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                cuibt.titleContoralr.clear();
                                                cuibt.desContoralr.clear();
                                                cuibt.moneyContoralr.clear();
                                                cuibt.dataContoralr.clear();
                                                cuibt.catagoryContoralr.clear();
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text("okay!",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                fontSize: 20,)),
                                            style: ButtonStyle(
                                              animationDuration:
                                                  Duration(milliseconds: 900),
                                            ),
                                          ),
                                        )
                                      ],
                                    ));
                          } else {
                            cuibt
                                .insertbudget(
                                    title: cuibt.titleContoralr.text,
                                    desc: cuibt.desContoralr.text,
                                    MONEY:
                                        double.parse(cuibt.moneyContoralr.text),
                                    data: cuibt.dataContoralr.text,
                                    catogry: cuibt.catagoryContoralr.text)
                                .then((value) {
                              Navigator.pop(context);
                            });
                          }
                        }),
                  ],
                ),
        ),
      ),
    );
  }
}

class CategoryModel {
  final String? Photo;
  final String? title;

  CategoryModel({required this.Photo, required this.title});
}

List<CategoryModel> SingleCategory = [
  CategoryModel(
    Photo: "lib/Image/House illustration 1.png",
    title: "Home",
  ),
  CategoryModel(
    Photo: "lib/Image/Clothing-Logo-Vector.png",
    title: "Clothes",
  ),
  CategoryModel(
    Photo: "lib/Image/helthcare.jpg",
    title: "Health care",
  ),
  CategoryModel(
    Photo:
        "lib/Image/group-young-friends-having-fun-together-vector-26803087.jpg",
    title: "Fun",
  ),
  CategoryModel(
    Photo:
        "lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg",
    title: "Travel",
  ),
  CategoryModel(
    Photo: "lib/Image/logo-template-44-.jpg",
    title: "Money saving",
  ),
  CategoryModel(
    Photo: "lib/Image/gain money.webp",
    title: "Gained money",
  ),
];
List<CategoryModel> MarriedCategory =[
  CategoryModel(
    Photo: "lib/Image/House illustration 1.png",
    title: "Home",
  ),
  CategoryModel(
    Photo: "lib/Image/Teaching.png",
    title: "teaching",
  ),
  CategoryModel(
    Photo: "lib/Image/food.png",
    title: "Food",
  ),
  CategoryModel(
    Photo: "lib/Image/Clothing-Logo-Vector.png",
    title: "Clothes",
  ),
  CategoryModel(
    Photo: "lib/Image/helthcare.jpg",
    title: "Health care",
  ),
  CategoryModel(
    Photo:
    "lib/Image/group-young-friends-having-fun-together-vector-26803087.jpg",
    title: "Fun",
  ),
  CategoryModel(
    Photo:
    "lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg",
    title: "Travel",
  ),
  CategoryModel(
    Photo: "lib/Image/logo-template-44-.jpg",
    title: "Money saving",
  ),
  CategoryModel(
    Photo: "lib/Image/gain money.webp",
    title: "Gained money",
  ),


];
