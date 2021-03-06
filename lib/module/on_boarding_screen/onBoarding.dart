
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/module/Login/Login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';

import '../../resorces/Resorces.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  bool islast = false;
  var controlar = PageController();
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildpageview(),
            Container(
              height: 100,
              color: ColorManger.maincolor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      if (controlar.page == 0) {
                        controlar.animateToPage(3,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      } else {
                        controlar.previousPage(
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.indigo,
                    ),
                  ),
                  const Spacer(),
                  SmoothPageIndicator(
                    controller: controlar,
                    effect: ExpandingDotsEffect(
                        activeDotColor: ColorManger.TaskLowColors,
                        dotColor: Colors.grey,
                        dotHeight: 20.0,
                        expansionFactor: 3.0,
                        dotWidth: 20.0,
                        radius: 30.0),
                    count: module.length,
                  ),
                  const Spacer(),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      if (controlar.page == module.length - 1) {
                        Nevigator(bool: false, page: Login(), context: context);
                      } else {
                        controlar.nextPage(
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Expanded buildpageview() {
    return Expanded(
      child: PageView.builder(
        itemBuilder: (context, index) => buildptage(module[index], context),
        onPageChanged: (index) {
          if (index == module.length - 1) {
            setState(() {
              sherdprefrence.setdate(key: "spalsh", value: true);
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
      page: "lib/Image/firstindex.png",
      title:
          "you must be bored from trying to organize your time,we will help you  ",
      body: "we will organize your tasks,business and time"),
  pagemodel(
      page: "lib/Image/scond2.png",
      title: "your time and business is in the Right hands ",
      body: ""),
  pagemodel(
      page: "lib/Image/3index.jpg", title: "we are here for you 24/7", body: "")
];

Widget buildptage(pagemodel module, context) {
  var size = MediaQuery.of(context).size;
  return Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Align(
        alignment: AlignmentDirectional.topCenter,
        child: SizedBox(
            height: size.height * .6,
            width: 400,
            child: Image.asset(
              filterQuality:FilterQuality.high,
              module.page,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,

            )),
      ),
      Container(
        height: size.height * .25,
        width: size.width,
        decoration: BoxDecoration(
            color: ColorManger.maincolor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(55.0),
              topRight: Radius.circular(55.0),
            )),
        child: Column(
          children: [
            const SizedBox(
              height: 55,
            ),
            SizedBox(
              width: 250,
              child: Text(module.body,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250,
              child: Text(
                module.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700]!,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
