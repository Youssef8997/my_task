
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/Componads/my%20textformfild.dart';
import 'package:my_task/Componads/mybutton.dart';
import 'package:my_task/module/homelayout/layoutCuibt/cuibt.dart';
import 'package:my_task/module/homelayout/layoutCuibt/loginstates.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
class MoneyOraganize extends StatelessWidget {
  @override
  var SalaryContoralr = TextEditingController();

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
                controller: cuibt.controlar,
                scrollDirection: Axis.horizontal,
                children: [
                  EndWidget(size, cuibt.sallaryAfter, context),
                  Stack0salary(size, cuibt.sallary,context)
                ],
              ),
            ),
            fallback: (context) => Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Wallpaperstack(size),
                Textupmoney("Enter your salary..."),
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
        precentge_circular(
          size,
          precent,
        ),
        Positioned(
          bottom: 0,
          top: 300,
          left: 0,
          right: 0,
          child: SizedBox(
              width: 200,
              height: 500,
              child: CirculeCatogery(sallaryAfter, context)),
        )
      ],
    );
  }

  Widget Stack0salary(Size size, sallary,context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Wallpaperstack(size),
        Padding(
          padding: const EdgeInsets.only(left: 20,top: 30),
          child: Textupmoney("hello again , ......!"),
        ),
        Positioned (
          top: 100,
          bottom: 0,
          child: SizedBox(
            height:size.height*.75,
            width: size.width,
            child: Expanded(
              child: ConditionalBuilder(
                condition:layoutCuibt.get(context).Budget.isNotEmpty ,
                builder: (context)=>ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index)=>BudgetCont(size,layoutCuibt.get(context).Budget[index]),
                    separatorBuilder: (context,index)=>const SizedBox(height: 1,),
                    itemCount: layoutCuibt.get(context).Budget.length),
               fallback: (context)=>Padding(
                 padding: const EdgeInsets.only(left: 50),
                 child: Text("you dont spent money yet ,good boy🥰",style: TextStyle(
                   fontSize: 30.0,
                   color: Colors.white,
                   fontWeight: FontWeight.w900,
                   fontStyle: FontStyle.italic
                 )),
               ),
              ),
            )
          ),
        )
      ],
    );
  }

  Padding BudgetCont(Size size,budget) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
             RotatedBox(
                quarterTurns: 1,
                child:  Text(
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CatogryShow(budget),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       SizedBox(
                        width: 180,
                        child: Text(
                            "${budget["title"]}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 21.0, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 180,
                        child: Text(
                          "${budget["desc"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(
                            color: Colors.grey[800],
                            fontSize: 17,
                          ),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text("${budget["MONEY"]} LE",
                          style: const TextStyle(
                              fontSize: 21.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("${budget["MONEYAfter"]} LE",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700])),
                    ],
                  ),
                  const SizedBox(width: 10,)
                ],
              ),
            ),
          ],
        ),
      );
  }

  Positioned Textupmoney(value) {
    return  Positioned(
        top: 80,
        child: Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30.0,
              fontStyle: FontStyle.italic,
              color: Colors.white),
        ));
  }

  Widget CirculeCatogery(sallary, context) {
    return GridView.count(
      addAutomaticKeepAlives: false,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(
          Category.length,
          (index) => InkWell(
                onTap: () {
                  layoutCuibt.get(context).Catogerye(Category[index].Photo!);
                  showbottomshet(context);
                },
                child: Catogry_Avatar(Category[index]),
              )),
    );
  }

  ClipRect Catogry_Avatar(CategoryModel model) {
    return ClipRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          CircleAvatar(
            radius: 51,
            backgroundColor: Colors.pinkAccent,
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
          Text(
            model.title!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
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
        percent: precent,
        center: Text("${(precent * 100).ceil()}%",
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        progressColor: Colors.blueGrey,
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
    var cat = "cat";
    if (cuibt.catagoryContoralr.text == "lib/Image/House illustration 1.png") {
      cat = "home";
    }
    if (cuibt.catagoryContoralr.text == "lib/Image/Clothing-Logo-Vector.png") {
      cat = "Clothing";
    }
    if (cuibt.catagoryContoralr.text == "lib/Image/helthcare.jpg") {
      cat = "Health Care";
    }
    if (cuibt.catagoryContoralr.text ==
        "lib/Image/group-young-friends-having-fun-together-vector-26803087.jpg") {
      cat = "fun";
    }
    if (cuibt.catagoryContoralr.text ==
        "lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg") {
      cat = "travel";
    }
    if (cuibt.catagoryContoralr.text == "lib/Image/logo-template-44-.jpg") {
      cat = "Money Saving";
    }
    return SafeArea(
      child: Material(
        color: Colors.teal.shade200,
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
          child: Column(
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
                  Controlr: cuibt.titleContoralr, hint: "صرفت فلوسك في اي ؟؟"),
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
                    cuibt
                        .insertbudget(
                            title: cuibt.titleContoralr.text,
                            desc: cuibt.desContoralr.text,
                            MONEY: double.parse(cuibt.moneyContoralr.text),
                            data: cuibt.dataContoralr.text,
                            catogry: cuibt.catagoryContoralr.text)
                        .then((value) {
                      Navigator.pop(context);
                    });
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

List<CategoryModel> Category = [
  CategoryModel(
    Photo: "lib/Image/House illustration 1.png",
    title: "home",
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
    title: "fun",
  ),
  CategoryModel(
    Photo:
        "lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg",
    title: "Travel",
  ),
  CategoryModel(
    Photo: "lib/Image/logo-template-44-.jpg",
    title: "money saving",
  ),
];
