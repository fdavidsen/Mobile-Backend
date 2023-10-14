import 'dart:async';

import 'package:apple_todo/models/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apple_todo/screens/todo/add_todo.dart';
import 'package:apple_todo/screens/calendar.dart';
import 'package:apple_todo/screens/profile.dart';
import 'package:apple_todo/providers/todo_provider.dart';
import 'package:quickalert/quickalert.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRoutine = false;
  bool isWork = false;
  bool isOthers = false;

  bool displayAll = true;
  bool displayFinished = false;
  bool displayUnfinished = false;

  int _selectedIndex = 0;

  List<Map<String, String>>? allFinishedTodoList;
  List<Map<String, String>>? routineFinishedTodoList;
  List<Map<String, String>>? workFinishedTodoList;
  List<Map<String, String>>? othersFinishedTodoList;

  List<Map<String, String>>? allUnfinishedTodoList;
  List<Map<String, String>>? routineUnfinishedTodoList;
  List<Map<String, String>>? workUnfinishedTodoList;
  List<Map<String, String>>? othersUnfinishedTodoList;

  bool _dbIsLoaded = false;
  final DBManager _dbManager = DBManager();

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_dbIsLoaded) {
      Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (_dbManager.db != null) {
          context.read<TodoProvider>().setAllTodo = await _dbManager.getAllTodo();
          _dbIsLoaded = true;
          timer.cancel();
        }
      });
    }

    allUnfinishedTodoList = context.watch<TodoProvider>().filteredItems("", false);
    routineUnfinishedTodoList = context.watch<TodoProvider>().filteredItems("Routine", false);
    workUnfinishedTodoList = context.watch<TodoProvider>().filteredItems("Work", false);
    othersUnfinishedTodoList = context.watch<TodoProvider>().filteredItems("Others", false);

    allFinishedTodoList = context.watch<TodoProvider>().filteredItems("", true);
    routineFinishedTodoList = context.watch<TodoProvider>().filteredItems("Routine", true);
    workFinishedTodoList = context.watch<TodoProvider>().filteredItems("Work", true);
    othersFinishedTodoList = context.watch<TodoProvider>().filteredItems("Others", true);

    List<Map<String, String>>? returnFinishedTodo() {
      if (isRoutine && !isWork && !isOthers) {
        return routineFinishedTodoList;
      } else if (isWork && !isRoutine && !isOthers) {
        return workFinishedTodoList;
      } else if (isOthers && !isRoutine && !isWork) {
        return othersFinishedTodoList;
      } else {
        return allFinishedTodoList;
      }
    }

    List<Map<String, String>>? returnUnfinishedTodo() {
      if (isRoutine && !isWork && !isOthers) {
        return routineUnfinishedTodoList;
      } else if (isWork && !isRoutine && !isOthers) {
        return workUnfinishedTodoList;
      } else if (isOthers && !isRoutine && !isWork) {
        return othersUnfinishedTodoList;
      } else {
        return allUnfinishedTodoList;
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0
            ? "Todos"
            : _selectedIndex == 1
                ? "My Events"
                : "Profile"),
        centerTitle: true,
        backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff1e1e1e) : Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    title: 'Hapus semua task?',
                    confirmBtnText: 'Hapus',
                    cancelBtnText: 'Tutup',
                    showCancelBtn: true,
                    onConfirmBtnTap: () {
                      _dbManager.deleteAllTodo();
                      context.read<TodoProvider>().deleteAllTodo();
                      Navigator.pop(context);
                    });
              },
              icon: const Icon(Icons.delete_forever_outlined))
        ],
      ),
      body: Container(
        color: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : const Color(0xfff0f0f0),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 60),
                  color: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : const Color(0xfff0f0f0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(children: [
                          (returnFinishedTodo()!.isEmpty && returnUnfinishedTodo()!.isNotEmpty) || returnFinishedTodo()!.isNotEmpty
                              ? Column(
                                  children: [
                                    Text("Ongoing",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontSize: 18, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                                    Divider(
                                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                                    )
                                  ],
                                )
                              : Container(),
                          returnUnfinishedTodo()!.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: returnUnfinishedTodo()!.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            color: context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white,
                                            child: ExpansionTile(
                                              title: Text(
                                                returnUnfinishedTodo()![index]['title']!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                              ),
                                              subtitle: Text(
                                                "${returnUnfinishedTodo()![index]['mulai']!} - ${returnUnfinishedTodo()![index]['selesai']!}",
                                                style: TextStyle(
                                                    fontSize: 12, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                              ),
                                              leading: Theme(
                                                data: ThemeData(
                                                  unselectedWidgetColor: Color(int.parse(returnUnfinishedTodo()![index]['color']!)), // Your color
                                                ),
                                                child: Checkbox(
                                                  value: returnUnfinishedTodo()![index]['isDone']! == "true" ? true : false,
                                                  activeColor: Color(int.parse(returnUnfinishedTodo()![index]['color']!)),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 1.0, color: Color(int.parse(returnUnfinishedTodo()![index]['color']!))),
                                                  ),
                                                  checkColor: Colors.white,
                                                  onChanged: (val) {
                                                    _dbManager.setTaskAsDone(returnUnfinishedTodo()![index]['id']!);
                                                    setState(() {
                                                      returnUnfinishedTodo()![index]['isDone'] = "true";
                                                    });
                                                  },
                                                ),
                                              ),
                                              tilePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                              childrenPadding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 25),
                                              iconColor: Color(int.parse(returnUnfinishedTodo()![index]['color']!)),
                                              textColor: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                                              collapsedTextColor: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                                              collapsedIconColor: Color(int.parse(returnUnfinishedTodo()![index]['color']!)),
                                              expandedAlignment: Alignment.topLeft,
                                              children: [
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        IconButton(
                                                          color: Colors.green,
                                                          icon: const Icon(Icons.edit),
                                                          onPressed: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                              return AddTodo(isAddNew: false, data: returnUnfinishedTodo()![index]);
                                                            }));
                                                          },
                                                        ),
                                                        IconButton(
                                                          color: Colors.red,
                                                          icon: const Icon(Icons.delete),
                                                          onPressed: () {
                                                            QuickAlert.show(
                                                                context: context,
                                                                type: QuickAlertType.warning,
                                                                title: 'Hapus task ini?',
                                                                confirmBtnText: 'Hapus',
                                                                cancelBtnText: 'Tutup',
                                                                showCancelBtn: true,
                                                                onConfirmBtnTap: () {
                                                                  String id = returnUnfinishedTodo()![index]['id']!;
                                                                  _dbManager.deleteTodo(id);
                                                                  context.read<TodoProvider>().deleteTodo(id);
                                                                  Navigator.pop(context);
                                                                });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 20),
                                                      child: Text(
                                                        returnUnfinishedTodo()![index]['keterangan']!,
                                                        textAlign: TextAlign.justify,
                                                        style: TextStyle(
                                                            fontSize: 14, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10)
                                      ],
                                    );
                                  })
                              : returnFinishedTodo()!.isNotEmpty
                                  ? Column(
                                      children: [
                                        Container(width: 200, margin: const EdgeInsets.only(bottom: 10), child: Image.asset('assets/done.png')),
                                        Text('Semua task sudah selesai',
                                            style: TextStyle(fontSize: 12, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black))
                                      ],
                                    )
                                  : Container(),
                        ]),
                        const SizedBox(height: 40),
                        returnFinishedTodo()!.isNotEmpty
                            ? Column(children: [
                                Text(
                                  "Finished",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                Divider(
                                  color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: returnFinishedTodo()!.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              color: context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white,
                                              child: ExpansionTile(
                                                title: Text(
                                                  returnFinishedTodo()![index]['title']!,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                                ),
                                                subtitle: Text(
                                                  "${returnFinishedTodo()![index]['mulai']!} - ${returnFinishedTodo()![index]['selesai']!}",
                                                  style: TextStyle(
                                                      fontSize: 12, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                                ),
                                                leading: Theme(
                                                  data: ThemeData(
                                                    unselectedWidgetColor: Color(int.parse(returnFinishedTodo()![index]['color']!)), // Your color
                                                  ),
                                                  child: Checkbox(
                                                    value: returnFinishedTodo()![index]['isDone']! == "true" ? true : false,
                                                    activeColor: Color(int.parse(returnFinishedTodo()![index]['color']!)),
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(width: 1.0, color: Color(int.parse(returnFinishedTodo()![index]['color']!))),
                                                    ),
                                                    checkColor: Colors.white,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        returnFinishedTodo()![index]['isDone'] = "true";
                                                      });
                                                    },
                                                  ),
                                                ),
                                                tilePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                childrenPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                                iconColor: Color(int.parse(returnFinishedTodo()![index]['color']!)),
                                                textColor: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                                                collapsedTextColor: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                                                collapsedIconColor: Color(int.parse(returnFinishedTodo()![index]['color']!)),
                                                expandedAlignment: Alignment.topLeft,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          IconButton(
                                                            color: Colors.red,
                                                            icon: const Icon(Icons.delete),
                                                            onPressed: () {
                                                              QuickAlert.show(
                                                                  context: context,
                                                                  type: QuickAlertType.warning,
                                                                  title: 'Hapus task ini?',
                                                                  confirmBtnText: 'Hapus',
                                                                  cancelBtnText: 'Tutup',
                                                                  showCancelBtn: true,
                                                                  onConfirmBtnTap: () {
                                                                    String id = returnFinishedTodo()![index]['id']!;
                                                                    _dbManager.deleteTodo(id);
                                                                    context.read<TodoProvider>().deleteTodo(id);
                                                                    Navigator.pop(context);
                                                                  });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        returnFinishedTodo()![index]['keterangan']!,
                                                        textAlign: TextAlign.justify,
                                                        style: TextStyle(
                                                            fontSize: 14, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      );
                                    }),
                              ])
                            : Container(),
                        returnUnfinishedTodo()!.isEmpty && returnFinishedTodo()!.isEmpty
                            ? Column(
                                children: [
                                  Container(width: 200, margin: const EdgeInsets.only(bottom: 20), child: Image.asset('assets/no-task.png')),
                                  Text('Tidak ada task',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black))
                                ],
                              )
                            : Container(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 50,
                  color: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : const Color(0xfff0f0f0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text("Routine"),
                        selected: isRoutine,
                        backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : Colors.white,
                        selectedColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        side: BorderSide(color: isRoutine ? Colors.white : Colors.deepOrange),
                        labelStyle: TextStyle(color: isRoutine ? Colors.white : Colors.deepOrange),
                        onSelected: (bool val) {
                          setState(() {
                            isRoutine = val;
                            isWork = false;
                            isOthers = false;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("Work"),
                        selected: isWork,
                        backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : Colors.white,
                        selectedColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        side: BorderSide(color: isWork ? Colors.white : Colors.blue),
                        labelStyle: TextStyle(color: isWork ? Colors.white : Colors.blue),
                        onSelected: (bool val) {
                          setState(() {
                            isRoutine = false;
                            isWork = val;
                            isOthers = false;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("Others"),
                        selected: isOthers,
                        backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : Colors.white,
                        selectedColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        side: BorderSide(color: isOthers ? Colors.white : Colors.green),
                        labelStyle: TextStyle(color: isOthers ? Colors.white : Colors.green),
                        onSelected: (bool val) {
                          setState(() {
                            isRoutine = false;
                            isWork = false;
                            isOthers = val;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Calendar(),
            const Profile()
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: _selectedIndex != 1,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const AddTodo(isAddNew: true);
              },
            ));
          },
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : const Color(0xfff0f0f0),
        unselectedItemColor: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Todos",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
      drawer: Drawer(
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
                    "by Tim Apple",
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
                  "Personal",
                  style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
                trailing: Visibility(
                  visible: doneNumber(routineUnfinishedTodoList!) != 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    radius: 12,
                    child: Text(
                      doneNumber(routineUnfinishedTodoList!).toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                )),
            ListTile(
                title: Text(
                  "Work",
                  style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
                trailing: Visibility(
                  visible: doneNumber(workUnfinishedTodoList!) != 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    radius: 12,
                    child: Text(
                      doneNumber(workUnfinishedTodoList!).toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                )),
            ListTile(
                title: Text(
                  "Others",
                  style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
                trailing: Visibility(
                  visible: doneNumber(othersUnfinishedTodoList!) != 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    radius: 12,
                    child: Text(
                      doneNumber(othersUnfinishedTodoList!).toString(),
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
                "Dark Mode",
                style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
              ),
              trailing: Switch(
                value: context.watch<TodoProvider>().isDark,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    context.read<TodoProvider>().setDark = value;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
