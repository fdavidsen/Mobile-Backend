import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:apple_todo/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 5), () {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const Login();
        },
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue,
        child: const Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingCube(
              color: Colors.white,
              size: 150,
            ),
            SizedBox(
              height: 100,
            ),
            Material(
                color: Colors.transparent,
                child: Text(
                  'Todo App',
                  style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                ))
          ],
        ));
  }
}
