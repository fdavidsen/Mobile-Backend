import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:apple_todo/providers/todo_provider.dart';
import 'package:apple_todo/models/event_time_model.dart';
import 'package:apple_todo/utilities/constants.dart';
import 'package:apple_todo/cloud_functions/firestore_database.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final FSDatabase _fsDatabase = FSDatabase();

  TextEditingController judulController = TextEditingController();
  TextEditingController additionalController = TextEditingController();
  TextEditingController tglMulaiController = TextEditingController();
  TextEditingController tglSelesaiController = TextEditingController();

  Future<void> loadData() async {
    context.read<TodoProvider>().setAllEvent = await _fsDatabase.getAllEvent();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(right: 8, left: 8, bottom: 30),
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
              titleTextStyle: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
              leftChevronIcon: Icon(Icons.navigate_before, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
              rightChevronIcon: Icon(Icons.navigate_next, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
            ),
            calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                todayTextStyle: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                weekendTextStyle: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                todayDecoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
              weekendStyle: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
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
                    fontSize: 18,
                    color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white,
                                content: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        child: TextField(
                                          controller: judulController,
                                          style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                          decoration: InputDecoration(
                                            label: Text(
                                              'Nama Event',
                                              style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        child: TextField(
                                          controller: additionalController,
                                          style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                          decoration: InputDecoration(
                                            label: Text(
                                              'Keterangan tambahan',
                                              style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        child: TextField(
                                          controller: tglMulaiController,
                                          style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                          decoration: InputDecoration(
                                            label: Text(
                                              'Tanggal mulai',
                                              style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
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
                                                          context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white,
                                                      colorScheme: context.watch<TodoProvider>().isDark
                                                          ? const ColorScheme.dark(
                                                              onSurface: Colors.white,
                                                              primary: Colors.blue,
                                                            )
                                                          : const ColorScheme.light(
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
                                                tglMulaiController.text = DateFormat(datetimeFormat).format(selectedDate);
                                              });
                                            }
                                            FocusManager.instance.primaryFocus?.unfocus();
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        child: TextField(
                                          controller: tglSelesaiController,
                                          style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                          decoration: InputDecoration(
                                            label: Text(
                                              'Tanggal selesai',
                                              style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
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
                                                          context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white,
                                                      colorScheme: context.watch<TodoProvider>().isDark
                                                          ? const ColorScheme.dark(
                                                              onSurface: Colors.white,
                                                              primary: Colors.blue,
                                                            )
                                                          : const ColorScheme.light(
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
                                                tglSelesaiController.text = DateFormat(datetimeFormat).format(selectedDate);
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
                                      child: const Text("CANCEL", style: TextStyle(color: Colors.grey))),
                                  TextButton(
                                      onPressed: () async {
                                        EventTime data = EventTime(
                                          judulController.text,
                                          additionalController.text,
                                          tglMulaiController.text,
                                          tglSelesaiController.text,
                                        );

                                        judulController.text = '';
                                        additionalController.text = '';
                                        tglMulaiController.text = '';
                                        tglSelesaiController.text = '';

                                        // Insert to local database via sqflite
                                        // int id = await _dbManager.insertEvent(data);
                                        // data.id = id.toString();

                                        data = await _fsDatabase.insertEvent(data);

                                        setState(() {
                                          context.read<TodoProvider>().isiEvent = data;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("SET")),
                                ],
                              );
                            });
                      },
                      icon: Icon(
                        Icons.add,
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              title: 'Hapus semua event?',
                              confirmBtnText: 'Hapus',
                              cancelBtnText: 'Tutup',
                              showCancelBtn: true,
                              onConfirmBtnTap: () {
                                _fsDatabase.deleteAllEvent();
                                context.read<TodoProvider>().deleteAllEvent();
                                Navigator.pop(context);
                              });
                        },
                        icon: Icon(
                          Icons.delete_forever_outlined,
                          color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                        ))
                  ],
                )
              ],
            ),
          ),
          context.watch<TodoProvider>().events().isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: context.watch<TodoProvider>().events().length,
                  itemBuilder: (BuildContext context, int index) {
                    EventTime event = context.read<TodoProvider>().events()[index];

                    return GestureDetector(
                      onTap: () {
                        _fsDatabase.toggleEventPassStatus(event);
                        setState(() {
                          event.isPassed = !event.isPassed;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.only(top: 15, bottom: 18, left: 12),
                                color: context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white,
                                child: ListTile(
                                  title: Text(
                                    event.title,
                                    style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.subtitle,
                                        style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white54 : Colors.black54),
                                      ),
                                      Text(
                                        event.startDate == event.endDate ? event.endDate : "${event.startDate} - ${event.endDate}",
                                        style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white54 : Colors.black54),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.warning,
                                          title: 'Hapus event ini?',
                                          confirmBtnText: 'Hapus',
                                          cancelBtnText: 'Tutup',
                                          showCancelBtn: true,
                                          onConfirmBtnTap: () {
                                            _fsDatabase.deleteEvent(event.id);
                                            setState(() {
                                              context.read<TodoProvider>().hapusEvent = event;
                                            });
                                            Navigator.pop(context);
                                          });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            event.isPassed
                                ? Image.asset(
                                    'assets/passed.png',
                                    height: 75,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    );
                  })
              : Column(children: [
                  Container(width: 200, margin: const EdgeInsets.only(bottom: 20), child: Image.asset('assets/no-event.png')),
                  Text('Tidak ada event',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black))
                ]),
        ],
      ),
    );
  }
}
