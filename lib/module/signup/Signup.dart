import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/Componads/my%20textformfild.dart';
import 'package:my_task/Componads/mybutton.dart';
import 'dart:ui';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';
import 'package:my_task/module/homelayout/layout.dart';
import 'package:my_task/module/homelayout/layoutCuibt/cuibt.dart';
import 'package:my_task/module/homelayout/layoutCuibt/loginstates.dart';

import '../../../resorces/Resorces.dart';

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
  String? StatusUser;
  var phone = TextEditingController();

  bool isobsring = true;
  bool vis = true;
  Color? ontap = Colors.white.withOpacity(.9);
  var _ScrrollController = ScrollController();
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<layoutCuibt, mytasks>(
        listener: (context, state) {},
        builder: (context, state) =>
            Scaffold(
              extendBodyBehindAppBar:true,
                appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                "Sign Up".toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              centerTitle: true,
              bottom:AppBar(
                leading: const SizedBox(width: 0),
                centerTitle: false,
                backgroundColor: Colors.transparent,title:Text(
                "Hi,Sign up now ,...",
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
                        SignupContenar(size: size),
                        const SizedBox(height: 10,),
                        SizedBox(
                          height: 200,
                          width: size.width,
                          child: ListView.separated(
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    StatusUser = Status[index].title;
                                    if (ontap == Colors.teal) {
                                      return null;
                                    } else {
                                      setState(() {
                                        ontap = Colors.teal;
                                        Status.forEach((element) {
                                          if (element != Status[index])
                                            element.ontap = false;
                                        });
                                      });
                                    }
                                  },
                                  child: Catogry_Avatar(
                                    Status[index],
                                    context,
                                  )),
                              separatorBuilder: (context, index) => SizedBox(
                                width: size.width*.05,
                              ),
                              itemCount: Status.length),
                        ),
                      ],
                    ),
                  ),
                ),));
  }

  SizedBox Wallpaperstack(Size size) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Image.asset("lib/Image/wallpaper.jpg", fit: BoxFit.fill),
    );
  }



  Container SignupContenar({size}) {
    return Container(
      margin: EdgeInsetsDirectional.only(top: size.height*.2),
      padding: const EdgeInsetsDirectional.all(15),
      width: MediaQuery.of(context).size.width - 30,
      height: MediaQuery.of(context).size.height * .6,
      decoration: BoxDecoration(
          color: ColorManger.maincolor,
          borderRadius: BorderRadius.circular(40.0)),
      child: Form(
        key: kayform,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Mytextfield(
                Controlr: name,
                hint: "Enter you name,...",
                keybordtype: TextInputType.name,
                Prefix:
                const Icon(Icons.drive_file_rename_outline, color: Colors.grey),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "      Name must not be empty";
                  }
                  return null;
                }),
            Mytextfield(
                Controlr: email,
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
            Mytextfield(
                Controlr: repass,
                hint: "Enter you pass again,...",
                keybordtype: TextInputType.visiblePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "      pass must not be empty";
                  } else if (value != pass.text) {
                    return "      must be same to password ❌";
                  }
                  ;
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
            Mytextfield(
                Controlr: phone,
                hint: "Enter you phone,...",
                keybordtype: TextInputType.visiblePassword,
                Prefix: const Icon(Icons.phone, color: Colors.grey),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "      phone must ne not empty ";
                  }
                  return null;
                }),
            mybutton(
                Widget: const Text("Done",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )),
                function: () => {
                  if (kayform.currentState!.validate())
                    {
                      Navigator.pop(context),
                      Nevigator(
                          context: context, bool: true, page: homelayout()),
                      sherdprefrence.setdate(key: "login", value: true),
                      layoutCuibt.get(context).insertToUsers(
                          Name: name.text,
                          Email: email.text,
                          pass: pass.text,
                          phone: phone.text,
                          status: StatusUser)
                    },
                })
          ],
        ),
      ),
    );
  }

  Positioned Textupcontenar(text) {
    return Positioned(
      top: 20,
      left: 10,
      child: Row(
        children: [
          Text(
            text,
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


  Column Catogry_Avatar(
    StatusModel model,
    context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnimatedOpacity(
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          opacity: model.ontap ? 1 : 0,
          child: AnimatedContainer(
            width: 120,
            height: 135,
            decoration: BoxDecoration(
                color: ontap,
                borderRadius: BorderRadiusDirectional.circular(30.0)),
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: Column(
              children: [
                const SizedBox(
                  height: 3,
                ),
                CircleAvatar(
                  radius: 54,
                  backgroundColor: Colors.redAccent.shade700,
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
                Text(
                  model.title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class StatusModel {
  final String? Photo;
  final String? title;
  bool ontap = true;

  StatusModel({required this.Photo, required this.title, ontap});
}

List<StatusModel> Status = [
  StatusModel(
    Photo: "lib/Image/single.jpg",
    title: "Single",
    ontap: true,
  ),
  StatusModel(
    Photo: "lib/Image/married.jpg",
    title: "Married",
    ontap: true,
  ),
  StatusModel(
    Photo: "lib/Image/bussinesStatus.jpg",
    title: "Business",
    ontap: true,
  ),
];
