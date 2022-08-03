import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_task/module/cuibt/cuibt.dart';
import 'package:my_task/module/cuibt/loginstates.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<layoutCuibt, mytasks>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cuibt = layoutCuibt.get(context);
        var _size = MediaQuery.of(context).size;
        return Container(
          height: _size.height,
          width: _size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/Image/SettingWallpaper.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
              child: Column(
                children:  [
                  const SizedBox(height: 15),
                  ExpansionTile(
                    title: const Text(
                      "dark mode",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.nightlight_round, size: 25),
                    trailing: Switch.adaptive(
                      autofocus: true,
                      value:_cuibt.isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _cuibt.isDarkMode = value;
                        });
                      },
                      splashRadius: 30,
                      activeColor: Colors.teal,
                      activeTrackColor: Colors.grey,

                    ),
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    collapsedTextColor:   Colors.white,
                  ),
                  const SizedBox(height: 15),
                  const ExpansionTile(
                    title: Text(
                      "Language",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(Icons.language, size: 25),
                    textColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                  const SizedBox(height: 15),
                  const ExpansionTile(
                    title: const Text(
                      "Reminder",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading:const Icon(Icons.alarm, size: 25),
                      collapsedIconColor: Colors.white,
                      collapsedTextColor:   Colors.white,
                  ),
                  const SizedBox(height: 15),
                  const ExpansionTile(
                    title: Text(
                      "Settings",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(Icons.settings, size: 25),
                    collapsedIconColor: Colors.white,
                    collapsedTextColor:   Colors.white,
                  ),
                  const SizedBox(height: 15),
                  const ExpansionTile(
                    title: Text(
                      "Settings",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(Icons.settings, size: 25),
                    collapsedIconColor: Colors.white,
                    collapsedTextColor:   Colors.white,
                  ),
                ],
              ),

          ),
        );
      },
    );
  }
}
