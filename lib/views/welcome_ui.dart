import 'package:flutter/material.dart';
import 'package:money_tracking_project/views/login_ui.dart';
import 'package:money_tracking_project/views/register_ui.dart';

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({super.key});

  @override
  State<WelcomeUI> createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned(
            top: 0, // Adjust vertical position
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bg_workui.png', // Path to your background image
// Set width to match the screen
// Adjust height as needed
              fit: BoxFit.fitWidth, // Ensures the image covers its box
            ),
          ),

          // Foreground content
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenSize.height * 0.1),

                  // Foreground Image (money.png)
                  Image.asset(
                    'assets/images/money.png', // Path to your image
                    width: screenSize.width * 0.69,
                  ),

                  // Title Section
                  SizedBox(
                    height: screenSize.height * 0.025,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'บันทึก\nรายรับรายจ่าย',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenSize.height * 0.035,
                        color: const Color(0xFF3B6064), // Text color
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Button Section
                 Padding(
  padding: const EdgeInsets.symmetric(horizontal: 35.0),
  child: SizedBox(
    width: double.infinity, // Makes the button stretch to full width
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF69AEA9),
            Color(0xFF3E7C78), // Start color
             // End color
          ],
          begin: Alignment.topCenter, // Top-to-bottom gradient
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF3E7C78).withOpacity(0.5), // Shadow color
            blurRadius: 10, // Shadow blur
            offset: Offset(2, 10), // Shadow offset
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Transparent to show gradient
          shadowColor: Colors.transparent, // No default shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          // Action for the button
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginUI()));
        },
        child: Text(
          'เริ่มใช้งานแอปพลิเคชัน',
          style: TextStyle(
            fontSize: screenSize.height * 0.02,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  ),
),

                   SizedBox(height: screenSize.height * 0.025),

                  // Bottom Text Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ยังไม่ได้ลงทะเบียน?',
                          style: TextStyle(
                            fontSize: screenSize.height * 0.018,
                            color: const Color(0xFF3B6064), // Subtext color
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            // Navigate to the registration screen
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterUI()));
                          },
                          child: Text(
                            'ลงทะเบียน',
                            style: TextStyle(
                              fontSize: screenSize.height * 0.018,
                              color: const Color(
                                  0xFF63B5AF), // Highlighted text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Spacer for bottom padding
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
