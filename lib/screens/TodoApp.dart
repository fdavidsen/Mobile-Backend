import 'package:apple_todo/screens/calendar.dart';
import 'package:apple_todo/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:apple_todo/providers/todo_provider.dart';

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

  PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                ? "Calendar ${DateTime.now().year}"
                : "Profile"),
        centerTitle: true,
        backgroundColor: context.watch<TodoProvider>().isDark ? Color(0xff1e1e1e) : Colors.blue,
      ),
      body: PageView(
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
                padding: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 60),
                height: MediaQuery.of(context).size.height,
                color: context.watch<TodoProvider>().isDark ? Color(0xff1a1a1a) : Color(0xfff0f0f0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Unfinished",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Divider(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: returnUnfinishedTodo()!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: context.watch<TodoProvider>().isDark
                                        ? Color(0xff0e0e0e)
                                        : Colors.white,
                                    child: ExpansionTile(
                                      title: Text(
                                        returnUnfinishedTodo()![index]['title']!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: context.watch<TodoProvider>().isDark
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      subtitle: Text(
                                        "${returnUnfinishedTodo()![index]['mulai']!} - ${returnUnfinishedTodo()![index]['selesai']!}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: context.watch<TodoProvider>().isDark
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      leading: Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: Color(int.parse(
                                              returnUnfinishedTodo()![index]
                                                  ['color']!)), // Your color
                                        ),
                                        child: Checkbox(
                                          value: returnUnfinishedTodo()![index]['isDone']! == "true"
                                              ? true
                                              : false,
                                          activeColor: Color(
                                              int.parse(returnUnfinishedTodo()![index]['color']!)),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 1.0,
                                                color: Color(int.parse(
                                                    returnUnfinishedTodo()![index]['color']!))),
                                          ),
                                          checkColor: Colors.white,
                                          onChanged: (val) {
                                            setState(() {
                                              returnUnfinishedTodo()![index]['isDone'] = "true";
                                            });
                                          },
                                        ),
                                      ),
                                      tilePadding:
                                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      childrenPadding:
                                          EdgeInsets.symmetric(vertical: 10, horizontal: 62),
                                      iconColor: Color(
                                          int.parse(returnUnfinishedTodo()![index]['color']!)),
                                      textColor: context.watch<TodoProvider>().isDark
                                          ? Colors.white
                                          : Colors.black,
                                      collapsedTextColor: context.watch<TodoProvider>().isDark
                                          ? Colors.white
                                          : Colors.black,
                                      collapsedIconColor: Color(
                                          int.parse(returnUnfinishedTodo()![index]['color']!)),
                                      expandedAlignment: Alignment.topLeft,
                                      children: [
                                        Text(
                                          returnUnfinishedTodo()![index]['keterangan']!,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: context.watch<TodoProvider>().isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          }),
                      Text(
                        "Finished",
                        textAlign: TextAlign.start,
                        style: TextStyle(
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
                                    color: context.watch<TodoProvider>().isDark
                                        ? Color(0xff0e0e0e)
                                        : Colors.white,
                                    child: ExpansionTile(
                                      title: Text(
                                        returnFinishedTodo()![index]['title']!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: context.watch<TodoProvider>().isDark
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      subtitle: Text(
                                        "${returnFinishedTodo()![index]['mulai']!} - ${returnFinishedTodo()![index]['selesai']!}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: context.watch<TodoProvider>().isDark
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      leading: Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: Color(int.parse(
                                              returnFinishedTodo()![index]
                                                  ['color']!)), // Your color
                                        ),
                                        child: Checkbox(
                                          value: returnFinishedTodo()![index]['isDone']! == "true"
                                              ? true
                                              : false,
                                          activeColor: Color(
                                              int.parse(returnFinishedTodo()![index]['color']!)),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 1.0,
                                                color: Color(int.parse(
                                                    returnFinishedTodo()![index]['color']!))),
                                          ),
                                          checkColor: Colors.white,
                                          onChanged: (val) {
                                            setState(() {
                                              returnFinishedTodo()![index]['isDone'] = "true";
                                            });
                                          },
                                        ),
                                      ),
                                      tilePadding:
                                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      childrenPadding:
                                          EdgeInsets.symmetric(vertical: 10, horizontal: 62),
                                      iconColor:
                                          Color(int.parse(returnFinishedTodo()![index]['color']!)),
                                      textColor: context.watch<TodoProvider>().isDark
                                          ? Colors.white
                                          : Colors.black,
                                      collapsedTextColor: context.watch<TodoProvider>().isDark
                                          ? Colors.white
                                          : Colors.black,
                                      collapsedIconColor:
                                          Color(int.parse(returnFinishedTodo()![index]['color']!)),
                                      expandedAlignment: Alignment.topLeft,
                                      children: [
                                        Text(
                                          returnFinishedTodo()![index]['keterangan']!,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: context.watch<TodoProvider>().isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          }),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 50,
                color: context.watch<TodoProvider>().isDark ? Color(0xff1a1a1a) : Color(0xfff0f0f0),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text("Routine"),
                      selected: isRoutine,
                      backgroundColor:
                          context.watch<TodoProvider>().isDark ? Color(0xff1a1a1a) : Colors.white,
                      selectedColor: Colors.deepOrange,
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                    SizedBox(width: 10),
                    ChoiceChip(
                      label: Text("Work"),
                      selected: isWork,
                      backgroundColor:
                          context.watch<TodoProvider>().isDark ? Color(0xff1a1a1a) : Colors.white,
                      selectedColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                    SizedBox(width: 10),
                    ChoiceChip(
                      label: Text("Others"),
                      selected: isOthers,
                      backgroundColor:
                          context.watch<TodoProvider>().isDark ? Color(0xff1a1a1a) : Colors.white,
                      selectedColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
          Calendar(),
          Profile()
        ],
      ),
      floatingActionButton: Visibility(
        visible: _selectedIndex != 1,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return AddTodo();
              },
            ));
          },
          child: Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor:
            context.watch<TodoProvider>().isDark ? Color(0xff1a1a1a) : Color(0xfff0f0f0),
        unselectedItemColor: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
        items: [
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
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
      drawer: Drawer(
        backgroundColor: context.watch<TodoProvider>().isDark ? Color(0xff1e1e1e) : Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Todo App",
                style: TextStyle(
                    color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                    fontSize: 48,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                "By: Rivaldi Lubis",
                style: TextStyle(
                  color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 30),
            ListTile(
                title: Text(
                  "Personal",
                  style: TextStyle(
                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
                trailing: Visibility(
                  visible: doneNumber(routineUnfinishedTodoList!) != 0,
                  child: CircleAvatar(
                    child: Text(
                      doneNumber(routineUnfinishedTodoList!).toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    radius: 12,
                  ),
                )),
            ListTile(
                title: Text(
                  "Work",
                  style: TextStyle(
                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
                trailing: Visibility(
                  visible: doneNumber(workUnfinishedTodoList!) != 0,
                  child: CircleAvatar(
                    child: Text(
                      doneNumber(workUnfinishedTodoList!).toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    radius: 12,
                  ),
                )),
            ListTile(
                title: Text(
                  "Others",
                  style: TextStyle(
                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
                trailing: Visibility(
                  visible: doneNumber(othersUnfinishedTodoList!) != 0,
                  child: CircleAvatar(
                    child: Text(
                      doneNumber(othersUnfinishedTodoList!).toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    radius: 12,
                  ),
                )),
            SizedBox(height: 30),
            ListTile(
              title: Text(
                "Dark Mode",
                style: TextStyle(
                    color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
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

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  String value = "Routine";

  TextEditingController kegiatanController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController tglMulaiController = TextEditingController();
  TextEditingController tglSelesaiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        centerTitle: true,
        backgroundColor: context.watch<TodoProvider>().isDark ? Color(0xff1e1e1e) : Colors.blue,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        color: context.watch<TodoProvider>().isDark ? Color(0xff1a1a1a) : Color(0xfff0f0f0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.list_alt_outlined,
                color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
              ),
              title: Text(
                "Kegiatan",
                style: TextStyle(
                    color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
              ),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  controller: kegiatanController,
                  style: TextStyle(
                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    label: Text(
                      "Judul Kegiatan",
                      style: TextStyle(
                          color:
                              context.watch<TodoProvider>().isDark ? Colors.white70 : Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: context.watch<TodoProvider>().isDark
                                ? Colors.white
                                : Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: context.watch<TodoProvider>().isDark
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.list,
                  color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
              title: Text(
                "Keterangan",
                style: TextStyle(
                    color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              height: 100,
              child: TextField(
                controller: keteranganController,
                textAlignVertical: TextAlignVertical.center,
                expands: true,
                maxLines: null,
                style: TextStyle(
                    color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  label: Text(
                    "Tambah Keterangan",
                    style: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white70 : Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: ListTile(
                    leading: Icon(
                      Icons.calendar_month,
                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                    ),
                    title: Text(
                      "Tanggal Mulai",
                      style: TextStyle(
                          color:
                              context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: ListTile(
                    leading: Icon(Icons.calendar_month,
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    title: Text(
                      "Tanggal Selesai",
                      style: TextStyle(
                          color:
                              context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: TextField(
                    controller: tglMulaiController,
                    style: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      label: Text(
                        'input tanggal mulai',
                        style: TextStyle(
                            color: context.watch<TodoProvider>().isDark
                                ? Colors.white70
                                : Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: context.watch<TodoProvider>().isDark
                                  ? Colors.white
                                  : Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: context.watch<TodoProvider>().isDark
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                    onTap: () async {
                      var selectedDate = DateTime.now();
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        initialDatePickerMode: DatePickerMode.day,
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2101),
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                                dialogBackgroundColor: context.watch<TodoProvider>().isDark
                                    ? Color(0xff0e0e0e)
                                    : Colors.white,
                                colorScheme: context.watch<TodoProvider>().isDark
                                    ? ColorScheme.dark(
                                        onSurface: Colors.white,
                                        primary: Colors.blue,
                                      )
                                    : ColorScheme.light(
                                        onSurface: Colors.black,
                                        primary: Colors.blue,
                                      )),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                          tglMulaiController.text = DateFormat("dd MMM yyyy").format(selectedDate);
                        });
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: TextField(
                    controller: tglSelesaiController,
                    style: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      label: Text(
                        'input tanggal selesai',
                        style: TextStyle(
                            color: context.watch<TodoProvider>().isDark
                                ? Colors.white70
                                : Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: context.watch<TodoProvider>().isDark
                                  ? Colors.white
                                  : Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: context.watch<TodoProvider>().isDark
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                    onTap: () async {
                      var selectedDate = DateTime.now();
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        initialDatePickerMode: DatePickerMode.day,
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2101),
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                                dialogBackgroundColor: context.watch<TodoProvider>().isDark
                                    ? Color(0xff0e0e0e)
                                    : Colors.white,
                                colorScheme: context.watch<TodoProvider>().isDark
                                    ? ColorScheme.dark(
                                        onSurface: Colors.white,
                                        primary: Colors.blue,
                                      )
                                    : ColorScheme.light(
                                        onSurface: Colors.black,
                                        primary: Colors.blue,
                                      )),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                          tglSelesaiController.text =
                              DateFormat("dd MMM yyyy").format(selectedDate);
                        });
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            ListTile(
              leading: Icon(
                Icons.list_alt_outlined,
                color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
              ),
              title: Text(
                "Kegiatan",
                style: TextStyle(
                    color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
              ),
              trailing: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: DropdownButton(
                      dropdownColor:
                          context.watch<TodoProvider>().isDark ? Colors.black : Colors.white,
                      value: value,
                      items: [
                        DropdownMenuItem(
                            value: "Routine",
                            child: Text(
                              "Routine",
                              style: TextStyle(
                                  color: context.watch<TodoProvider>().isDark
                                      ? Colors.white
                                      : Colors.black),
                            )),
                        DropdownMenuItem(
                            value: "Work",
                            child: Text(
                              "Work",
                              style: TextStyle(
                                  color: context.watch<TodoProvider>().isDark
                                      ? Colors.white
                                      : Colors.black),
                            )),
                        DropdownMenuItem(
                            value: "Others",
                            child: Text(
                              "Others",
                              style: TextStyle(
                                  color: context.watch<TodoProvider>().isDark
                                      ? Colors.white
                                      : Colors.black),
                            )),
                      ],
                      onChanged: (val) {
                        setState(() {
                          value = val.toString();
                        });
                      })),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: OutlinedButton(
                      child: Text("Batal"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          side: BorderSide(
                              color: context.watch<TodoProvider>().isDark
                                  ? Colors.white
                                  : Colors.blue)),
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: ElevatedButton(
                      child: Text("Simpan"),
                      onPressed: () {
                        setState(() {
                          context.read<TodoProvider>().isiTodo = {
                            'title': kegiatanController.text,
                            'keterangan': keteranganController.text,
                            'mulai': tglMulaiController.text,
                            'selesai': tglSelesaiController.text,
                            'isDisplayed': "false",
                            'isDone': "false",
                            'kategori': value.toString(),
                            'color': value.toString() == "Routine"
                                ? "0xffff5722"
                                : value.toString() == "Work"
                                    ? "0xff2196f3"
                                    : "0xff4caf50"
                          };
                          Navigator.of(context).pop();
                        });
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: context.watch<TodoProvider>().isDark
                                    ? Color(0xff0e0e0e)
                                    : Colors.white,
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                child: Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 180,
                                      width: 250,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(5, 50, 5, 5),
                                        child: Column(
                                          children: [
                                            Text("Berhasil",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: !context.watch<TodoProvider>().isDark
                                                        ? Color(0xff0e0e0e)
                                                        : Colors.white),
                                                textAlign: TextAlign.center),
                                            SizedBox(height: 10),
                                            Text("Kegiatan berhasil ditambahkan",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: !context.watch<TodoProvider>().isDark
                                                        ? Color(0xff0e0e0e)
                                                        : Colors.white),
                                                textAlign: TextAlign.center),
                                            SizedBox(height: 20),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("OK"),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15, horizontal: 35)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: -45,
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundColor: context.watch<TodoProvider>().isDark
                                              ? Color(0xff0e0e0e)
                                              : Colors.white,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            radius: 35,
                                            child: Icon(Icons.check, size: 40, color: Colors.white),
                                          ),
                                        )),
                                  ],
                                ),
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
