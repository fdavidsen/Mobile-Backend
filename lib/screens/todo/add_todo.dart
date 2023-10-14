import 'package:apple_todo/models/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:apple_todo/streams/stream_manager.dart';
import 'package:apple_todo/providers/todo_provider.dart';

class AddTodo extends StatefulWidget {
  final bool isAddNew;
  final Map<String, String> data;

  const AddTodo({
    Key? key,
    required this.isAddNew,
    this.data = const {},
  }) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  String value = "Routine";

  TextEditingController kegiatanController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController tglMulaiController = TextEditingController();
  TextEditingController tglSelesaiController = TextEditingController();

  late DBManager dbManager;
  late StreamManager streamController;

  @override
  void initState() {
    dbManager = DBManager();
    streamController = StreamManager(context);
    if (!widget.isAddNew) {
      kegiatanController.text = widget.data['title']!;
      keteranganController.text = widget.data['keterangan']!;
      tglMulaiController.text = widget.data['mulai']!;
      tglSelesaiController.text = widget.data['selesai']!;
      value = widget.data['kategori']!;
    }
    super.initState();
  }

  @override
  void dispose() {
    streamController.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos"),
        centerTitle: true,
        backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff1e1e1e) : Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 75),
          color: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : const Color(0xfff0f0f0),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.list_alt_outlined,
                  color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                ),
                title: Text(
                  "Kegiatan",
                  style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
              ),
              TextField(
                controller: kegiatanController,
                style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  label: Text(
                    "Judul kegiatan",
                    style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white70 : Colors.grey),
                  ),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.list, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                title: Text(
                  "Keterangan",
                  style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
              ),
              SizedBox(
                height: 100,
                child: TextField(
                  controller: keteranganController,
                  textAlignVertical: TextAlignVertical.center,
                  expands: true,
                  maxLines: null,
                  style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    label: Text(
                      "Keterangan kegiatan",
                      style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white70 : Colors.grey),
                    ),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.calendar_month,
                  color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                ),
                title: Text(
                  "Tanggal Mulai",
                  style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
              ),
              TextField(
                controller: tglMulaiController,
                style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  label: Text(
                    tglMulaiController.text.isEmpty ? 'Pilih tanggal mulai' : 'Tanggal mulai',
                    style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white70 : Colors.grey),
                  ),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: tglMulaiController.text.isNotEmpty ? DateFormat('dd MMM yyyy').parse(tglMulaiController.text) : DateTime.now(),
                    initialDatePickerMode: DatePickerMode.day,
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2101),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                            dialogBackgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white,
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
                      tglMulaiController.text = DateFormat("dd MMM yyyy").format(picked);
                    });
                  }
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_month, color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                title: Text(
                  "Tanggal Selesai",
                  style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
              ),
              TextField(
                controller: tglSelesaiController,
                style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  label: Text(
                    tglSelesaiController.text.isEmpty ? 'Pilih tanggal selesai' : 'Tanggal selesai',
                    style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white70 : Colors.grey),
                  ),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black)),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: tglSelesaiController.text.isNotEmpty ? DateFormat('dd MMM yyyy').parse(tglSelesaiController.text) : DateTime.now(),
                    initialDatePickerMode: DatePickerMode.day,
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2101),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                            dialogBackgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white,
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
                      tglSelesaiController.text = DateFormat("dd MMM yyyy").format(picked);
                    });
                  }
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              const SizedBox(height: 50),
              ListTile(
                leading: Icon(
                  Icons.local_activity_outlined,
                  color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
                ),
                title: Text(
                  "Kegiatan",
                  style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                ),
                trailing: SizedBox(
                    child: DropdownButton(
                        dropdownColor: context.watch<TodoProvider>().isDark ? Colors.black : Colors.white,
                        value: value,
                        items: [
                          DropdownMenuItem(
                              value: "Routine",
                              child: Text(
                                "Routine",
                                style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                              )),
                          DropdownMenuItem(
                              value: "Work",
                              child: Text(
                                "Work",
                                style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                              )),
                          DropdownMenuItem(
                              value: "Others",
                              child: Text(
                                "Others",
                                style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                              )),
                        ],
                        onChanged: (val) {
                          setState(() {
                            value = val.toString();
                          });
                        })),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(20),
                            side: BorderSide(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.blue)),
                        child: const Text("Batal"),
                      )),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        onPressed: () {
                          Map<String, String> data = {
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

                          if (widget.isAddNew) {
                            streamController.add(data);
                          } else {
                            dbManager.updateTodo(widget.data['id']!, data);
                            context.read<TodoProvider>().updateTodo(widget.data['id']!, data);
                          }
                          Navigator.of(context).pop();

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      SizedBox(
                                        height: 180,
                                        width: 250,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(5, 50, 5, 5),
                                          child: Column(
                                            children: [
                                              Text("Berhasil",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: !context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white),
                                                  textAlign: TextAlign.center),
                                              const SizedBox(height: 10),
                                              Text(widget.isAddNew ? "Kegiatan berhasil ditambahkan" : "Kegiatan berhasil diupdate",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: !context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white),
                                                  textAlign: TextAlign.center),
                                              const SizedBox(height: 20),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35)),
                                                child: const Text("OK"),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: -45,
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundColor: context.watch<TodoProvider>().isDark ? const Color(0xff0e0e0e) : Colors.white,
                                            child: const CircleAvatar(
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
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                        child: Text(widget.isAddNew ? "Simpan" : "Update"),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
