import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apple_todo/providers/todo_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<String> categories = ["Routine", "Work", "Others"];

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : const Color(0xfff0f0f0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: context.watch<TodoProvider>().isDark ? Colors.black87 : Colors.white,
              child: ListTile(
                leading: InkWell(
                  child: context.watch<TodoProvider>().getGambar == null
                      ? const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: context.watch<TodoProvider>().getGambar,
                        ),
                  onTap: () {
                    getFromGallery() async {
                      XFile? pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        final bytes = await pickedFile.readAsBytes();
                        setState(() {
                          context.read<TodoProvider>().setGambar = MemoryImage(bytes);
                        });
                      }
                    }

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            insetPadding: const EdgeInsets.all(100),
                            child: Container(
                              height: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                        color: context.watch<TodoProvider>().isDark
                                            ? const Color(0xff1e1e1e)
                                            : Colors.white,
                                        width: double.infinity,
                                        child: context.watch<TodoProvider>().getGambar == null
                                            ? const CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 200,
                                                ),
                                              )
                                            : Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                    image: context.watch<TodoProvider>().getGambar!,
                                                    fit: BoxFit.cover,
                                                  )),
                                                ),
                                              )),
                                  ),
                                  Container(
                                    color: Colors.blue,
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                context.read<TodoProvider>().setGambar = null;
                                              });
                                            },
                                            icon: const Icon(Icons.delete, color: Colors.white)),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                getFromGallery();
                                              });
                                            },
                                            icon: const Icon(Icons.edit, color: Colors.white)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Rivaldi Lubis",
                    style: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Task finished: ${context.watch<TodoProvider>().filteredItems("", true).length}",
                    style: TextStyle(
                        color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    color: context.watch<TodoProvider>().isDark ? Colors.black87 : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            categories[index],
                            style: TextStyle(
                                color: context.watch<TodoProvider>().isDark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          Text(
                            context
                                .watch<TodoProvider>()
                                .filteredItems(categories[index], true)
                                .length
                                .toString(),
                            style: TextStyle(
                                color: categories[index] == "Routine"
                                    ? Colors.deepOrange
                                    : categories[index] == "Work"
                                        ? Colors.blue
                                        : Colors.green,
                                fontSize: 60),
                          ),
                          Text(
                            "Finished",
                            style: TextStyle(
                                color: context.watch<TodoProvider>().isDark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            Card(
              color: context.watch<TodoProvider>().isDark ? Colors.black87 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SliderTheme(
                      data: const SliderThemeData(
                          thumbShape: RoundSliderThumbShape(disabledThumbRadius: 0),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                          disabledActiveTrackColor: Colors.blue,
                          disabledInactiveTrackColor: Colors.grey),
                      child: Slider(
                        value:
                            context.watch<TodoProvider>().filteredItems("", true).length.toDouble(),
                        max: (context.watch<TodoProvider>().filteredItems("", false).length +
                                context.watch<TodoProvider>().filteredItems("", true).length)
                            .toDouble(),
                        onChanged: null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.watch<TodoProvider>().filteredItems("", false).length.toInt() != 0
                          ? "You still have ${context.watch<TodoProvider>().filteredItems("", false).length.toInt()} task(s) to do"
                          : "All tasks done",
                      style: TextStyle(
                          color:
                              context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
