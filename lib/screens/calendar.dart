import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:apple_todo/providers/todo_provider.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  TextEditingController judulController = TextEditingController();
  TextEditingController additionalController = TextEditingController();
  TextEditingController tglMulaiController = TextEditingController();
  TextEditingController tglSelesaiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.watch<TodoProvider>().isDark ? Color(0xff1a1a1a) : Color(0xfff0f0f0),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            children: [
              TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime(1900, 1, 1),
                lastDay: DateTime(2100, 12, 31),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  titleTextStyle: TextStyle(
                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                  leftChevronIcon: Icon(Icons.navigate_before,
                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                  rightChevronIcon: Icon(Icons.navigate_next,
                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
                calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    todayTextStyle: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    weekendTextStyle: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    todayDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                  weekendStyle: TextStyle(
                      color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Event",
                      style: TextStyle(
                          color:
                              context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: context.watch<TodoProvider>().isDark
                                    ? Color(0xff0e0e0e)
                                    : Colors.white,
                                content: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        child: TextField(
                                          controller: judulController,
                                          style: TextStyle(
                                              color: context.watch<TodoProvider>().isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                          decoration: InputDecoration(
                                            label: Text(
                                              'Nama Event',
                                              style: TextStyle(
                                                  color: context.watch<TodoProvider>().isDark
                                                      ? Colors.white
                                                      : Colors.black),
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
                                      SizedBox(height: 16),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        child: TextField(
                                          controller: additionalController,
                                          style: TextStyle(
                                              color: context.watch<TodoProvider>().isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                          decoration: InputDecoration(
                                            label: Text(
                                              'Keterangan tambahan',
                                              style: TextStyle(
                                                  color: context.watch<TodoProvider>().isDark
                                                      ? Colors.white
                                                      : Colors.black),
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
                                      SizedBox(height: 16),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        child: TextField(
                                          controller: tglMulaiController,
                                          style: TextStyle(
                                              color: context.watch<TodoProvider>().isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                          decoration: InputDecoration(
                                            label: Text(
                                              'Tanggal mulai',
                                              style: TextStyle(
                                                  color: context.watch<TodoProvider>().isDark
                                                      ? Colors.white
                                                      : Colors.black),
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
                                                      dialogBackgroundColor:
                                                          context.watch<TodoProvider>().isDark
                                                              ? Color(0xff0e0e0e)
                                                              : Colors.white,
                                                      colorScheme:
                                                          context.watch<TodoProvider>().isDark
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
                                                tglMulaiController.text =
                                                    DateFormat("dd MMM yyyy").format(selectedDate);
                                              });
                                            }
                                            FocusManager.instance.primaryFocus?.unfocus();
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        child: TextField(
                                          controller: tglSelesaiController,
                                          style: TextStyle(
                                              color: context.watch<TodoProvider>().isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                          decoration: InputDecoration(
                                            label: Text(
                                              'Tanggal selesai',
                                              style: TextStyle(
                                                  color: context.watch<TodoProvider>().isDark
                                                      ? Colors.white
                                                      : Colors.black),
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
                                                      dialogBackgroundColor:
                                                          context.watch<TodoProvider>().isDark
                                                              ? Color(0xff0e0e0e)
                                                              : Colors.white,
                                                      colorScheme:
                                                          context.watch<TodoProvider>().isDark
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
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("CANCEL", style: TextStyle(color: Colors.grey))),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          context.read<TodoProvider>().isiEvent = EventTime(
                                              judulController.text,
                                              additionalController.text,
                                              tglMulaiController.text,
                                              tglSelesaiController.text);
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Text("SET")),
                                ],
                              );
                            });
                      },
                      icon: Icon(
                        Icons.add,
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              if (context.watch<TodoProvider>().events().length != 0)
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        itemCount: context.watch<TodoProvider>().events().length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              context.watch<TodoProvider>().events()[index].title,
                              style: TextStyle(
                                  color: context.watch<TodoProvider>().isDark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.watch<TodoProvider>().events()[index].subtitle,
                                  style: TextStyle(
                                      color: context.watch<TodoProvider>().isDark
                                          ? Colors.white54
                                          : Colors.black54),
                                ),
                                Text(
                                  context.watch<TodoProvider>().events()[index].startDate ==
                                          context.watch<TodoProvider>().events()[index].endDate
                                      ? "${context.watch<TodoProvider>().events()[index].endDate}"
                                      : "${context.watch<TodoProvider>().events()[index].startDate} - ${context.watch<TodoProvider>().events()[index].endDate}",
                                  style: TextStyle(
                                      color: context.watch<TodoProvider>().isDark
                                          ? Colors.white54
                                          : Colors.black54),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  context.read<TodoProvider>().hapusEvent =
                                      context.read<TodoProvider>().events()[index];
                                });
                              },
                            ),
                            isThreeLine: true,
                          );
                        }),
                  ),
                ),
            ],
          )),
    );
  }
}
