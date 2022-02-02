import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MoneyOraganize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double precent = .3;

    return SafeArea(
      top: true,
      minimum: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          precentge_circular(size, precent),
         Expanded(
           child: GridView.count(
             crossAxisCount: 2,
             children: List.generate(Category.length, (index) =>Catogry_Avatar(Category[index])),
             scrollDirection:Axis.horizontal,
             physics: BouncingScrollPhysics( ),





           ),
         )

        ],
      ),
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  SizedBox precentge_circular(Size size, double precent) {
    return SizedBox(
      height: size.height * .3,
      width: double.infinity,
      child: CircularPercentIndicator(
        radius: 200,
        lineWidth: 10,
        percent: precent,
        center: Text("${(precent * 100).ceil()}%"),
        progressColor: HexColor("#ED9797"),
arcBackgroundColor:Colors.blueGrey ,
        animation: true,
        addAutomaticKeepAlive: true,
        animationDuration: 1200,
        animateFromLastPercent: false,
        curve: Curves.easeInCubic,
        arcType: ArcType.FULL,
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
      Photo: "https://static.mbshosting.co.uk/eis-bw/media/New%20brand%20icons/PNGs/House%20illustration%201.png",
    title: "home"
,  ),
  CategoryModel(
      Photo: "https://www.logopik.com/wp-content/uploads/edd/2018/07/Clothing-Logo-Vector.png",
    title: "Clothes"
,  ),
  CategoryModel(
      Photo: "https://www.pinclipart.com/picdir/middle/336-3368754_healthcare-it-solution-provider-health-insurance-logo-png.png",
    title: "Health care"
,  ),
  CategoryModel(
      Photo: "https://cdn3.vectorstock.com/i/1000x1000/30/87/group-young-friends-having-fun-together-vector-26803087.jpg",
    title: "fun"
,  ),
  CategoryModel(
      Photo: "https://thumbs.dreamstime.com/b/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg",
    title: "Travel"
,  ),
  CategoryModel(
      Photo: "https://thumbs.dreamstime.com/b/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg",
    title: "Travel"
,  ),
  CategoryModel(
      Photo: "https://thumbs.dreamstime.com/b/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg",
    title: "Travel"
,  ),
];
