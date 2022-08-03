import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';
import 'package:my_task/module/AddTasks/AddTasks.dart';
import 'package:my_task/module/MoneyOrganiz/MoneyOrganiz.dart';
import 'package:my_task/module/MyTasks/MyTasks.dart';
import 'package:my_task/module/Setting/Settings.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:sqflite/sqflite.dart';
import '../../../Componads/Com.dart';
import '../../../Model/Model.dart';
import '../Analytics/Analytics.dart';

class layoutCuibt extends Cubit<mytasks> {
  layoutCuibt() : super(mytasksstateinisal());
  static layoutCuibt get(context) => BlocProvider.of(context);
  var MyIndex = 0;
  late Database datab;
  List<Map> tasks = [];
  List<Map> task = [];
  List<Map> budget = [];
  List<Map> users = [];
  var controllerChat = ScrollController();
  String category = "Gained money";
  var dialogFormKey = GlobalKey<FormState>();
  bool isDarkMode=false;
  // massage which will be send from the robot
  List<RobotChatModel> robotResponded = [
    RobotChatModel(
        "Hi, I am your robot assistant. I can help you to manage your tasks and budget. What would you like to do?",
        "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(
        "hi,user", "Robot", DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(
        "I'm great ", "Robot", DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(
        "I'm joe Robot ", "Robot", DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(
        "lets go", "Robot", DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel("What is your task's title", "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(
        "okay, great", "Robot", DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel("What is your task's description", "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel("what time of your task", "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel("do you wanna repeat it ", "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel("what date of your task", "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel("how much you pay for it", "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel("why you pay this money", "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel("which category do you want to put it in", "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel("when you pay for it", "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
  ];
  List<RobotChatModel> robotChat = [];
  var chatField = TextEditingController();
  double salary = sherdprefrence.getdate(key: "salary") ?? 0;
  late double salaryAfter = budget.isNotEmpty
      ? double.parse(budget[budget.length - 1]["MONEYAfter"].toString())
      : sherdprefrence.getdate(key: "salary") ?? 0;
  var currentStep = 0;
  bool bottomShown = false;
  var kayScaffold = GlobalKey<ScaffoldState>();
  var kayForm = GlobalKey<FormState>();
  var addTask = GlobalKey<FormState>();
  var firstValue = "5 Min";
  var scondValue = "low";
  var id = 1;
  var onDate = DateFormat.yMMMd().format(DateTime.now());
  var titleController = TextEditingController();
  var descController = TextEditingController();
  var catagoryController = TextEditingController();
  var dataController = TextEditingController();
  var moneyController = TextEditingController();
  var controller = PageController(initialPage: 0);
  List body = [
    const HomeTasks(),
    moneyOraganize(),
    analytics(),
    const Settings(),
  ];

  List<CategoryModel> singleCategory = [
    CategoryModel(
      photo: "lib/Image/House.png",
      title: "Home",
    ),
    CategoryModel(
      photo: "lib/Image/Clothing-Logo-Vector.png",
      title: "Clothes",
    ),
    CategoryModel(
      photo: "lib/Image/helthcare.jpg",
      title: "Health care",
    ),
    CategoryModel(
      photo:
          "lib/Image/group-young-friends-having-fun-together-vector-26803087.jpg",
      title: "Fun",
    ),
    CategoryModel(
      photo:
          "lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg",
      title: "Travel",
    ),
    CategoryModel(
      photo: "lib/Image/logo-template-44-.jpg",
      title: "Money saving",
    ),
    CategoryModel(
      photo: "lib/Image/gainMoney.webp",
      title: "Gained money",
    ),
  ];
  List<CategoryModel> marriedCategory = [
    CategoryModel(
      photo: "lib/Image/House.png",
      title: "Home",
    ),
    CategoryModel(
      photo: "lib/Image/Teaching.png",
      title: "teaching",
    ),
    CategoryModel(
      photo: "lib/Image/food.png",
      title: "Food",
    ),
    CategoryModel(
      photo: "lib/Image/Clothing-Logo-Vector.png",
      title: "Clothes",
    ),
    CategoryModel(
      photo: "lib/Image/helthcare.jpg",
      title: "Health care",
    ),
    CategoryModel(
      photo:
          "lib/Image/group-young-friends-having-fun-together-vector-26803087.jpg",
      title: "Fun",
    ),
    CategoryModel(
      photo:
          "lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg",
      title: "Travel",
    ),
    CategoryModel(
      photo: "lib/Image/logo-template-44-.jpg",
      title: "Money saving",
    ),
    CategoryModel(
      photo: "lib/Image/gainMoney.webp",
      title: "Gained money",
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
          Icons.settings,
        ),
        title: const Text('Settings '),
        activeColor: Colors.blue),
  ];

  void ChangeIndex(index) {
    MyIndex = index;
    /*pageController.animateToPage(index,
      duration: Duration(milliseconds: 300), curve: Curves.ease);*/
    emit(ChangeMyIndex());
  }

//create database and open it every time run app
  void createDataBase() async {
    datab = await openDatabase("endtask.db", version: 1,
        onCreate: (datab, version) {
      print("create data base");
      datab.execute(
          'CREATE TABLE TASKS (id INTEGER PRIMARY KEY,title TEXT,desc TEXT,data TEXT ,time STRING,repeat INTEGER,priority TEXT)');
      datab.execute(
          'CREATE TABLE Users (id INTEGER PRIMARY KEY, Name TEXT,Email TEXT,pass TEXT ,Phone TEXT,status STRING)');
      datab
          .execute(
              'CREATE TABLE BUDGET (id INTEGER PRIMARY KEY,title TEXT,MONEY num, MONEYAfter num,data STRING,catogry TEXT)')
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
          if (element["data"] == onDate) {
            tasks.add(element);
          }
        });
        print(tasks);
        emit(GetDatatasksSucssesful());
      }).catchError((Error) {
        print("the error is ${Error.toString()}");
        emit(GetDataBaseError());
      });
      getDataBudget(datab).then((value) {
        budget = [];
        budget = value;
        emit(GetDatabudgetSucssesful());
      });
      getDateUsers(datab).then((value) {
        users = [];
        users = value;
        print(users);
        emit(getUsersData());
      });
    });
  }

  //get data from Database
  Future<List<Map>> getDataTasks(datab) async {
    return await datab.rawQuery('SELECT*FROM TASKS');
  }

  Future<List<Map>> getTasksDays(datab) async {
    return await datab.rawQuery('SELECT*FROM TASKS WHERE data=?', [onDate]);
  }

  void insertTaskIntoVar() {
    getTasksDays(datab).then((value) {
      tasks = [];
      tasks = value;
    });
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
        if (element["data"] == onDate) {
          tasks.add(element);
        }
        emit(GetDatatasksSucssesful());
      });
    });
  }

  void getBudgetAfterChange() {
    getDataBudget(datab).then((value) {
      budget = [];
      budget = value;
      print(budget);
      emit(getsallaryafter());
    });
  }

  void getUsersAfterChange() {
    getDateUsers(datab).then((value) {
      users = [];
      users = value;
      print(users);
      emit(getUsersData());
    });
  }

  //insert new task in DateBase
  Future insert(
      {required title,
      required desc,
      required time,
      required date,
      required repeat,
      required priority}) async {
    await datab.transaction((txn) {
      txn
          .rawInsert(
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

  Future insertToUsers(
      {required Name,
      required Email,
      required pass,
      required phone,
      required status}) async {
    await datab.transaction((txn) {
      txn
          .rawInsert(
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

  //insert new budget in Database
  Future insertBudget(
      {required title,
      required money,
      required data,
      required category}) async {
    await datab.transaction((txn) {
      //if the user gain money he will be add to the budget
      if (category == "lib/Image/gainMoney.webp") {
        txn
            .rawInsert(
                'INSERT INTO BUDGET(title,MONEY,MONEYAfter,data,catogry)VALUES("$title","$money","${salaryAfter + money}","$data","$category")')
            .then((value) {
          print("$value inserted successes");
          getBudgetAfterChange();
          changePrecent(salaryAfter + money);
          titleController.clear();
          descController.clear();
          moneyController.clear();
          dataController.clear();
          catagoryController.clear();
          emit(getsallaryafter());
        }).catchError((error) {
          print(" the error is ${error.toString()}");
          emit(InsertDataBaseError());
        });
      }
      //if the user spend money will decrease from the budget
      else {
        txn
            .rawInsert(
                'INSERT INTO BUDGET(title,MONEY,MONEYAfter,data,catogry)VALUES("$title","$money","${salaryAfter - money}","$data","$category")')
            .then((value) {
          print("$value inserted successes");
          getBudgetAfterChange();
          changePrecent(salaryAfter - money);
          titleController.clear();
          descController.clear();
          moneyController.clear();
          dataController.clear();
          catagoryController.clear();
          emit(getsallaryafter());
        }).catchError((error) {
          print(" the error is ${error.toString()}");
          emit(InsertDataBaseError());
        });
      }
      return getname();
    });
  }

  Future<String> getname() async => ("youssef ahmed ");

  //update data in database
  void update(
      {String? priority, String? repeat, int id = 1, time, date}) async {
    print("$priority ,$repeat,$time,$date");

    if (repeat != null) {
      datab.rawUpdate(
          'UPDATE TASKS SET repeat=? WHERE id=? ', [repeat, id]).then((value) {
        print("repeat");
        getDataTasksAfterChange();
        emit(UpdateDataBaseError());
      });
    }
    if (priority != null) {
      datab.rawUpdate('UPDATE TASKS SET priority=? WHERE id=? ',
          [priority, id]).then((value) {
        print("priority");
        getDataTasksAfterChange();
        emit(UpdateDataBaseError());
      });
    }
    if (time != "") {
      datab.rawUpdate('UPDATE TASKS SET time=? WHERE id=? ', [time, id]).then(
          (value) {
        print("time");
        getDataTasksAfterChange();
        emit(UpdateDataBaseError());
      });
    }
    if (date != "") {
      datab.rawUpdate('UPDATE TASKS SET data=? WHERE id=? ', [date, id]).then(
          (value) {
        print("data");
        getDataTasksAfterChange();
        emit(UpdateDataBaseError());
      });
    }
  }

  //delete task from database
  void delete({required int id}) async {
    await datab.rawDelete('DELETE FROM TASKS WHERE id=? ', [id]);
    getDataTasks(datab).then((value) {
      tasks = [];
      tasks = value;
      print(tasks);
      emit(DeleteDataBaseSucssesful());
    });
  }

  void deletebudget({required int id, required index}) async {
    await datab.rawDelete('DELETE FROM BUDGET WHERE id=? ', [id]);
    getDataBudget(datab).then((value) {
      budget = [];
      budget = value;
      print(budget);
      changePrecent(budget.isEmpty ? salary : budget[index - 1]["MONEYAfter"]);
      emit(getsallaryafter());
    });
  }

  //change value of repeat step
  void changevaluerepeat(
    value,
  ) {
    firstValue = value;
    emit(ChangeMyvaluerepet());
  }

  //change value of repeat priory
  void changevaluepri(
    value,
  ) {
    scondValue = value;
    emit(ChangeMyvaluepri());
  }

  //method to press continue in step and insert task in database
  void onPressedContinue(context, {notification = false}) async {
    if (currentStep < 5) {
      currentStep += 1;
      emit(OnPressedonStepper());
    } else {
      int year = int.parse(date.text.split(", ")[1]);
      int month = _convertNameMonthToNumber(date.text.substring(0, 3));
      int day = int.parse(date.text.split(" ")[1].split(",")[0]);
      int hour = _convertHourWhenPm(time.text);
      int minute = int.parse(time.text.split(":")[1].split(" ")[0]);
        await AwesomeNotifications().getGlobalBadgeCounter().then(
            (badge) => AwesomeNotifications().setGlobalBadgeCounter(badge + 1));

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: task.length + 1,
          channelKey: "tasks1",
          title: title.text,
          body: desc.text,
          autoDismissible: true,
          wakeUpScreen: true,
          customSound: "resource://raw/alart_sound",
          locked: true,
          category: NotificationCategory.Reminder,
          criticalAlert: true,
          showWhen: true,
          ticker: "ticker",
        ),
        schedule: NotificationCalendar.fromDate(
            date: DateTime(year, month, day, hour, minute),
            allowWhileIdle: true,
            preciseAlarm: true,
            repeats: false),
      );
      insert(
          title: title.text,
          desc: desc.text,
          time: time.text,
          date: date.text,
          repeat: firstValue,
          priority: scondValue);
      currentStep = 0;
      title.clear();
      desc.clear();
      time.clear();
      date.clear();
      if (notification == false) {
        Navigator.pop(context);
      }
      emit(OnPressedonStepper());
    }
  }

  void pressedContinueEdit({context, id, priority, repeat}) async {
    if (currentStep < 5) {
      currentStep += 1;
      emit(OnPressedonStepper());
    } else {
      update(
          id: id,
          priority: scondValue,
          repeat: firstValue,
          date: date.text,
          time: time.text);
      currentStep = 0;
      time.clear();
      date.clear();
      Navigator.pop(context);
      emit(OnPressedonStepper());
    }
  }

  //method to press cancel in step
  void onPressedCancel(context) {
    if (currentStep <= 5) {
      if (currentStep == 0) {
        Navigator.pop(context);
      } else {
        currentStep -= 1;
      }
      emit(OnPressedonStepper());
    }
  }

  void changePrecent(value) {
    salaryAfter = double.parse(value.toString());
    emit(getsallaryafter());
  }

  void setSalary(value) {
    sherdprefrence.setdate(key: "salary", value: double.parse(value));
    salary = double.parse(value);
    salaryAfter = double.parse(value);
    emit(getsallary());
  }

  void Catogerye(value) {
    catagoryController.text = "$value";
    emit(changeCatogery());
  }

  void budgetDate(value) {
    dataController.text = DateFormat.yMMMd().format(value!);
    emit(changedate());
  }

  void onPressedAdd(context) {
    Nevigator(bool: true, context: context, page: const Tasks());
  }

  int _convertNameMonthToNumber(month) {
    log(month);
    switch (month) {
      case "Jan":
        return month = 1;
      case "Feb":
        return month = 2;

      case "Mar":
        return month = 3;

      case "Apr":
        return month = 4;

      case "May":
        return month = 5;

      case "Jun":
        return month = 6;

      case "Jul":
        return month = 7;

      case "Aug":
        return month = 8;

      case "Sep":
        return month = 9;

      case "Oct":
        return month = 10;

      case "Nov":
        return month = 11;

      case "Dec":
        return month = 12;
      default:
        return month = 1;
    }
  }

  // to convert time when be pm to make hour 24 h
  int _convertHourWhenPm(String time) {
    log(time);
    if (time.split(":")[1].split(" ")[1] == "PM") {
      if (int.parse(time.split(":")[0]) < 12) {
        return int.parse(time.split(":")[0]) + 12;
      } else {
        return int.parse(time.split(":")[0]);
      }
    } else {
      return int.parse(time.split(":")[0]);
    }
  }

  // to make respond from reboot app
  void handleChatBoot(context, {String? message}) {
    if (robotChat.isEmpty) {
      robotChat.add(robotResponded[0]);
    } else if (chatField.text == "hi" ||
        chatField.text == "hello" ||
        chatField.text == "hey" ||
        chatField.text == "hi there") {
      robotChat.add(robotResponded[1]);
    } else if (chatField.text == "how are you?" ||
        chatField.text == "how are you" ||
        chatField.text == "whats up") {
      robotChat.add(robotResponded[2]);
      robotChat.add(robotResponded[4]);
    } else if (chatField.text == "what is your name?" ||
        chatField.text == "what is your name") {
      robotChat.add(robotResponded[3]);
    } else if (message == "I want to add new task" ||
        message == "add task" ||
        message == "task" ||
        message == "i wanna add new task" ||
        chatField.text == "i want to add new task" ||
        chatField.text == "add task" ||
        chatField.text == "task" ||
        chatField.text == "i wanna add new task") {
      robotChat.add(robotResponded[5]);
    } else if (message == "I want to add new financial transaction" ||
        message == "add money" ||
        message == "money" ||
        message == "i wanna add new financial transaction" ||
        chatField.text == "I want to add new financial transaction" ||
        chatField.text == "add money" ||
        chatField.text == "money" ||
        chatField.text == "i wanna add new financial transaction") {
      robotChat.add(robotResponded[11]);
    }
    if (robotChat.length > 3) {
      //task
      if (robotChat[robotChat.length - 2].massage ==
          "What is your task's title") {
        title.text = robotChat[robotChat.length - 1].massage;
        robotChat.add(robotResponded[6]);
        robotChat.add(robotResponded[7]);
      } else if (robotChat[robotChat.length - 2].massage ==
          "What is your task's description") {
        desc.text = robotChat[robotChat.length - 1].massage;
        robotChat.add(robotResponded[6]);
        robotChat.add(robotResponded[8]);
        Future.delayed(const Duration(seconds: 3), () {
          showTimePicker(
                  helpText: "Select your task's Time ",
                  context: context,
                  initialTime: TimeOfDay.now(),
                  initialEntryMode: TimePickerEntryMode.input)
              .then((value) {
            value ??= TimeOfDay.now();
            time.text = value.format(context).toString();
            robotChat.add(RobotChatModel(
                time.text, "user", DateFormat('hh:mm').format(DateTime.now())));
            handleChatBoot(context);
          });
        });
      } else if (robotChat[robotChat.length - 2].massage ==
          "what time of your task") {
        robotChat.add(robotResponded[6]);
        robotChat.add(robotResponded[10]);
        Future.delayed(const Duration(seconds: 3), () {
          showDatePicker(
            helpText: "Select your task's Date",
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.parse('2022-11-07'),
          ).then((value) {
            value ??= DateTime.now();
            date.text = DateFormat.yMMMd().format(value);
            robotChat.add(RobotChatModel(
                date.text, "user", DateFormat('hh:mm').format(DateTime.now())));
            emit(HandleMassage());
            handleChatBoot(context);
          });
        });
      } else if (robotChat[robotChat.length - 2].massage ==
          "do you wanna repeat it ") {
        //to make method work to insert data to database and make notification
        currentStep = 6;
        firstValue = robotChat[robotChat.length - 1].massage;
        robotChat.add(robotResponded[6]);
        onPressedContinue(context, notification: true);
      } else if (robotChat[robotChat.length - 2].massage ==
          "what date of your task") {
        date.text = robotChat[robotChat.length - 1].massage;
        robotChat.add(robotResponded[6]);
        robotChat.add(robotResponded[9]);
      }
      //financial transaction
      if (robotChat[robotChat.length - 2].massage ==
          "how much you pay for it") {
        moneyController.text = robotChat[robotChat.length - 1].massage;
        robotChat.add(robotResponded[6]);
        robotChat.add(robotResponded[12]);
      } else if (robotChat[robotChat.length - 2].massage ==
          "why you pay this money") {
        descController.text = robotChat[robotChat.length - 1].massage;
        robotChat.add(robotResponded[6]);
        robotChat.add(robotResponded[13]);
      } else if (robotChat[robotChat.length - 2].massage ==
          "which category do you want to put it in") {
        _handleSelectedCategory(robotChat[robotChat.length - 1].massage);
        Future.delayed(const Duration(milliseconds: 500), () {
          robotChat.add(robotResponded[6]);
          robotChat.add(robotResponded[14]);
        });
        Future.delayed(const Duration(milliseconds: 600), () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.parse('2022-11-07'),
          ).then((value) {
            value ??= DateTime.now();
            dataController.text = DateFormat.yMMMd().format(value);
            robotChat.add(RobotChatModel(dataController.text, "user",
                DateFormat('hh:mm').format(DateTime.now())));
            handleChatBoot(context);
          });
        });
      } else if (robotChat[robotChat.length - 2].massage ==
          "when you pay for it") {
        //to make method work to insert data to database and make notification
        robotChat.add(robotResponded[6]);
        insertBudget(
            title: titleController.text,
            money: double.parse(moneyController.text, (_) {
              return 0.0;
            }),
            data: dataController.text,
            category: catagoryController.text);
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        controllerChat.animateTo(controllerChat.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceIn);
      });

      emit(HandleMassage());
    }
  }

  //to select Category
  void _handleSelectedCategory(String category) {
    log(category);
    switch (category) {
      case "home":
        catagoryController.text = "lib/Image/House.png";
        break;
      case "Clothes":
        catagoryController.text = "lib/Image/Clothing-Logo-Vector.png";
        break;
      case "Health care":
        catagoryController.text = "lib/Image/helthcare.jpg";
        break;
      case "Fun":
        catagoryController.text =
            "lib/Image/group-young-friends-having-fun-together-vector-26803087.jpg";
        break;
      case "Travel":
        catagoryController.text =
            "lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg";
        break;
      case "Money Saving":
        catagoryController.text = "lib/Image/logo-template-44-.jpg";
        break;
      case "teaching":
        catagoryController.text = "lib/Image/Teaching.png";
        break;
      case "Food":
        catagoryController.text = "lib/Image/food.jpg";
        break;
      case "Gained money":
        catagoryController.text = "lib/Image/gainMoney.webp";
        break;
      default:
        catagoryController.text = "lib/Image/icon.jpg";
        break;
    }
  }

  String handleCategory(String category) {
    switch (category) {
      case "lib/Image/House.png":
        return "home";
      case "lib/Image/Clothing-Logo-Vector.png":
        return "Clothes";
      case "lib/Image/helthcare.jpg":
        return "Health care";
      case "lib/Image/group-young-friends-having-fun-together-vector-26803087.jpg":
        return "Fun";
      case "lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg":
        return "Travel";
      case "lib/Image/logo-template-44-.jpg":
        return "Money Saving";
      case "lib/Image/Teaching.png":
        return "teaching";
      case "lib/Image/food.jpg":
        return "Food";
      case "lib/Image/gainMoney.webp":
        return "Gained money";
      default:
        return "unknown";
    }
  }
}