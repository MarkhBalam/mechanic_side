import 'package:flutter/material.dart';
import 'package:mechanic_side/pages/homepage.dart'; // Import the homepage.dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mechanic side',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary color for the theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue, // AppBar color
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue, // Default button color
        ),
        // You can add more theme customizations here if needed
      ),
      home: const MyHomePage(title: 'Garage Finder mechanic side'),
    );
  }
}
