import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apple_todo/screens/splash_screen.dart';
import 'package:apple_todo/providers/todo_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
          title: 'ToDo App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen()),
    );
  }
}
