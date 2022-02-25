import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';
import 'package:my_task/module/AddTasks/AddTasks.dart';
import 'package:my_task/module/AllTaks/AllTasks.dart';
import 'package:my_task/module/MoneyOrganiz/MoneyOrganiz.dart';
import 'package:my_task/module/MyTasks/MyTasks.dart';
import 'package:my_task/module/homelayout/layoutCuibt/loginstates.dart';
import 'package:sqflite/sqflite.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../AddTasks/edit task.dart';
import '../../Gamespointer/Analytics.dart';

class layoutCuibt extends Cubit<mytasks> {
  layoutCuibt() : super(mytasksstateinisal());

  static layoutCuibt get(context) => BlocProvider.of(context);
  var MyIndex = 0;
  late Database datab;
  List<Map> tasks = [];
  List<Map> task = [];
  List<Map> Budget = [];
  List<Map> Users = [];
  double sallary = sherdprefrence.getdate(key: "salary") != null
      ? sherdprefrence.getdate(key: "salary")
      : 0;
  late double sallaryAfter = Budget.isNotEmpty? double.parse(
      Budget[Budget.length - 1]["MONEYAfter"].toString()) : sherdprefrence
      .getdate(key: "salary");
  var currentStep = 0;
  bool bottomshown = false;
  var kayscafold = GlobalKey<ScaffoldState>();
  var kayform = GlobalKey<FormState>();
  var firstvalue = "5 Min";
  var Scondvalue = "low";
  var id = 1;
  var Ondate = DateFormat.yMMMd().format(DateTime.now());
  var titleContoralr = TextEditingController();
  var desContoralr = TextEditingController();
  var catagoryContoralr = TextEditingController();
  var dataContoralr = TextEditingController();
  var moneyContoralr = TextEditingController();
  var controlar = PageController(initialPage: 0);
  List body = [
    HomeTasks(),
    MoneyOraganize(),
    analytics(),
    insight(),
  ];

  List<PreferredSizeWidget> appbar = [
    AppBar(

      title: "TASKS".text.make().shimmer(duration: Duration(seconds: 2),),
      toolbarHeight: 40,
    ),
    AppBar(
      title: "Today Tasks".text.make().shimmer(duration: Duration(seconds: 2),),
      toolbarHeight: 40,
    ),
    AppBar(
      title: const Text("Analytics"),
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
          Icons.insert_chart,
        ),
        title: const Text('Analytics'),
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
          'CREATE TABLE TASKS (id INTEGER PRIMARY KEY,title TEXT,desc TEXT,data TEXT ,time STRING,repeat INTEGER,priority TEXT)');
      datab.execute(
          'CREATE TABLE Users (id INTEGER PRIMARY KEY, Name TEXT,Email TEXT,pass TEXT ,Phone TEXT,status STRING)');
      datab.execute(
          'CREATE TABLE BUDGET (id INTEGER PRIMARY KEY,title TEXT,desc TEXT,MONEY num, MONEYAfter num,data STRING,catogry TEXT)')
          .then((value) {
        emit(CreateDataBaseSucssesful());
      }).catchError((error) {
        print("error is${error.toString()}");
        emit(CreateDataBaseError());
      });
    }, onOpen: (datab) {
      print("open data base");
      getDataTasks(datab).then((value) {
        task = value;
        task.forEach((element) {
          if (element["data"] == Ondate)
            tasks.add(element);
        });
        print(tasks);
        emit(GetDatatasksSucssesful());
      }).catchError((Error) {
        print("the error is ${Error.toString()}");
        emit(GetDataBaseError());
      });
      getDataBudget(datab).then((value) {
        Budget = [];
        Budget = value;
        emit(GetDatabudgetSucssesful());
      });
      getDateUsers(datab).then((value) {
        Users = [];
        Users = value;
        print(Users);
        emit(getUsersData());
      });
    });
  }

  //get data from Datebase
  Future<List<Map>> getDataTasks(datab) async {
    return await datab.rawQuery('SELECT*FROM TASKS');
  }

  Future<List<Map>> getDataBudget(datab) async {
    return await datab.rawQuery('SELECT*FROM BUDGET');
  }
  Future<List<Map>> getDateUsers(datab) async {
    return await datab.rawQuery('SELECT*FROM Users');
  }

  void getDataTasksAfterChange() {
    getDataTasks(datab).then((value) {
      task = [];
      tasks = [];
      task = value;
      task.forEach((element) {
        if (element["data"] == Ondate)
          tasks.add(element);
        emit(GetDatatasksSucssesful());
      });
    });
  }

  void getBudgetAfterChange() {
    getDataBudget(datab).then((value) {
      Budget = [];
      Budget = value;
      print(Budget);
      emit(getsallaryafter());
    });
  }
  void getUsersAfterChange() {
    getDateUsers(datab).then((value) {
      Users = [];
      Users = value;
      print(Users);
      emit(getUsersData());
    });
  }

  //insert new task in Datebase
  Future insert({required title, required desc, required time, required date, required repeat, required priority}) async {
    await datab.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO TASKS(title,desc,time,data,repeat,priority)VALUES("$title","$desc","$time","$date","$repeat","$priority")')

          .then((value) {
        print("$value insertetd sucsseffly");
        getDataTasksAfterChange();
      }).catchError((error) {
        print(" the error is ${error.toString()}");
        emit(InsertDataBaseError());
      });
      return getname();
    });
  }
  Future insertToUsers({required Name, required Email, required pass, required phone, required status}) async {
    await datab.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO Users(Name,Email,pass,Phone,status)VALUES("$Name","$Email","$pass","$phone","$status")')
      //'INSERT INTO TASKS(title,desc,time,data,repeat,priority)VALUES("$title","$desc","$time","$date","$repeat","$priority")')
          .then((value) {
        print("$value insertetd sucsseffly");
        getUsersAfterChange();
      }).catchError((error) {
        print(" the error is ${error.toString()}");
        emit(InsertDataBaseError());
      });
      return getname();
    });
  }

  //insert new budget in Datebase
  Future insertbudget(
      {required title, required desc, required MONEY, required data, required catogry}) async {
    await datab.transaction((txn) {
      if (catogry == "lib/Image/gain money.webp") {
        txn.rawInsert(
            'INSERT INTO BUDGET(title,desc,MONEY,MONEYAfter,data,catogry)VALUES("$title","$desc","$MONEY","${sallaryAfter +
                MONEY}","$data","$catogry")').then((value) {
          print("$value inserted successes");
          getDataBudget(datab).then((value) {
            Budget = [];
            Budget = value;
            print(Budget);
            changeprecent(sallaryAfter + MONEY);
            emit(getsallaryafter());
          });
          titleContoralr.clear();
          desContoralr.clear();
          moneyContoralr.clear();
          dataContoralr.clear();
          catagoryContoralr.clear();
        }).catchError((error) {
          print(" the error is ${error.toString()}");
          emit(InsertDataBaseError());
        });
      } else
        txn.rawInsert(
            'INSERT INTO BUDGET(title,desc,MONEY,MONEYAfter,data,catogry)VALUES("$title","$desc","$MONEY","${sallaryAfter -
                MONEY}","$data","$catogry")')
            .then((value) {
          print("$value inserted successes");
          getDataBudget(datab).then((value) {
            Budget = [];
            Budget = value;
            print(Budget);
            changeprecent(sallaryAfter - MONEY);
            emit(getsallaryafter());
          });
          titleContoralr.clear();
          desContoralr.clear();
          moneyContoralr.clear();
          dataContoralr.clear();
          catagoryContoralr.clear();
        }).catchError((error) {
          print(" the error is ${error.toString()}");
          emit(InsertDataBaseError());
        });
      return getname();
    });
  }

  Future<String> getname() async => ("youssef ahmed ");

  //update data in database
  void update({ String? priority, String? repeat, int id=1,time,date }) async {
    print("$priority ,$repeat,$time,$date");
   /* if (priority != null && repeat != null && date != "" && time != "") {
      datab.rawUpdate(
          'UPDATE TASKS SET time=? WHERE id=? ', [time, id]);
      datab.rawUpdate(
          'UPDATE TASKS SET data=? WHERE id=? ', [date, id]);
      datab.rawUpdate(
          'UPDATE TASKS SET priority=? WHERE id=? ', [priority, id]);
      datab.rawUpdate(
          'UPDATE TASKS SET repeat=? WHERE id=? ', [repeat, id]);
      print("All things change");
      getdataafterchange();
      emit(UpdateDataBaseError());
    }*/
    if (repeat != null) {
      datab.rawUpdate(
          'UPDATE TASKS SET repeat=? WHERE id=? ', [repeat, id]).then((value) {
            print("repeat");
            getDataTasksAfterChange();
        emit(UpdateDataBaseError());
      });
    }  if (priority != null) {
      datab.rawUpdate(
          'UPDATE TASKS SET priority=? WHERE id=? ', [priority, id]).then((
          value) {
        print("priority");
        getDataTasksAfterChange();
        emit(UpdateDataBaseError());
      });
    }  if (time != "") {
      datab.rawUpdate(
          'UPDATE TASKS SET time=? WHERE id=? ', [time, id]).then((value) {
        print("time");
        getDataTasksAfterChange();
        emit(UpdateDataBaseError());
      });
    } if (date != "") {
      datab.rawUpdate(
          'UPDATE TASKS SET data=? WHERE id=? ', [date, id]).then((value) {
        print("data");
        getDataTasksAfterChange();
        emit(UpdateDataBaseError());
      });
    }

  }
  //delete task from datebase
  void delete({required int id }) async {
    await datab.rawDelete('DELETE FROM TASKS WHERE id=? ', [id]);
    getDataTasks(datab).then((value) {
      tasks = [];
      tasks = value;
      print(tasks);
      emit(DeleteDataBaseSucssesful());
    });
  }

  void deletebudget({required int id }) async {
    await datab.rawDelete('DELETE FROM BUDGET WHERE id=? ', [id]);
    getDataBudget(datab).then((value) {
      Budget = [];
      Budget = value;
      print(Budget);
      changeprecent(
          Budget == [] ? sallary : Budget[Budget.length - 1]["MONEYAfter"]);
      emit(getsallaryafter());
    });
  }

  //change value of repeat step
  void changevaluerepeat(value,) {
    firstvalue = value;
    emit(ChangeMyvaluerepet());
  }

  //change value of repeat priory
  void changevaluepri(value,) {
    Scondvalue = value;
    emit(ChangeMyvaluepri());
  }

  //method to press continue in step
  void OnPressedContStepper(context) async {
    if (currentStep < 5) {
      currentStep += 1;
      emit(OnPressedonStepper());
    } else {
      
        insert(title: title.text,
            desc: desc.text,
            time: time.text,
            date: date.text,
            repeat: firstvalue,
            priority: Scondvalue);
        await AndroidAlarmManager.periodic(const Duration(minutes: 1), id, printHello);
        currentStep = 0;
        title.clear();
        desc.clear();
        time.clear();
        date.clear();
        Navigator.pop(context);
        emit(OnPressedonStepper());
      
    }
  }
  void OnPressedContStepperEdit(
      {context, id, priority, repeat}) async {
    if (currentStep < 5) {
      currentStep += 1;
      emit(OnPressedonStepper());
    } else {
        update(id:id,priority:Scondvalue,repeat:firstvalue,date:datel.text,time: timed.text );
        currentStep = 0;

        time.clear();
        date.clear();
        Navigator.pop(context);
        emit(OnPressedonStepper());

    }
  }

  void printHello() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  }

  //method to press cancel in step
  void OnPressedcacselStepper(context) {
    if (currentStep <= 5) {
      if (currentStep == 0) {
        Navigator.pop(context);
      } else
        currentStep -= 1;
      emit(OnPressedonStepper());
    }
  }

  void changeprecent(value) {
    print(sallaryAfter);
    sallaryAfter = double.parse(value.toString());
    emit(getsallaryafter());
    print("this is after ${sallaryAfter}");
  }

  void changesallary(value) {
    sherdprefrence.setdate(key: "salary", value: double.parse(value));
    sallary = sherdprefrence.getdate(key: "salary");
    emit(getsallary());
  }

  void Catogerye(value) {
    catagoryContoralr.text = "${value}";
    emit(changeCatogery());
  }

  void budgetdate(value) {
    dataContoralr.text = DateFormat.yMMMd().format(value!);
    emit(changedate());
  }
}
