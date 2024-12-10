import 'package:flutter/material.dart';
import 'package:money_tracking_project/views/home_ui.dart';
import 'package:money_tracking_project/views/welcome_ui.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeUI()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF63B5AF), // Top-left color
                  Color(0xFF438883), // Bottom-right color
                ],
                begin: Alignment.topLeft, // Start of the gradient
                end: Alignment.bottomRight, // End of the gradient
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Money Tracking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.02,
                  ),
                  Text(
                    'รายรับรายจ่ายของฉัน',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.05,
                  ),
                  CircularProgressIndicator(
                    color: const Color.fromARGB(255, 221, 210, 120),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.1,
            left: 0,
            right: 0,
            child: Text(
              'Created by 6552410012\n DTI_SAU',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenSize.height * 0.02,
                color: Color(0xFFEEFF00),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
