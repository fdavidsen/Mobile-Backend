import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apple_todo/providers/todo_provider.dart';
import 'package:apple_todo/screens/profile/weather.dart';
import 'package:apple_todo/screens/profile/member.dart';

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
      color: context.watch<TodoProvider>().isDark ? const Color(0xff1a1a1a) : const Color(0xfff0f0f0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 85),
        child: Column(
          children: [
            Card(
              color: context.watch<TodoProvider>().isDark ? Colors.black87 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
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
                              insetPadding: const EdgeInsets.all(35),
                              child: SizedBox(
                                height: 300,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                          color: context.watch<TodoProvider>().isDark ? const Color(0xff1e1e1e) : Colors.white,
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
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "Tim Apple",
                      style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "Task finished: ${context.watch<TodoProvider>().filteredItems("", true).length}",
                      style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return Card(
                      color: context.watch<TodoProvider>().isDark ? Colors.black87 : Colors.white,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              categories[index],
                              style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black, fontSize: 12),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                context.watch<TodoProvider>().filteredItems(categories[index], true).length.toString(),
                                style: TextStyle(
                                    color: categories[index] == "Routine"
                                        ? Colors.deepOrange
                                        : categories[index] == "Work"
                                            ? Colors.blue
                                            : Colors.green,
                                    fontSize: 38),
                              ),
                            ),
                            Text(
                              "Finished",
                              style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Card(
              color: context.watch<TodoProvider>().isDark ? Colors.black87 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SliderTheme(
                      data: const SliderThemeData(
                          thumbShape: RoundSliderThumbShape(disabledThumbRadius: 0),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                          disabledActiveTrackColor: Colors.blue,
                          disabledInactiveTrackColor: Colors.grey),
                      child: Slider(
                        value: context.watch<TodoProvider>().filteredItems("", true).length.toDouble(),
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
                      style: TextStyle(color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: Weather(),
            ),
            const Member(),
          ],
        ),
      ),
    );
  }
}
