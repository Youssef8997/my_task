import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/Componads/my%20textformfild.dart';
import 'package:my_task/Componads/mybutton.dart';
import 'dart:ui';

import 'package:my_task/module/Login/Login.dart';
class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  var kayform = GlobalKey<FormState>();
  var email = TextEditingController();

  var pass = TextEditingController();
  var repass = TextEditingController();

  var name = TextEditingController();

  var phone = TextEditingController();

  bool isobsring = false;

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
appBar: appbar(),
  body:BodyLogin(size) ,
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
          color: HexColor("#dab7f0").withOpacity(.9),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), bottomRight: Radius.circular(35))),
      child: Form(
        key: kayform,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Mytextfield(
                Controlr: name,
                hint: "Enter you name,...",
                keybordtype: TextInputType.name,
                Prefix: Icon(Icons.drive_file_rename_outline, color: Colors.grey),
                validator: (value) {
                if (value!.isEmpty) {
    return "      Name must not be empty";
  }
                return null;
                 }
                ),
            Mytextfield(
                Controlr: email,
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
                Controlr: pass,
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
            Mytextfield(
                Controlr: repass,
                hint: "Enter you pass again,...",
                keybordtype: TextInputType.visiblePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "      pass must not be empty";
                  }else if (value!=pass.text)
                    {
                      return "      must be same to password ❌";
                    };
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
            Mytextfield(
                Controlr: phone,
                hint: "Enter you phone,...",
                keybordtype: TextInputType.visiblePassword,
                Prefix: Icon(Icons.phone, color: Colors.grey),
validator: (value){
                  if(value!.isEmpty) {
                    return "      phone must ne not empty ";
                  }
                  return null;
}
                ),
            mybutton(Widget: Text("Done",style:TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,)), function: () =>
            {
              if (kayform.currentState!.validate())
            {
            NEV(context: context, bool: true, page: Login())
       }, }
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
            "hallo,Signup now ",
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

  AppBar appbar() {
    return AppBar(
      backgroundColor: maincolor,
      title: Text("SignUp".toUpperCase()),
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
