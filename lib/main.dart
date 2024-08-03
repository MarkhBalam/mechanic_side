import 'package:flutter/material.dart';
//import 'package:mechanic_side/pages/homepage.dart';
import 'package:mechanic_side/pages/main_screen.dart';
//import 'package:mechanic_side/pages/main_screen.dart'; // Import the homepage.dart file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
