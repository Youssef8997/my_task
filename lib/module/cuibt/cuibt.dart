import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/Componads/Com.dart';
import 'package:my_task/Model/Model.dart';
import 'package:my_task/Translition/locale_kays.g.dart';
import 'package:my_task/lib/sherdeprefrence/sherdhelp.dart';
import 'package:my_task/module/AddTasks/AddTasks.dart';
import 'package:my_task/module/MoneyOrganiz/MoneyOrganiz.dart';
import 'package:my_task/module/MyTasks/MyTasks.dart';
import 'package:my_task/module/Setting/Settings.dart';
import 'package:my_task/module/cuibt/loginstates.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Analytics/Analytics.dart';

class layoutCuibt extends Cubit<mytasks> {
  layoutCuibt() : super(mytasksstateinisal());

  static layoutCuibt get(context) => BlocProvider.of(context);
  var MyIndex = 0;
  late Database datab;
  List<Map> tasks = [];
  List<Map> task = [];
  List<Map> budget = [];
  var controllerChat = ScrollController();
  String category = "Gained money";
  var dialogFormKey = GlobalKey<FormState>();
  bool taskReminder = true;
  bool moneyReminder = true;

  // massage which will be send from the robot
  List<RobotChatModel> robotResponded = [
    RobotChatModel(LocaleKeys.firstMassage.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.hiuser.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.Imgreat.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.ImjoeRobot.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.letsgo.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.whatTitleChat.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.okaygreat.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.whatDescriptionChat.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.whatTimeChat.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel("do you wanna repeat it ", "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.whatDateChat.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.howMuchPay.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.WhyPayMoney.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.whichCategories.tr(), "Robot",
        DateFormat('hh:mm').format(DateTime.now())),
    RobotChatModel(LocaleKeys.whenPay.tr(), "Robot",
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
  var repeated = "Never";
  var priorityed = "low";
  var Weekday = 1;
  var id = 1;
  var onDate = DateFormat.yMMMd().format(DateTime.now());
  var titleController = TextEditingController();
  var descController = TextEditingController();
  var catagoryController = TextEditingController();
  var dataController = TextEditingController();
  var moneyController = TextEditingController();
  var salaryController = TextEditingController();
  bool changeIncome = false;
  var controller = PageController(initialPage: 0);
  List body = [
    const HomeTasks(),
    moneyOraganize(),
    analytics(),
    const Settings(),
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
      sherdprefrence.setdate(key: "ResetBudget", value: true);
      print("create data base");
      datab.execute(
            'CREATE TABLE TASKS (id INTEGER PRIMARY KEY,title TEXT,desc TEXT,data TEXT ,time STRING,repeat TEXT,priority TEXT,WeekDay TEXT)');
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
      onDate = DateFormat.yMMMd("en").format(DateTime.now());
      insertTaskIntoVar("Never", datab: datab);
      insertBudgetIntoVar(datab: datab);
    });
  }

  //get All tasks from Database
  Future<List<Map>> getDataTasks(datab) async {
    return await datab.rawQuery('SELECT*FROM TASKS');
  }

  //get Specific Task from Database
  Future<List<Map>> getTask(datab, id) async {
    return await datab.rawQuery('SELECT*FROM TASKS WHERE id=?', [id]);
  }

  //get all Tasks in the specific date from Database
  Future<List<Map>> getTasksDays(datab) async {
    return await datab.rawQuery(
        'SELECT*FROM TASKS WHERE data=? AND repeat=?', [onDate, "Never"]);
  }

  //get all Tasks which repeatedly every week from Database
  Future<List<Map>> getTasksWeekly(datab) async {
    return await datab.rawQuery('SELECT*FROM TASKS WHERE repeat=?', ["Weekly"]);
  }

  Future<List<Map>> getTasksDaily(datab) async {
    return await datab.rawQuery('SELECT*FROM TASKS WHERE repeat=? ', ["Daily"]);
  }

  //get all Tasks which repeatedly every month from Database
  Future<List<Map>> getTasksMonthly(datab) async {
    return await datab
        .rawQuery('SELECT*FROM TASKS WHERE repeat=?', ["Monthly"]);
  }

// to insert task into List Which will be used in the HomeTasks page
  void insertTaskIntoVar(repeat, {datab}) {
    if (repeat == "Weekly") {
      getTasksWeekly(datab).then((value) {
        tasks = [];
        tasks = value;
        emit(GetTasksSucssesful());
      });
    } else if (repeat == "daily") {
      getTasksDaily(datab).then((value) {
        tasks = [];
        tasks = value;
        emit(GetTasksSucssesful());
      });
    } else if (repeat == "Monthly") {
      getTasksMonthly(datab).then((value) {
        tasks = [];
        tasks = value;
        emit(GetTasksSucssesful());
      });
    } else if (repeat == "Never") {
      getTasksDays(datab).then((value) {
        tasks = [];
        tasks = value;
        print("tasks is ${tasks.toString()}");
        emit(GetTasksSucssesful());
      });
    }
  }

  Future<List<Map>> getAllDataBudget(datab) async {
    return await datab.rawQuery('SELECT*FROM BUDGET');
  }

  //get all Budget in the specific date from Database
  Future<List<Map>> getDataBudget(datab) async {
    return await datab.rawQuery('SELECT*FROM BUDGET WHERE data=?', [onDate]);
  }

  void insertBudgetIntoVar({datab, context}) {
    getDataBudget(datab).then((value) {
      budget = [];
      budget = value;
      emit(getsallaryafter());
    });
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
    getAllDataBudget(datab).then((value) {
      budget = [];
      budget = value;
      print(budget);
      emit(getsallaryafter());
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
              'INSERT INTO TASKS(title,desc,time,data,repeat,priority,WeekDay)VALUES("$title","$desc","$time","$date","$repeat","$priority","$Weekday")')
          .then((Id) {
        //to be can get the id of the task to make notification when the insert is done
        id = Id;
        insertTaskIntoVar(repeat, datab: datab);
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
          changPercent(salaryAfter + money);
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
          changPercent(salaryAfter - money);
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
      {String? priority,
      String? repeat,
      int id = 1,
      Time,
      Date,
      Title,
      Des}) async {
    datab.rawUpdate('UPDATE TASKS SET repeat=? WHERE id=? ', [repeat, id]);
    datab.rawUpdate('UPDATE TASKS SET priority=? WHERE id=? ', [priority, id]);
    datab.rawUpdate('UPDATE TASKS SET time=? WHERE id=? ', [Time, id]);
    datab.rawUpdate('UPDATE TASKS SET data=? WHERE id=? ', [Date, id]).then(
        (value) {
      getTask(datab, id).then((value) {
        title.text = value[0]["title"];
        desc.text = value[0]["desc"];
        time.text = value[0]["time"].toString();
        date.text = value[0]["data"].toString();
        repeated = value[0]["repeat"];
        priorityed = value[0]["priority"];
        AwesomeNotifications().cancel(id);
        AwesomeNotifications().cancelSchedule(id).then((_) {
          _handleNotification(value.first["repeat"], id);
        });
      });
      getDataTasksAfterChange();
      emit(UpdateDataBaseError());
    });
  }

  //delete task from database
  void delete({required int id, required rpeted}) async {
    await datab.rawDelete('DELETE FROM TASKS WHERE id=? ', [id]);
    AwesomeNotifications().cancel(id);
    AwesomeNotifications().cancelSchedule(id);
    insertTaskIntoVar(rpeted, datab: datab);
    emit(DeleteDataBaseSucssesful());
  }

  void deletebudget({required int id, required index}) async {
    await datab.rawDelete('DELETE FROM BUDGET WHERE id=? ', [id]);
    getAllDataBudget(datab).then((value) {
      budget = [];
      budget = value;
      print(budget);
      changPercent(budget.isEmpty ? salary : budget[index - 1]["MONEYAfter"]);
      emit(getsallaryafter());
    });
  }
  String handleWeekDays(String WeekDay){
    switch(WeekDay){
      case "7":
        return "Sunday";
      case "1":
        return "Monday";
      case "2":
        return "Tuesday";
      case "3":
        return "Wednesday";
      case "4":
        return "Thursday";
      case "5":
        return "Friday";
      case "6":
        return "Saturday";
      default:
        return "unknown";
    }
  }
  //change value of repeat step
  void changevaluerepeat(
    value,
  ) {
    repeated = value;
    emit(ChangeMyvaluerepet());
  }

  void changeValueWeekDay(
    value,
  ) {
    Weekday = value;
    emit(ChangeMyvaluerepet());
  }

  //change value of repeat priory
  void changevaluepri(
    value,
  ) {
    priorityed = value;
    emit(ChangeMyvaluepri());
  }

  //method to press continue in step and insert task in database
  void onPressedContinue(context,
      {notification = false, myInterstitial}) async {
    if (currentStep < 4) {
      currentStep += 1;
      emit(OnPressedonStepper());
    } else {
      insert(
              title: title.text,
              desc: desc.text,
              time: time.text,
              date: date.text,
              repeat: repeated,
              priority: priorityed)
          .then((value) {
        _handleNotification(repeated, id);
        if (myInterstitial != null) {
          myInterstitial.show();
        }
      });

      if (notification == false) {
        Navigator.pop(context);
      }
      emit(OnPressedonStepper());
    }
  }

  void pressedContinueEdit(
      {context, id, priority, repeat, myInterstitial}) async {
    if (currentStep < 5) {
      currentStep += 1;
      emit(OnPressedonStepper());
    } else {
      update(
        id: id,
        priority: priorityed,
        repeat: repeated,
        Date: date.text,
        Time: time.text,
        Title: title.text,
        Des: desc.text,
      );
      currentStep = 0;
      time.clear();
      date.clear();
      Navigator.pop(context);
      if (myInterstitial != null) {
        myInterstitial.show();
      }
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

  void changPercent(value) {
    salaryAfter = double.parse(value.toString());
    emit(getsallaryafter());
  }

  void setSalary(value) {
    sherdprefrence.setdate(key: "salary", value: double.parse(value));
    salary = double.parse(value);
    salaryAfter = double.parse(value);

    salaryController.clear();
    print("salary is $salary and salary after is $salaryAfter");
    emit(getsallary());
  }

  void Catogerye(value) {
    catagoryController.text = "$value";
    emit(changeCatogery());
  }

  void budgetDate(value) {
    dataController.text = DateFormat.yMMMd("en").format(value!);
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
    if (time.split(":")[1].split(" ")[1] == "PM"||time.split(":")[1].split(" ")[1] == "م") {
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
        repeated = robotChat[robotChat.length - 1].massage;
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
            money: double.tryParse(moneyController.text) ?? 0.0,
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
    if (category == LocaleKeys.Home.tr()) {
      catagoryController.text = "lib/Image/House.png";
    } else if (category == LocaleKeys.clothes.tr()) {
      catagoryController.text = "lib/Image/Clothing-Logo-Vector.png";
    } else if (category == LocaleKeys.Healthcare.tr()) {
      catagoryController.text = "lib/Image/helthcare.jpg";
    } else if (category == LocaleKeys.Fun.tr()) {
      catagoryController.text =
          "lib/Image/group-young-friends-having-fun-together-vector-26803087.jpg";
    } else if (category == LocaleKeys.Travel.tr()) {
      catagoryController.text =
          "lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg";
    } else if (category == LocaleKeys.MoneySaving.tr()) {
      catagoryController.text = "lib/Image/logo-template-44-.jpg";
    } else if (category == LocaleKeys.Teaching.tr()) {
      catagoryController.text = "lib/Image/Teaching.png";
    } else if (category == LocaleKeys.food.tr()) {
      catagoryController.text = "lib/Image/food.jpg";
    } else if (category == LocaleKeys.GainedMoney.tr()) {
      catagoryController.text = "lib/Image/gainMoney.webp";
    } else {
      catagoryController.text = "lib/Image/House.png";
    }
  }

  String handleCategory(String category) {
    switch (category) {
      case "lib/Image/House.png":
        return LocaleKeys.Home.tr();
      case "lib/Image/Clothing-Logo-Vector.png":
        return LocaleKeys.clothes.tr();
      case "lib/Image/helthcare.jpg":
        return LocaleKeys.Healthcare.tr();
      case "lib/Image/group-young-friends-having-fun-together-vector-26803087.jpg":
        return LocaleKeys.Fun.tr();
      case "lib/Image/travel-logo-vector-illustration-black-airplane-isolated-white-115729130.jpg":
        return LocaleKeys.Travel.tr();
      case "lib/Image/logo-template-44-.jpg":
        return LocaleKeys.MoneySaving.tr();
      case "lib/Image/Teaching.png":
        return LocaleKeys.Teaching.tr();
      case "lib/Image/food.jpg":
        return LocaleKeys.food.tr();
      case "lib/Image/gainMoney.webp":
        return LocaleKeys.GainedMoney.tr();
      default:
        return "unknown";
    }
  }

  void cancelTaskReminder(value) {
    taskReminder = value;
    if (taskReminder == false) {
      AwesomeNotifications().cancel(2 * 6000);
      AwesomeNotifications().cancelSchedule(2 * 6000);
    } else {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            channelKey: 'chatBoot',
            id: 2 * 6000,
            title: 'do you have a New task?',
            notificationLayout: NotificationLayout.BigText,
          ),
          actionButtons: [
            NotificationActionButton(
              color: Colors.grey,
              key: 'sendMassage',
              label: 'Go to chat',
            ),
          ],
          schedule: NotificationInterval(
            interval: 21600,
            preciseAlarm: true,
            allowWhileIdle: true,
            repeats: true,
          ));
    }
    emit(CancelTasksRemind());
  }

  void cancelMoneyReminder(value) {
    moneyReminder = value;
    if (moneyReminder == false) {
      AwesomeNotifications().cancel(2 * 700);
      AwesomeNotifications().cancelSchedule(2 * 700);
    } else {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            channelKey: 'Budget',
            id: 2 * 700,
            title: 'Have you spent anything recently?',
            fullScreenIntent: true,
            notificationLayout: NotificationLayout.BigText,
          ),
          actionButtons: [
            NotificationActionButton(
              color: Colors.grey,
              key: 'transaction',
              label: 'Record the transaction',
            ),
          ],
          schedule: NotificationInterval(
            interval: 21700,
            preciseAlarm: true,
            allowWhileIdle: true,
            repeats: true,
          ));
    }
    emit(CancelMoneyRemind());
  }

  void changeLocale(BuildContext context, language) {
    context.setLocale(language);
    emit(ChangeLocale());
  }

  void _handleNotification(String Repeat, id) async {
    log("${Repeat} ${id}");
    //handle Time resource
    int year = int.parse(date.text.split(", ")[1]);
    int month = _convertNameMonthToNumber(date.text.substring(0, 3));
    int day = int.parse(date.text.split(" ")[1].split(",")[0]);
    int hour = _convertHourWhenPm(time.text);
    int minute = int.parse(time.text.split(":")[1].split(" ")[0]);
    print("${hour} ${minute}");
    //to increase the badge number
    await AwesomeNotifications().getGlobalBadgeCounter().then(
        (badge) => AwesomeNotifications().setGlobalBadgeCounter(badge + 1));
    if (Repeat == "Daily") {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
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
          schedule: NotificationCalendar(
            allowWhileIdle: true,
            repeats: true,
            preciseAlarm: true,
            hour: hour,
            minute: minute,
            second: 00,
          ));
    }
    else if (Repeat == "Weekly") {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
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
          schedule: NotificationCalendar(
            repeats: true,
            allowWhileIdle: true,
            preciseAlarm: true,
            weekday: Weekday,
            hour: hour,
            minute: minute,
            second: 00,
          ));
    }
    else if (Repeat == "Monthly") {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
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
          schedule: NotificationCalendar(
            repeats: true,
            allowWhileIdle: true,
            preciseAlarm: true,
            day: day,
            hour: hour,
            minute: minute,
            second: 00,
          ));
    }
    else if (Repeat == "Never") {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
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
    }
    currentStep = 0;
    title.clear();
    desc.clear();
    time.clear();
    date.clear();
  }

  void faceBook() async {
    var url = 'fb://facewebmodal/f?href=https://www.facebook.com/yuossfa';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalNonBrowserApplication);
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  void instagram() async {
    var url = "instagram://user?username=_youssef_ahmed44";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalNonBrowserApplication);
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }


}
