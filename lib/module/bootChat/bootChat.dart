
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_task/Componads/my%20textformfild.dart';
import 'package:my_task/Translition/locale_kays.g.dart';
import '../../Model/Model.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
class RobotChat extends StatefulWidget {
  const RobotChat({super.key});

  @override
  State<RobotChat> createState() => _RobotChatState();
}

class _RobotChatState extends State<RobotChat> {
  @override
  void initState() {
    setState(() {
      if( layoutCuibt.get(context).robotChat.isNotEmpty){
        layoutCuibt.get(context).robotChat.clear();
      }
        layoutCuibt.get(context).handleChatBoot(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
      listener: (context, state) {},
      builder: (context, state) {
        var Size = MediaQuery.of(context).size;
        var cuibt = layoutCuibt.get(context);
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.only(top: 10),
            height: Size.height,
            width: Size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/Image/chatWallpaper.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      controller: cuibt.controllerChat,
                      itemBuilder: (context, I) {
                        if (cuibt.robotChat[I].user == "user") {
                          return userMassage(cuibt.robotChat[I]);
                        } else {
                          return rebootMassage(cuibt.robotChat[I]);
                        }
                      },
                      separatorBuilder: (context, _) =>
                          const SizedBox(height: 10),
                      itemCount: cuibt.robotChat.length),
                ),
                suggestionWords(cuibt),
                suggestionCategory(cuibt),
                SizedBox(
                  height: 50,
                  width: Size.width,
                  child: Mytextfield(
                      hint: LocaleKeys.MessageHint.tr(),
                      suffix: IconButton(
                        onPressed: () {
                          //to close keyboard when send massage
                          if (WidgetsBinding.instance.window.viewInsets.bottom > 0) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          }

                          cuibt.robotChat.add(RobotChatModel(
                              cuibt.chatField.text,
                              "user",
                              DateFormat('hh:mm').format(DateTime.now())));
                          cuibt.handleChatBoot(context);
                          cuibt.controllerChat.animateTo(
                              cuibt.controllerChat.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.bounceIn);
                          cuibt.chatField.clear();
                        },
                        icon: const Icon(Icons.send, color: Colors.teal),
                      ),
                      Controlr: cuibt.chatField,
                      keybordtype: TextInputType.text
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
Column suggestionWords(layoutCuibt cuibt){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (cuibt.robotChat.length == 1 ||
          cuibt.robotChat.last.massage == LocaleKeys.letsgo.tr())
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          padding: const EdgeInsets.only(left: 10, right: 10),
          color: Colors.white70,
          child:  Text(
            LocaleKeys.SuggestionWords.tr(),
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      if (cuibt.robotChat.length == 1 ||
          cuibt.robotChat.last.massage == LocaleKeys.letsgo.tr())
        suggestMassage(massage: LocaleKeys.WannaTask.tr()),
      if (cuibt.robotChat.length == 1 ||
          cuibt.robotChat.last.massage == LocaleKeys.letsgo.tr())
        suggestMassage(
            massage: LocaleKeys.wannaMoney.tr()),
    ],
  );
}
  Widget suggestionCategory(layoutCuibt cuibt){
    return cuibt.robotChat.last.massage ==LocaleKeys.whichCategories.tr()?
      Flexible(
        child: ListView (
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              padding: const EdgeInsets.only(left: 10, right: 10),
              color: Colors.white70,
              child:  Text(
                LocaleKeys.SuggestionWords.tr(),
                style:const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            suggestMassage(massage: LocaleKeys.Home.tr()),
            suggestMassage(massage: LocaleKeys.Teaching.tr()),
            suggestMassage(massage:LocaleKeys.food.tr()),
            suggestMassage(massage: LocaleKeys.clothes.tr()),
            suggestMassage(massage: LocaleKeys.Healthcare.tr()),
            suggestMassage(massage: LocaleKeys.Fun.tr()),
            suggestMassage(massage: LocaleKeys.Travel.tr()),
            suggestMassage(massage: LocaleKeys.MoneySaving.tr()),
            suggestMassage(massage: LocaleKeys.GainedMoney.tr()),
          ],
        ),
      ):const SizedBox();
}

  Widget userMassage(RobotChatModel massage) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius:
                    BorderRadiusDirectional.all(Radius.circular(25.0))),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              children: [
                Text(
                  "${massage.massage}  ",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${massage.time}  ",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      );
  Widget rebootMassage(RobotChatModel massage) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.pink.withOpacity( 0.7),
                borderRadius:
                const BorderRadiusDirectional.all(Radius.circular(25.0))),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${massage.massage} ",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "${massage.time}  ",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ),
      );
  Widget suggestMassage({required String massage}) {
    return InkWell(
      onTap: () {
        setState(() {
          layoutCuibt.get(context).robotChat.add(RobotChatModel(
              massage, "user", DateFormat('hh:mm').format(DateTime.now())));
        });
        layoutCuibt.get(context).handleChatBoot(context, message: massage);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 60,
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
            color: Colors.indigo[300]!.withOpacity(.9),
            borderRadius:
                const BorderRadiusDirectional.all(Radius.circular(20.0))),
        child: Text(
          "$massage",
          style: const TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

}
