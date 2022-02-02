import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';
import 'package:my_task/module/AddTasks/AddTasks.dart';
import 'package:my_task/module/AllTaks/AllTasks.dart';
import 'package:my_task/module/MoneyOrganiz/MoneyOrganiz.dart';
import 'package:my_task/module/MyTasks/MyTasks.dart';
import 'package:my_task/module/homelayout/layoutCuibt/loginstates.dart';
import 'package:sqflite/sqflite.dart';

import '../../../Componads/my textformfild.dart';
import '../../Gamespointer/GamePointer.dart';
class layoutCuibt extends Cubit<mytasks> {
  layoutCuibt() : super(mytasksstateinis());
  static layoutCuibt get(context) => BlocProvider.of(context);
  var MyIndex = 0;
  late Database datab;
  List<Map> tasks=[];
  List<Map> task=[];
  PageController pageController = PageController();
  var currentStep=0;
  var firstvalue="5 Min";
  var Scondvalue="low";
  var Ondate=DateFormat.yMMMd().format(DateTime.now());
  List body = [
    HomeTasks(),
    MoneyOraganize(),
    GamePointer(),
    insight(),
  ];
  List<PreferredSizeWidget> appbar = [
    AppBar(
      title: const Text("Today Task"),
      toolbarHeight: 40,
    ),
    AppBar(
      title: const Text("business"),
      toolbarHeight: 40,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.attach_money,color: Colors.green,),
            Text("${sherdprefrence.getdate(key: "salary")}"),
            SizedBox(width: 10,)
          ],
        )
      ],
    ),
    AppBar(
      title: const Text("Game Point"),
      toolbarHeight: 40,

    ),
    AppBar(
      toolbarHeight: 40,
      title: const Text("insight"),
    ),
  ];
  List<BottomNavyBarItem> ItemNav = [
    BottomNavyBarItem(
      icon: Image.asset(
        "lib/Image/icon.jpg",
        height: 30,
        width: 25,
      ),
      title: const Text('tasks'),
      activeColor: Colors.red,
    ),
    BottomNavyBarItem(
        icon: const Icon(
          Icons.account_balance_wallet,
        ),
        title: const Text('balances'),
        activeColor: Colors.cyan),
    BottomNavyBarItem(
        icon: const Icon(
          Icons.scoreboard,
        ),
        title: const Text('game point'),
        activeColor: Colors.pink),
    BottomNavyBarItem(
        icon: const Icon(
          Icons.insert_chart,
        ),
        title: const Text('insight '),
        activeColor: Colors.blue),
  ];
  void ChangeIndex(index) {
    MyIndex = index;
    /*pageController.animateToPage(index,
      duration: Duration(milliseconds: 300), curve: Curves.ease);*/
    emit(ChangeMyIndex());
  }
//create database and open it every time run app
  void Crdatab() async {
    datab =
        await openDatabase("endtask.db", version: 1, onCreate: (datab, version) {
      print("create data base");
      datab.execute(
              'CREATE TABLE TASKS (id INTEGER PRIMARY KEY,title TEXT,desc TEXT,data TEXT ,time STRING,repeat INTEGER,priority TEXT)')
      //datab.execute('CREATE TABLE TASK (id INTEGER PRIMARY KEY,title TEXT,data TEXT ,time STRING,status TEXT)')
          .then((value) {
        print("creat table");
        emit(CreateDataBaseSucssesful());
      }).catchError((error) {
        print("error is${error.toString()}");
        emit(CreateDataBaseError());
      });
    }, onOpen: (datab) {
      print("open data base");
      getdate(datab).then((value) {
        task=value;
        task.forEach((element) {
         if(element["data"]==Ondate)
           tasks.add(element);
        });
        print(tasks);

      }).catchError((Error){
        print("the error is ${Error.toString()}");
        emit(GetDataBaseError());
      });
    });
  }
  //get data from Datebase
  Future<List<Map>> getdate(datab) async {
    return  await datab.rawQuery('SELECT*FROM TASKS');
  }
  void getdataafterchange(){
    getdate(datab).then((value) {
      task=[];
      tasks=[];
      task=value;
      task.forEach((element) {
        if(element["data"]==Ondate)
          tasks.add(element);
        emit(GetDataBaseSucssesful());
      });
    });
  }
  //insert new task in Datebase
  Future insert({required title, required desc, required time, required date, required repeat, required priority}) async
  {
    await datab.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO TASKS(title,desc,time,data,repeat,priority)VALUES("$title","$desc","$time","$date","$repeat","$priority")')

          .then((value) {
        print("$value insertetd sucsseffly");
        getdataafterchange();
      }).catchError((error) {
        print(" the error is ${error.toString()}");
        emit(InsertDataBaseError());
      });
      return getname();
    });
  }
  Future<String> getname() async => ("youssef ahmed ");
  //update data in database
  void update({ String? remind,String? repeat ,required int id }) async {
    if(remind!=null) {
      datab.rawUpdate(
          'UPDATE TASKS SET remind=? WHERE id=? ', [remind, id]).then((value) {
        getdate(datab);
        emit(UpdateDataBaseError());
      });
    }else if(repeat!=null) {
      datab.rawUpdate(
          'UPDATE TASKS SET repeat=? WHERE id=? ', [repeat, id]).then((value) {
        getdate(datab);
        emit(UpdateDataBaseError());
      });
    }else if(remind!=null&&repeat!=null){
      datab.rawUpdate(
          'UPDATE TASKS SET remind=? WHERE id=? ', [remind, id]).then((value) {
        getdate(datab);
        emit(UpdateDataBaseError());
      });
      datab.rawUpdate(
          'UPDATE TASKS SET repeat=? WHERE id=? ', [repeat, id]).then((value) {
        getdate(datab);
        emit(UpdateDataBaseError());
      });
    }
  }
  //delete task from datebase
  void delete({required int id })async  {
     await datab.rawDelete('DELETE FROM TASKS WHERE id=? ',[id]);
    getdate(datab).then((value) {
      tasks=[];
      tasks = value;
      print(tasks);
      emit(DeleteDataBaseSucssesful());
    });




  }
  //change value of repeat step
  void changevaluerepeat(value,){
    firstvalue=value;
    emit(ChangeMyvaluerepet());
  }
  //change value of repeat priory
  void changevaluepri(value,){
    Scondvalue=value;
    emit(ChangeMyvaluepri());
  }
  //method to press continue in step
  void OnPressedContStepper(context){
    if(currentStep<5){
      currentStep+=1;
      emit(OnPressedonStepper());
    }else{
      insert(title: title.text, desc: desc.text, time: time.text, date: date.text, repeat:firstvalue, priority:Scondvalue);
      currentStep=0;
      title.clear();
      desc.clear();
     Navigator.pop(context);
      emit(OnPressedonStepper());
    }
  }
  //method to press cancel in step
  void OnPressedcacselStepper(context){
    if(currentStep<=5){
      if(currentStep==0) {
        Navigator.pop(context);
      }else
      currentStep-=1;
      emit(OnPressedonStepper());
    }
  }


  }
