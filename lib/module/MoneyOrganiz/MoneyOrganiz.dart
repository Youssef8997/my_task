import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MoneyOraganize extends StatelessWidget {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sallary != 0)
            EndWidget(size, precent,sallaryAfter)
          else Stack0salary(size),
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
  Widget Stack0salary(Size size) {
    return SingleChildScrollView(
      child: Stack(
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
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write your salary",
                    prefixIcon: Icon(
                      Icons.money,
                      color: Colors.green,
                    )),
                onFieldSubmitted: (String) {
                  sherdprefrence.setdate(
                      key: "salary", value: double.parse(String));
                },
              ),
            ),
          )
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
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              model.Photo!,
            ),
            radius: 50.0,
            backgroundColor: Colors.white,
          ),
        ),
        Text(
          model.title!,
          style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.pinkAccent),
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
            style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold)),
        progressColor: HexColor("#ED9797"),
        arcBackgroundColor: Colors.blueGrey,
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
          "https://i.pinimg.com/564x/f9/03/8b/f9038bf30b6832c298cf495a0bdeba68.jpg",
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
        "https://static.mbshosting.co.uk/eis-bw/media/New%20brand%20icons/PNGs/House%20illustration%201.png",
    title: "home",
  ),
  CategoryModel(
    Photo:
        "https://www.logopik.com/wp-content/uploads/edd/2018/07/Clothing-Logo-Vector.png",
    title: "Clothes",
  ),
  CategoryModel(
    Photo:
        "https://www.pinclipart.com/picdir/middle/336-3368754_healthcare-it-solution-provider-health-insurance-logo-png.png",
    title: "Health care",
  ),
  CategoryModel(
    Photo:
        "https://cdn3.vectorstock.com/i/1000x1000/30/87/group-young-friends-having-fun-together-vector-26803087.jpg",
    title: "fun",
  ),
  CategoryModel(
    Photo:
        "https://thumbs.dreamstime.com/b/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg",
    title: "Travel",
  ),
  CategoryModel(
    Photo:
        "https://images.creativemarket.com/0.1.0/ps/6709868/1820/1214/m1/fpnw/wm0/logo-template-44-.jpg?1563600810&s=be7f251c961b5b5a02423aa4acd264f0",
    title: "money saving",
  ),
];
