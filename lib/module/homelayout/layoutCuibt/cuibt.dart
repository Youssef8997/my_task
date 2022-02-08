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
import '../../Gamespointer/GamePointer.dart';
class layoutCuibt extends Cubit<mytasks> {
  layoutCuibt() : super(mytasksstateinisal());
  static layoutCuibt get(context) => BlocProvider.of(context);
  var MyIndex = 0;
  late Database datab;
  List<Map> tasks=[];
  List<Map> task=[];
  List<Map> Budget=[];
  double sallary=sherdprefrence.getdate(key: "salary") != null
      ? sherdprefrence.getdate(key: "salary")
      : 0;
   late double sallaryAfter =Budget.isNotEmpty?double.parse(Budget[Budget.length-1]["MONEYAfter"].toString()):sherdprefrence.getdate(key: "salary");
  var currentStep=0;
  bool bottomshown=false;
  var kayscafold=GlobalKey<ScaffoldState>();
  var kayform=GlobalKey<FormState>();
  var firstvalue="5 Min";
  var Scondvalue="low";
  var Ondate=DateFormat.yMMMd().format(DateTime.now());
  var titleContoralr = TextEditingController();
  var desContoralr = TextEditingController();
  var catagoryContoralr = TextEditingController();
  var dataContoralr = TextEditingController();
  var moneyContoralr = TextEditingController();
  var controlar = PageController(initialPage: 0);
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
      datab.execute('CREATE TABLE TASKS (id INTEGER PRIMARY KEY,title TEXT,desc TEXT,data TEXT ,time STRING,repeat INTEGER,priority TEXT)');
          datab.execute('CREATE TABLE BUDGET (id INTEGER PRIMARY KEY,title TEXT,desc TEXT,MONEY num, MONEYAfter num,data STRING,catogry TEXT)')
              .then((value) {
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
emit(GetDatatasksSucssesful());
      }).catchError((Error){
        print("the error is ${Error.toString()}");
        emit(GetDataBaseError());
      });
      getdatebudget(datab).then((value) {
        Budget = [];
        Budget = value;
        emit(GetDatabudgetSucssesful());
      });
    });
  }
  //get data from Datebase
  Future<List<Map>> getdate(datab) async {
    return  await datab.rawQuery('SELECT*FROM TASKS');
  }
  Future<List<Map>> getdatebudget(datab) async {
    return  await datab.rawQuery('SELECT*FROM BUDGET');
  }
  void getdataafterchange(){
    getdate(datab).then((value) {
      task=[];
      tasks=[];
      task=value;
      task.forEach((element) {
        if(element["data"]==Ondate)
          tasks.add(element);
        emit(GetDatatasksSucssesful());
      });
    });
  }
  void getBUDGETafterchange(){
    getdatebudget(datab).then((value) {
      Budget=[];
      Budget=value;
print(Budget);
emit(getsallaryafter());
    });
  }
  //insert new task in Datebase
  Future insert({required title, required desc, required time, required date, required repeat, required priority}) async {
    await datab.transaction((txn) {
      txn.rawInsert(
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
  //insert new budget in Datebase
  Future insertbudget({required title, required desc, required MONEY, required data, required catogry}) async {
    await datab.transaction((txn) {
      txn.rawInsert(
              'INSERT INTO BUDGET(title,desc,MONEY,MONEYAfter,data,catogry)VALUES("$title","$desc","$MONEY","${sallaryAfter-MONEY}","$data","$catogry")')
          .then((value) {
        print("$value inserted successes");
        getdatebudget(datab).then((value) {
          Budget=[];
          Budget=value;
          print(Budget);
          changeprecent(sallaryAfter-MONEY);
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
  void changeprecent(value){
    print(sallaryAfter);
    sallaryAfter=double.parse(value.toString());
    emit(getsallaryafter());
    print("this is after ${sallaryAfter}");
  }
  void changesallary(value){
    sherdprefrence.setdate(key: "salary", value: double.parse(value));
    sallary=sherdprefrence.getdate(key: "salary");
    emit(getsallary());
  }
void Catogerye(value){
  catagoryContoralr.text ="${value}";
  emit(changeCatogery());
}
void budgetdate(value){
  dataContoralr.text = DateFormat.yMMMd().format(value!);
  emit(changedate());
}
  }
