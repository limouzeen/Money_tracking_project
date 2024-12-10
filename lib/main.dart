import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_tracking_project/views/dash_board_ui.dart';
import 'package:money_tracking_project/views/home_ui.dart';
import 'package:money_tracking_project/views/splash_screen_ui.dart';
import 'package:money_tracking_project/views/welcome_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeUI(),
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
