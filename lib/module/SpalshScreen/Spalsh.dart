import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/module/Login/Login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';
class Spalsh extends StatefulWidget {
  @override
  State<Spalsh> createState() => _SpalshState();
}

class _SpalshState extends State<Spalsh> {
  @override
  bool islast = false;
  var controlar = PageController();
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          const SafeArea(
            child: SizedBox(),
          ),
          buildpageview(),
          Container(
            height: 100,
            color: maincolor,
            child: Row(
              children: [
                SmoothPageIndicator(
                  controller: controlar,
                  effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.deepPurpleAccent,
                      dotColor: Colors.grey,
                      dotHeight: 15.0,
                      expansionFactor: 2.0,
                      dotWidth: 15.0,
                      radius: 20.0),
                  count: module.length,
                ),
                const Spacer(),
                if(islast)
              FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    if(islast){
                    NEV(bool: false
                        ,page: Login(),context: context);
                    }else
                    controlar.nextPage(
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 10,)
              ],
            ),
          )
        ],
      ),
    );
  }

  Expanded buildpageview() {
    return Expanded(
      child: PageView.builder(
        itemBuilder: (context, index) =>
            buildptage(module[index], context),
        onPageChanged: (index) {
          if (index == module.length - 1) {
            setState(() {
              islast = true;
              sherdprefrence.setdate(key: "spalsh", value: true);
            });
          } else {
            setState(() {
              islast = false;
            });
          }
        },
        itemCount: module.length,
        controller: controlar,
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}

class pagemodel {
  final String page;
  final String title;
  final String body;

  pagemodel({
    required this.page,
    required this.title,
    required this.body,
  });
}

List<pagemodel> module = [
  pagemodel(
      page:
      "lib/Image/firstindex.jpg",
      title:
      "you must be bored from trying to organize your time,we will help you  ",
      body: "we will organize your tasks,business and time"),
  pagemodel(
      page:
      "lib/Image/scond2.png",
      title: "your time and business is in the Right hands ",
      body: ""),
  pagemodel(
      page:
      "lib/Image/3index.jpg",
      title: "we are here for you 24/7",
      body: "")
];

Widget buildptage(pagemodel module, context) {
  var size = MediaQuery.of(context).size;
  return Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Align(
        alignment: AlignmentDirectional.topCenter,
        child: Container(
            height: size.height*.5,
            width: 400,

            child: Image.asset(
              module.page,
              width: MediaQuery.of(context).size.width,
              height: 100,
              cacheHeight: 150,
              cacheWidth: 500,
              fit: BoxFit.fill,
            )),
      ),
      Container(
        height: (size.height*.5)-100,
        width: size.width,
        decoration: BoxDecoration(
            color: maincolor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(55.0),
              topRight:Radius.circular(55.0),
            )),
        child: Column(
          children: [
            const SizedBox(
              height: 55,
            ),
             SizedBox(
              width: 250,
              child: Text(module.body,
                  style: GoogleFonts.caveat(
                      color: Colors.black,
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900)
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 250,
              child: Text(
                module.title,
                style: GoogleFonts.caveat(
                    color: Colors.black,
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
