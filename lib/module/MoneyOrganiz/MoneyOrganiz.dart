import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_task/Componads/mybutton.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:my_task/resorces/Photo_manger.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../Componads/my_text_form.dart';
import '../../Model/model.dart';
import '../../Translition/locale_kays.g.dart';
import '../../resorces/colorsManger.dart';

class moneyOraganize extends StatefulWidget {
  const moneyOraganize({super.key});

  @override
  State<moneyOraganize> createState() => _moneyOraganizeState();
}

class _moneyOraganizeState extends State<moneyOraganize> {
  var salaryController = TextEditingController();
  var scrollController = ScrollController();
  var gaining = false;
  var myBanner;

  @override
  void initState() {
    layoutCuibt.get(context).insertBudgetIntoVar(
        datab: layoutCuibt.get(context).datab, context: context);
    BannerAd(
      adUnitId: 'ca-app-pub-7041190612164401/7394181118',
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
        listener: (context, state) {},
        builder: (context, state) {
          List<CategoryModel> category = [
            CategoryModel(
              photo: PhotoManger.houseLogo,
              title: LocaleKeys.Home.tr(),
            ),
            CategoryModel(
              photo: PhotoManger.teachingLogo,
              title: LocaleKeys.Teaching.tr(),
            ),
            CategoryModel(
              photo: PhotoManger.foodLogo,
              title: LocaleKeys.food.tr(),
            ),
            CategoryModel(
              photo: PhotoManger.clothesLogo,
              title: LocaleKeys.clothes.tr(),
            ),
            CategoryModel(
              photo: PhotoManger.healthCareLogo,
              title: LocaleKeys.Healthcare.tr(),
            ),
            CategoryModel(
              photo: PhotoManger.funLogo,
              title: LocaleKeys.Fun.tr(),
            ),
            CategoryModel(
              photo: PhotoManger.travelLogo,
              title: LocaleKeys.Travel.tr(),
            ),
            CategoryModel(
              photo: PhotoManger.savingMoneyLogo,
              title: LocaleKeys.MoneySaving.tr(),
            ),
            CategoryModel(
              photo: PhotoManger.gainMoneyLogo,
              title: LocaleKeys.GainedMoney.tr(),
            ),
          ];
          var cuibt = layoutCuibt.get(context);
          var size = MediaQuery.of(context).size;
          double precent = (cuibt.salaryAfter / cuibt.salary);
          return ConditionalBuilder(
            condition: cuibt.salary != 0,
            builder: (context) => SafeArea(
              top: true,
              child: Container(
                padding: EdgeInsets.zero,
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(

                  image: DecorationImage(
                    image: AssetImage(PhotoManger.balanceWallpaper),
                    fit: BoxFit.fill,
                    colorFilter:
                        ColorFilter.mode(Colors.black12, BlendMode.darken),
                  ),
                ),
                child: Column(
                  children: [
                 if (myBanner != null)
                      SizedBox(
                          width: size.width,
                          height: size.height * .06,
                          child: AdWidget(
                            ad: myBanner,
                          )),
                    Expanded(
                      flex: 1,
                        child: precentgeCircular(
                      size,
                      precent,
                    )),
                    Expanded(
                      flex: 2,
                        child: showCategoryByGridView(
                            context, cuibt, category, size)),
                  ],
                ),
              ),
            ),
            fallback: (context) => Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(PhotoManger.balanceWallpaper),
                  fit: BoxFit.fill,
                  colorFilter:
                      ColorFilter.mode(Colors.black12, BlendMode.darken),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (myBanner != null)
                      SizedBox(
                        height: size.height * 0.07,
                        width: size.width,
                        child: AdWidget(ad: myBanner),
                      ),
                    SizedBox(
                      height: size.height * 0.2,
                    ),
                    Text(
                      LocaleKeys.EnterSalary.tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: size.height * 0.07,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadiusDirectional.circular(25.0)),
                        child: TextFormField(
                            controller: salaryController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: LocaleKeys.SalaryHint.tr(),
                                prefixIcon: const Icon(
                                  Icons.attach_money,
                                  color: Colors.green,
                                )),
                            onFieldSubmitted: (salary) =>
                                cuibt.setSalary(salary)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget showCategoryByGridView(
      context, layoutCuibt cuibt, Category, Size size) {
    return GridView.count(
      childAspectRatio: 1/1.5,
padding:EdgeInsets.zero    ,
crossAxisSpacing: 1,
      controller: scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      scrollDirection: Axis.horizontal,
      crossAxisCount: 3,
      children: List.generate(Category.length,
          (index) => categoryAvatar(Category[index], context, cuibt, size)),
    );
  }

  Column categoryAvatar(
      CategoryModel model, context, layoutCuibt cuibt, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            layoutCuibt.get(context).catagoryController.text = model.photo!;
            // to make differance between if the user gain or lost money
            if (layoutCuibt.get(context).catagoryController.text ==
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
            width: size.width * 0.33,
            height: size.height * 0.17,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.8),
                borderRadius: BorderRadiusDirectional.circular(30.0)),
            child: Column(
              children: [
                const SizedBox(
                  height: 3,
                ),
                CircleAvatar(
                  radius: size.height * 0.068,
                  backgroundColor: Colors.redAccent.shade700,
                  foregroundColor: Colors.white,
                  child: CircleAvatar(
                    foregroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      model.photo!,
                    ),
                    radius: size.height * 0.064,
                    backgroundColor: Colors.white,
                  ),
                ),
                Text(
                  model.title!,
                  style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: size.height*.02,color: Colors.black),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget precentgeCircular(
    Size size,
    double percent,
  ) {
    return CircularPercentIndicator(

      radius: size.height * 0.26,
      lineWidth: size.width * 0.03,
      linearGradient: LinearGradient(colors: [
        Colors.red,
        Colors.teal[400]!,
        Colors.green,
      ]),
      percent: percent > 1 ? 1 : percent,
      center: Text("${(percent * 100).ceil()}%",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.05)),
      arcBackgroundColor: Colors.white54,
      animation: true,
      addAutomaticKeepAlive: true,
      animationDuration: 1200,
      animateFromLastPercent: false,
      curve: Curves.easeInCubic,
      arcType: ArcType.FULL,
    );
  }

  Future showBottomSheet(context, layoutCuibt cuibt) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final String category =
            cuibt.handleCategory(cuibt.catagoryController.text);
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
            child: gaining
                ? Form(
                    key: cuibt.dialogFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          LocaleKeys.SheetTitle2.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.black),
                        ),
                        myTextForm(
                            controller: cuibt.titleController,
                            hint: LocaleKeys.ReasonGainMoney.tr(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a title";
                              }
                              return null;
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: myTextForm(
                                    keyboardType: TextInputType.none,
                                    controller: cuibt.dataController,
                                    hint: LocaleKeys.when.tr(),
                                    onTap: () => showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month - 2,
                                              DateTime.now().day),
                                          lastDate: DateTime.now(),
                                        ).then((value) {
                                          value ??= DateTime.now();
                                          cuibt.budgetDate(value);
                                        }),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter a Time";
                                      }
                                      return null;
                                    })),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: myTextForm(
                              enabled: false,
                              hint: category,
                            )),
                          ],
                        ),
                        myTextForm(
                            keyboardType: TextInputType.number,
                            controller: cuibt.moneyController,
                            hint: LocaleKeys.HowMuchGain.tr(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a money";
                              }
                              return null;
                            }),
                        myButton(
                            text: Text(LocaleKeys.okay.tr()),
                            function: () {
                              if (cuibt.dialogFormKey.currentState!
                                  .validate()) {
                                cuibt
                                    .insertBudget(
                                        title: cuibt.titleController.text,
                                        money: double.tryParse(
                                                cuibt.moneyController.text) ??
                                            0.0,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          category == LocaleKeys.MoneySaving.tr()
                              ? LocaleKeys.SavingTitle.tr()
                              : LocaleKeys.SheetTitle.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.black),
                        ),
                        myTextForm(
                            controller: cuibt.titleController,
                            hint: category == LocaleKeys.MoneySaving.tr()
                                ? LocaleKeys.ReasonSaving.tr()
                                : LocaleKeys.ReasonHint.tr(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a title";
                              }
                              return null;
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: myTextForm(
                                    keyboardType: TextInputType.none,
                                    controller: cuibt.dataController,
                                    hint: LocaleKeys.when.tr(),
                                    onTap: () => showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month - 2,
                                              DateTime.now().day),
                                          lastDate: DateTime.now(),
                                        ).then((value) {
                                          value ??= DateTime.now();
                                          cuibt.budgetDate(value);
                                        }),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter a Time";
                                      }
                                      return null;
                                    })),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: myTextForm(
                              enabled: false,
                              hint: category,
                            )),
                          ],
                        ),
                        myTextForm(
                            keyboardType: TextInputType.number,
                            controller: cuibt.moneyController,
                            hint: category == LocaleKeys.MoneySaving.tr()
                                ? LocaleKeys.moneySaving.tr()
                                : LocaleKeys.HowMuch.tr(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a money";
                              }
                              return null;
                            }),
                        myButton(
                            text: Text(LocaleKeys.okay.tr()),
                            function: () {
                              if (cuibt.dialogFormKey.currentState!
                                  .validate()) {
                                if (double.parse(cuibt.moneyController.text) >
                                    cuibt.salaryAfter) {
                                  Navigator.pop(context);
                                  showDialog(
                                      useSafeArea: true,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text("Alert"),
                                            backgroundColor: Colors.white,
                                            content: const Text(
                                                "you cant do that bc you don't have enough money ",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            actions: [
                                              Container(
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                  color:
                                                      ColorManger.TaskMedColors,
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .circular(25.0),
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      cuibt.titleController
                                                          .clear();
                                                      cuibt.descController
                                                          .clear();
                                                      cuibt.moneyController
                                                          .clear();
                                                      cuibt.dataController
                                                          .clear();
                                                      cuibt.catagoryController
                                                          .clear();
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  style: const ButtonStyle(
                                                    animationDuration: Duration(
                                                        milliseconds: 900),
                                                  ),
                                                  child: const Text("okay!",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                      )),
                                                ),
                                              )
                                            ],
                                          ));
                                } else {
                                  cuibt
                                      .insertBudget(
                                          title: cuibt.titleController.text,
                                          money: double.tryParse(
                                                  cuibt.moneyController.text) ??
                                              0.0,
                                          data: cuibt.dataController.text,
                                          category:
                                              cuibt.catagoryController.text)
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
        );
      },
    );
  }
}
