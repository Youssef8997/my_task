import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MoneyOraganize extends StatefulWidget {
  @override
  State<MoneyOraganize> createState() => _MoneyOraganizeState();
}
var controlar =PageController(
  initialPage: 0
);
class _MoneyOraganizeState extends State<MoneyOraganize> {
  @override
  var SalaryContoralr = TextEditingController();

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double sallary = sherdprefrence.getdate(key: "salary") != null
        ? sherdprefrence.getdate(key: "salary")
        : 0;
    double sallaryAfter = sallary;
    double precent = (sallaryAfter / sallary);
    return SafeArea(
      child: PageView(
        controller: controlar,
scrollDirection: Axis.horizontal,
      children: [
        EndWidget(size, precent,sallaryAfter),
        Stack0salary(size,sallary)
      ],

      ),
    );
  }


  Widget EndWidget(size, precent,sallaryAfter) {
    return Stack(
      children: [
        Wallpaperstack(size),
        precentge_circular(size, precent,),
        Positioned(
          bottom: 0,
          top: 300,
          left: 0,
          right: 0,
          child: SizedBox(
              width: double.maxFinite,
              height: 500,
              child: CirculeCatogery()),
        )
      ],
    );
  }

  Widget Stack0salary(Size size,sallary) {
    return ConditionalBuilder(
        condition:sallary!=0 ,
        builder: (context){
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Wallpaperstack(size),
              Transactions()
            ],
          );

        },
        fallback:(context){
          return Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Wallpaperstack(size),
            Textupmoney(),
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
                  onFieldSubmitted: (String) {
                    setState(() {
                      sherdprefrence.setdate(
                          key: "salary", value: double.parse(String));
                    });

                  },
                ),
              ),
            )
          ],
        );}
    );


  }

  Container Transactions() {
    return Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                color: Colors.white,
borderRadius: BorderRadiusDirectional.circular(25)

              ),
               child: Column(
                 children: [
                   Catogry_Avatar(Category[0]),
                   SizedBox(height:10,),
                   Text(
                       "200LE",
                     style: TextStyle(
                       fontSize: 15,
                       fontWeight: FontWeight.bold
                     ),
                   ),
                 ],
               ),
            );
  }

  Positioned Textupmoney() {
    return const Positioned(
        top: 80,
        child: Text(
          "Please Enter your salary",
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              color: Colors.white),
        ));
  }

  Widget CirculeCatogery() {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(
          Category.length, (index) => Catogry_Avatar(Category[index])),
    );
  }

  Column Catogry_Avatar(CategoryModel model) {
    return Column(
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

      ],
    );
  }

  Widget precentge_circular(Size size, double precent,) {
    return SizedBox(
      height: size.height * .3,
      width: double.infinity,
      child: CircularPercentIndicator(
        radius: 200,
        lineWidth: 10,
        percent: precent,
        center: Text("${(precent * 100).ceil()}%",
            style: const TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20
            )),
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
      height: size.height - 150,
      width: size.width,
      child: Image.network(
          "https://i.pinimg.com/564x/50/d3/94/50d3946207b67b305a24886f1d593c50.jpg",
          fit: BoxFit.fill),
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
    Photo:
        "lib/Image/House illustration 1.png",
    title: "home",
  ),
  CategoryModel(
    Photo:
        "lib/Image/Clothing-Logo-Vector.png",
    title: "Clothes",
  ),
  CategoryModel(
    Photo:
        "lib/Image/helthcare.jpg",
    title: "Health care",
  ),
  CategoryModel(
    Photo:"lib/Image/group-young-friends-having-fun-together-vector-26803087.jpg",
    title: "fun",
  ),
  CategoryModel(
    Photo:"lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg",
    title: "Travel",
  ),
  CategoryModel(
    Photo:"lib/Image/logo-template-44-.jpg",
    title: "money saving",
  ),
];
