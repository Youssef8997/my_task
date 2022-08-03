import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/Componads/my%20textformfild.dart';
import 'package:my_task/Componads/mybutton.dart';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';
import 'package:my_task/module/homelayout/layout.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';

import '../../resorces/Resorces.dart';
import '../signup/Signup.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  var emailcontrolar = TextEditingController();
  var passwordcontrolar = TextEditingController();
  var _ScrrollController = ScrollController();
  bool isobsring = true;
  var form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
        listener: (context, state) {},
        builder: (context, state) {
          var size = MediaQuery.of(context).size;
          var users = layoutCuibt.get(context).users;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                "login".toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              centerTitle: true,
              bottom:AppBar(
                centerTitle: false,
                backgroundColor: Colors.transparent,title:Text(
                "hallo again,...",
                style: GoogleFonts.ptSerif(
                  color: Colors.black,
                  fontSize: 35.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,

                ),
                textAlign: TextAlign.left,
              ), ) ,
            ),
            body: Container(
              height:size.height,
              width:size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:AssetImage("lib/Image/wallpaper.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child:SingleChildScrollView(
keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                controller: _ScrrollController,
                child: Column(
                  children: [
                    loginContenar(users,size),
                  ],
                ),
              ),
            ),
          );
        });
  }



  Container loginContenar(List users,Size size) {
    return Container(
      margin: EdgeInsets.only(top:size.height*.3),
      padding: const EdgeInsetsDirectional.all(15),
      width: 350,
      height: 350,
      decoration: BoxDecoration(
          color: ColorManger.maincolor,
          borderRadius: BorderRadius.circular(35.0)),
      child: Form(
        key: form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Mytextfield(
                Controlr: emailcontrolar,
                hint: "Enter you email,...",
                keybordtype: TextInputType.emailAddress,
                Prefix: const Icon(Icons.person_outline),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "      Email must not be empty";
                  }
                  return null;
                }),
            Mytextfield(
                Controlr: passwordcontrolar,
                hint: "Enter you pass,...",
                keybordtype: TextInputType.visiblePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "      Pass must not be empty";
                  }
                  return null;
                },
                Prefix: isobsring
                    ? const Icon(Icons.lock_open, color: Colors.grey)
                    : const Icon(Icons.lock_outline_rounded, color: Colors.grey),
                isobsr: isobsring,
                suffix: GestureDetector(
                  onTap: () {
                    setState(() {
                      isobsring = !isobsring;
                    });
                  },
                  child: isobsring
                      ? const Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.grey,
                        )
                      : const Icon(Icons.remove_red_eye, color: Colors.grey),
                )),
            mybutton(
                Widget: const Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )),
                function: () => {
                      if (form.currentState!.validate())
                        {
                          if (users.isNotEmpty)
                            {
                              if (emailcontrolar.text == users[0]["Email"])
                                {
                                  if (passwordcontrolar.text ==
                                      users[0]["pass"])
                                    {
                                    if (WidgetsBinding.instance.window.viewInsets.bottom > 0) {
                                    FocusManager.instance.primaryFocus?.unfocus()
                                    },
                                      Nevigator(
                                          context: context,
                                          bool: false,
                                          page: homelayout()),
                                      sherdprefrence.setdate(
                                          key: "login", value: true)
                                    }
                                  else
                                    MotionToast.error(
                                      position: MOTION_TOAST_POSITION.bottom,
                                      animationDuration:
                                          const Duration(seconds: 2),
                                      borderRadius: 25.0,
                                      dismissable: true,
                                      animationCurve: Curves.fastOutSlowIn,
                                      toastDuration: const Duration(seconds: 5),
                                      title: const Text("Wrong password"),
                                      layoutOrientation: ORIENTATION.rtl,
                                      animationType: ANIMATION.fromBottom,
                                      width: 350,
                                      description: const Text(
                                          "Please write your password correct"),
                                    ).show(context)
                                }
                              else
                                MotionToast.error(
                                  animationDuration: const Duration(seconds: 2),
                                  borderRadius: 25.0,
                                  dismissable: true,
                                  animationCurve: Curves.fastOutSlowIn,
                                  toastDuration: const Duration(seconds: 5),
                                  title: const Text("Wrong Email"),
                                  layoutOrientation: ORIENTATION.rtl,
                                  animationType: ANIMATION.fromRight,
                                  width: 350,
                                  description: const Text(
                                      "Please write your Email correct"),
                                ).show(context)
                            }
                          else
                            {
                              MotionToast.error(
                                animationDuration: const Duration(seconds: 2),
                                borderRadius: 25.0,
                                dismissable: true,
                                animationCurve: Curves.fastOutSlowIn,
                                toastDuration: const Duration(seconds: 5),
                                title: const Text("You don't have Email "),
                                layoutOrientation: ORIENTATION.rtl,
                                animationType: ANIMATION.fromRight,
                                width: 350,
                                description: const Text(
                                    "Please signup to be can use the app "),
                              ).show(context)
                            }
                        },
                    }),
            mybutton(
                Widget: const Text("Signup",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )),
                function: () =>
                    Nevigator(context: context, bool: true, page: Signup()))
          ],
        ),
      ),
    );
  }



}
