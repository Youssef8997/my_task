
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import '../../Translition/locale_kays.g.dart';
import '../../resorces/Resorces.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
class analytics extends StatefulWidget {
  @override
  State<analytics> createState() => _analyticsState();
}

class _analyticsState extends State<analytics> {
  var _date = DateFormat.yMMMd().format(DateTime.now());
  var myBanner ;
@override
  void initState() {
  BannerAd(
  adUnitId: 'ca-app-pub-7041190612164401/3454936100',
  size: AdSize.fullBanner,
  request: AdRequest(),
  listener: BannerAdListener(
  onAdFailedToLoad:(Ad ad, LoadAdError error) {
  print(error);
  },
  onAdLoaded: (Ad ad) {
    setState(() {
      myBanner = ad;
    });
  }
  ),
  ).load();
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt,mytasks>
      (
        listener: (context,state){},
        builder: (context,state){
          var size=MediaQuery.of(context).size;
          var cuibt=layoutCuibt.get(context);
          return Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:AssetImage("lib/Image/businessWallpepar.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child:SafeArea(
              child: Column(
                children: [
                  if(myBanner!=null)
                  Container(
                      width: myBanner.size.width.toDouble(),
                      height: myBanner.size.height.toDouble(),
                      child: AdWidget(
                        ad: myBanner,
                      )),
                  dateCalendar(context,size),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Shimmer.fromColors(
                        child: Text(
                         " ${cuibt.salaryAfter} LE",
                          style:const  TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 30.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                          textAlign: TextAlign.right,
                        ),
                        baseColor: Colors.white,
                        highlightColor: Colors.grey[700]!
                      ),
                    ),
                  ),
                  showMoney(cuibt,context,size),



                ],
              ),
            ),
          );
        }
    );
  }

    Widget showMoney(layoutCuibt cuibt, context,Size size) {
    return Expanded(
        child: ConditionalBuilder(
          condition: cuibt.budget.isNotEmpty,
          builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              itemBuilder: (context, index) => Dismissible(
                key: Key(cuibt.budget[index]["title"].toString()),
                onDismissed: (direction) {
                  cuibt.deletebudget(id: cuibt.budget[index]["id"],index: index);
                  final snackBar = SnackBar(
                    content: Text(
                      "you deleted task number ${cuibt.budget[index]["id"]}",
                    ),
                    backgroundColor: Colors.pink,
                    duration: const Duration(milliseconds: 800),
                    elevation: 10.0,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: moneyModel(
                    size, cuibt.budget[index]),
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: 1,
              ),
              itemCount: cuibt.budget.length),
          fallback: (context) =>  Center(
            child: Text(LocaleKeys.MoneyNotFound.tr(),
                style:const TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,

            ),
          ),
        ));
  }
  SizedBox dateCalendar(BuildContext context, Size size) {
    return SizedBox(
      height: 90,
      width: size.width,
      child: DatePicker(
          DateTime(DateTime.now().year, DateTime.now().month-1, DateTime.now().day+15),
          initialSelectedDate: DateTime.now(),
          daysCount: 18,
          selectionColor: Colors.black,
          selectedTextColor: Colors.white,
          locale:context.locale.languageCode,
          onDateChange: (value) {
            setState(() {
              _date = DateFormat.yMMMd("en").format(value);
              print(_date);
              layoutCuibt.get(context).onDate = _date;
              layoutCuibt.get(context).insertBudgetIntoVar(datab: layoutCuibt.get(context).datab);

            });
          }),
    );
  }


  Padding moneyModel(Size size, budget) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          //date of budget
          RotatedBox(
              quarterTurns: 1,
              child: Text(
                "${budget["data"]}",
                style: const TextStyle(
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
                color: ColorManger.TaskLowColors,
                borderRadius: BorderRadiusDirectional.circular(50.0),
                boxShadow: [
                  BoxShadow(
                    color: ColorManger.TaskMedColors,
                    spreadRadius: .2,
                    offset: const Offset(3, 4),
                    blurRadius: 2,
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              CircleAvatar(
              radius: 40,
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              child: CircleAvatar(
                foregroundColor: Colors.white,
                backgroundImage: AssetImage(
                  budget["catogry"],
                ),
                radius: 35,
                backgroundColor: Colors.white,
              ),
            ),
                const SizedBox(
                  width: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 170,
                      child: Text("${budget["title"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 21.0, fontWeight: FontWeight.bold)),
                    ),
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        height: 20,
                        width: 80,
                        child: Text("${budget["MONEY"]} LE",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 21.0, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
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

}


