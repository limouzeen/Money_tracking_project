import 'package:flutter/material.dart';
import 'package:money_tracking_project/models/user.dart';
import 'package:money_tracking_project/services/call_api.dart';
import 'package:money_tracking_project/views/home_ui.dart';
import 'package:money_tracking_project/views/subviews/main_view.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final TextEditingController usernameController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');

void showWarningDialog(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color(0xFFEEF6F5), // Light background to match UI
      title: Align(
        alignment: Alignment.center,
        child: Text(
          'คำเตือน',
          style: const TextStyle(
            color: Color(0xFF3E7C78), // Match the primary green color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Text(
        msg,
        style: const TextStyle(
          color: Color(0xFF666666), // Subtle text color for content
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E7C78), // Primary button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'ตกลง',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> showCompleteDialog(BuildContext context, String msg) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color(0xFFEEF6F5), // Light background to match UI
      title: Align(
        alignment: Alignment.center,
        child: Text(
          'ผลการทำงาน',
          style: const TextStyle(
            color: Color(0xFF3E7C78), // Match the primary green color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Text(
        msg,
        style: const TextStyle(
          color: Color(0xFF666666), // Subtle text color for content
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E7C78), // Primary button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'ตกลง',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF3E7C78), // Match AppBar background
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E7C78),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'เข้าใช้งาน Money Tracking',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.035),
            // Rounded container for content
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenSize.height * 0.03),

                  // Display the man illustration
                  Image.asset(
                    'assets/images/money.png', // Ensure you add the image file to this path
                    width: screenSize.width * 0.45, // Adjust size relative to the screen
                  ),
                  SizedBox(height: screenSize.height * 0.05),

                  // Username TextField
                  buildTextField(
                    controller: usernameController,
                    hintText: 'USERNAME',
                    labelText: 'ชื่อผู้ใช้',
                  ),
                  SizedBox(height: screenSize.height * 0.03),

                  // Password TextField
                  buildTextField(
                    controller: passwordController,
                    hintText: 'PASSWORD',
                    labelText: 'รหัสผ่าน',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  SizedBox(height: screenSize.height * 0.05),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF69AEA9), Color(0xFF3E7C78)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3E7C78).withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(2, 10),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          // Handle login logic
                          if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
                            showWarningDialog(context, 'กรุณากรอกชื่อผู้ใช้และรหัสผ่าน');
                          }else{

                            User user = User(
                              userName: usernameController.text.trim(),
                              userPassword: passwordController.text.trim(),
                            );
                            

                            try {
                              CallAPI.callloginUserAPI(user).then((value){

                                if(value.message == '1'){
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeUI(user : value),
                                    ),
                                  );
                                }else{
                                  showWarningDialog(context, 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
                                }

                              });
                            } catch (e) {
                              showWarningDialog(context, 'เกิดข้อผิดพลาด: $e');
                            }
                          }


                        },
                        child: const Text(
                          'เข้าใช้งาน',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for TextFields
  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    IconData? icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
          color: Color(0xFF666666), // Label color
          fontSize: 14,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w100,
        ),
        suffixIcon: icon != null
            ? Icon(icon, color: const Color(0xFF666666))
            : null,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF69AEA9),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF3E7C78),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }
}
