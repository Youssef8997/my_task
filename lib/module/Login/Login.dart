import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:my_task/Componads/Com.dart';
import 'package:my_task/Componads/my%20textformfild.dart';
import 'package:my_task/Componads/mybutton.dart';
import 'package:my_task/module/Login/signup/Signup.dart';
import 'package:my_task/module/homelayout/layout.dart';


class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  var emailcontrolar = TextEditingController();

  var passwordcontrolar = TextEditingController();
  bool isobsring = false;
  var form = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appbar(),
      body: BodyLogin(size),
    );
  }

  SingleChildScrollView BodyLogin(Size size) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Wallpaperstack(size),
              Textupcontenar(),
              loginContenar()
            ],
          ),
        ],
      ),
    );
  }

  Container loginContenar() {
    return Container(
      padding: const EdgeInsetsDirectional.all(15),
      width: 350,
      height: 400,
      decoration: BoxDecoration(
          color: maincolor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), bottomRight: Radius.circular(35))),
      child: Form(
        key:form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Mytextfield(
                Controlr: emailcontrolar,
                hint: "Enter you email,...",
                keybordtype: TextInputType.emailAddress,
                Prefix: Icon(Icons.person_outline),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "      Email must not be empty";
                  }
                  return null;
                }
            ),
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
                    ? Icon(Icons.lock_open, color: Colors.grey)
                    : Icon(Icons.lock_outline_rounded, color: Colors.grey),
                isobsr: isobsring,
                suffix: GestureDetector(
                  onTap: () {
                    setState(() {
                      isobsring = !isobsring;
                    });
                  },
                  child: isobsring
                      ? Icon(
                    Icons.visibility_off_outlined,
                    color: Colors.grey,
                  )
                      : Icon(Icons.remove_red_eye, color: Colors.grey),
                )),
            mybutton(Widget: Text("Login",style:TextStyle(
              color: Colors.white,
              fontSize: 18.0,)), function: () => {
              if (form.currentState!.validate())
                {
                  NEV(context: context, bool: false, page: homelayout())
                }, }),
            mybutton(Widget: Text("Signup",style:TextStyle(
              color: Colors.white,
              fontSize: 18.0,)), function: () =>NEV(context: context, bool: true, page: Signup())
               )
          ],
        ),
      ),
    );
  }

  Positioned Textupcontenar() {
    return Positioned(
      top: 60,
      left: 10,
      child: Row(
        children: [
          Text(
            "hallo again,...",
            style: GoogleFonts.ptSerif(
                color: Colors.black,
                fontSize: 30.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
  SizedBox Wallpaperstack(Size size) {
    return SizedBox(
      height: size.height - 106,
      width: size.width,
      child: Image.asset(
          "lib/Image/wallpaper.jpg",
          fit: BoxFit.fill),
    );
  }
  AppBar appbar() {
    return AppBar(
      backgroundColor: maincolor,
      title: Text("login".toUpperCase()),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("lib/Image/man avatar.jpg"),
          ),
        ),
      ],
    );
  }
}
