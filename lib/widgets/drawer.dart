import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apple_todo/widgets/language_dropdown.dart';
import 'package:apple_todo/providers/todo_provider.dart';
import 'package:apple_todo/utilities/constants.dart';

class MyDrawer extends StatefulWidget {
  final List<Map<String, String>> routineUnfinishedTodoList;
  final List<Map<String, String>> routineFinishedTodoList;

  final List<Map<String, String>> workUnfinishedTodoList;
  final List<Map<String, String>> workFinishedTodoList;

  final List<Map<String, String>> othersUnfinishedTodoList;
  final List<Map<String, String>> othersFinishedTodoList;

  const MyDrawer({
    super.key,
    required this.routineUnfinishedTodoList,
    required this.routineFinishedTodoList,
    required this.workUnfinishedTodoList,
    required this.workFinishedTodoList,
    required this.othersUnfinishedTodoList,
    required this.othersFinishedTodoList,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late SharedPreferences prefs;

  Future<void> _setDarkMode(bool? value) async {
    prefs = await SharedPreferences.getInstance();
    if (value != null) {
      prefs.setBool(sharedPreferencesKeyDarkMode, value);
    }
  }

  int doneNumber(List<Map<String, String>> listByCategory) {
    int num = 0;
    for (int i = 0; i < listByCategory.length; i++) {
      if (listByCategory[i]["isDone"] == "false") {
        num++;
      }
    }
    return num;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff1e1e1e) : Colors.white,
      child: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 40,
                        margin: const EdgeInsets.only(right: 10),
                        child: ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.asset('assets/logo.png'))),
                    Text(
                      "Todo App",
                      style: TextStyle(
                          color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "drawer_by_team_apple".i18n(),
                  style: TextStyle(
                    color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            indent: 12,
            endIndent: 12,
            color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
          ),
          ListTile(
              title: Text(
                "Routine".i18n(),
                style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
              ),
              trailing: Visibility(
                visible: doneNumber(widget.routineUnfinishedTodoList) != 0,
                child: CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  radius: 12,
                  child: Text(
                    doneNumber(widget.routineUnfinishedTodoList).toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )),
          ListTile(
              title: Text(
                "Work".i18n(),
                style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
              ),
              trailing: Visibility(
                visible: doneNumber(widget.workUnfinishedTodoList) != 0,
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  radius: 12,
                  child: Text(
                    doneNumber(widget.workUnfinishedTodoList).toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )),
          ListTile(
              title: Text(
                "Others".i18n(),
                style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
              ),
              trailing: Visibility(
                visible: doneNumber(widget.othersUnfinishedTodoList) != 0,
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  radius: 12,
                  child: Text(
                    doneNumber(widget.othersUnfinishedTodoList).toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )),
          Divider(
            indent: 12,
            endIndent: 12,
            color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
          ),
          ListTile(
            title: Text(
              "setting_dark_mode".i18n(),
              style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
            ),
            trailing: Switch(
              value: context.watch<TodoProvider>().isDark,
              activeColor: Colors.white,
              onChanged: (value) {
                _setDarkMode(value);
                setState(() {
                  context.read<TodoProvider>().setDark = value;
                });
              },
            ),
          ),
          Divider(
            indent: 12,
            endIndent: 12,
            color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
          ),
          const ListTile(title: LanguageDropdown()),
        ],
      ),
    );
  }
}
