import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_tracking_project/models/user.dart';
import 'package:money_tracking_project/services/call_api.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({Key? key}) : super(key: key);

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController birthdayController = TextEditingController(text: '');
  final TextEditingController usernameController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');

  File? _imageSelected;
  //ตัวแปรไว้เก็บรูปจาก Camera/Gallery ที่แปลงเป็น Base64 เพื่อใช้ส่งไปยัง API
  String? _imageBase64Selected;

  Future<void> _openGallery() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (_picker != null) {
      setState(() {
        _imageSelected = File(_picker.path);
        _imageBase64Selected = base64Encode(_imageSelected!.readAsBytesSync());
      });
    }
  }

  //เปิดกล้อง
  Future<void> _openCamera() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (_picker != null) {
      setState(() {
        _imageSelected = File(_picker.path);
        _imageBase64Selected = base64Encode(_imageSelected!.readAsBytesSync());
      });

    }
  }


Future<void> _openCalendar(bool isStartDate, TextEditingController controller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );
  if (pickedDate != null) {
    setState(() {
      controller.text = _formatDate(pickedDate); // Format and set date
    });
  }
}

String _formatDate(DateTime date) {
  String day = date.day.toString();
  String month = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม'
  ][date.month - 1];
  String year = (date.year + 543).toString(); // Convert to Thai Buddhist year
  return '$day $month $year';
}


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
       backgroundColor: const Color(0xFF3E7C78), 
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E7C78), // Green background color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'ลงทะเบียน',
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
            // Rounded white container for content
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
                children: [
                   SizedBox(height: screenSize.height * 0.015),
                    Text(
          'ข้อมูลผู้ใช้งาน',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
    SizedBox(height: screenSize.height * 0.025),
                  // Profile Picture Section
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      
                Container(
  width: MediaQuery.of(context).size.width * 0.35,
  height: MediaQuery.of(context).size.width * 0.35,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Color(0xFFFAFAFA), // Background color for the circle
    image: _imageSelected != null
        ? DecorationImage(
            image: FileImage(_imageSelected!), // Selected image
            fit: BoxFit.cover,
          )
        : null, // No image decoration if null
  ),
  child: _imageSelected == null
      ? const Center(
          child: Icon(
            FontAwesomeIcons.user,
            size: 50,
            color: Color.fromARGB(255, 121, 120, 120),
          ),
        )
      : null, // Show nothing if image is selected
),

                    Positioned(
                      bottom: 1,
                      child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () {
                                  _openCamera().then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                                leading: Icon(
                                  Icons.camera_alt,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  'Open Camera...',
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                                height: 5.0,
                              ),
                              ListTile(
                                onTap: () {
                                  _openGallery().then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                                leading: Icon(
                                  Icons.browse_gallery,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  'Open Gallery...',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                                        ),
                    ),
                    ],
                  ),
             

                   

                  SizedBox(height: screenSize.height * 0.055),


                  // Input Fields
                  buildTextField(
                    controller: nameController,
                    hintText: 'YOUR NAME',
                    labelText: 'ชื่อ-สกุล',
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  buildTextField(
  controller: birthdayController,
  hintText: 'YOUR BIRTHDAY',
  labelText: 'วัน-เดือน-ปี เกิด',
  icon: Icons.calendar_today,
  readOnly: true, // Make the text field readonly
  onTap: () {
    _openCalendar(true, birthdayController); // Pass the controller for updating
  },
),

                  SizedBox(height: screenSize.height * 0.03),
                  buildTextField(
                    controller: usernameController,
                    hintText: 'USERNAME',
                    labelText: 'ชื่อผู้ใช้',
                
                  ),
                 SizedBox(height: screenSize.height * 0.03),
                  buildTextField(
                    controller: passwordController,
                    hintText: 'PASSWORD',
                    labelText: 'รหัสผ่าน',
                    icon: Icons.lock,
                    obscureText: true,
                  ),

                  SizedBox(height: screenSize.height * 0.035),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF69AEA9),Color(0xFF3E7C78), ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3E7C78).withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(2, 4),
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
                          // Logic Save

                          if (nameController.text.trim() == '' ||
                              birthdayController.text.trim() == '' ||
                              usernameController.text.trim() == '' ||
                              passwordController.text.trim() == '') {
                                showWarningDialog(context, 'กรุณาป้อนข้อมูลให้ครบถ้วน');
                              } else{
                                String? base64Image = _imageBase64Selected ?? "";

                                User user = User(
                                  userFullname: nameController.text.trim(),
                                  userBirthDate: birthdayController.text.trim(),
                                  userName: usernameController.text.trim(),
                                  userPassword: passwordController.text.trim(),
                                  userImage: base64Image,                                  
                                );

                                CallAPI.callregisterUserAPI(user).then((value) {
                                  if (value.message == '1') {
                                    showCompleteDialog(
                                            context, 'ลงทะเบียนสำเร็จแล้ว :P ...')
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    showWarningDialog(context,  'ลงทะเบียนไม่สำเร็จโปรดลองใหม่อีกครั้ง...');
                                  }
                                }).catchError((error) {
      print('API Error: $error');
      showWarningDialog(context, "เกิดข้อผิดพลาด: $error");
    });
                              }
                        //    if (usernameCtrl.text.trim() == '' ||
                        //     passwordCtrl.text.trim() == '' ||
                        //     emailCtrl.text.trim() == '') {
                        //   showWarningDialog(
                        //       context, 'กรุณาป้อนข้อมูลให้ครบถ้วน');
                        // } else {
                        //   //ส่งข้อมูลไปบันทึก
                        //   String? base64Image = _imageBase64Selected ?? "";
                        //   //โดยการเรียกใช้ API ผ่านทาง Method ที่ Class CallAPI
                        //   Myprofile myprofile = Myprofile(
                        //     username: usernameCtrl.text.trim(),
                        //     password: passwordCtrl.text.trim(),
                        //     email: emailCtrl.text.trim(),
                        //     userImg: base64Image,
                        //   );

                        //   CallAPI.callregisterUserAPI(myprofile).then((value) {
                        //     if (value.message == '1') {
                        //       showCompleteDialog(
                        //               context, 'ลงทะเบียนสำเร็จแล้ว :P ...')
                        //           .then((value) {
                        //         Navigator.pop(context);
                        //       });
                        //     } else {
                        //       showWarningDialog(context,
                        //           'ลงทะเบียนไม่สำเร็จโปรดลองใหม่อีกครั้ง...');
                        //     }
                        //   });
                        // }
                        },
                        child: const Text(
                          'บันทึกการลงทะเบียน',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenSize.height * 0.04),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


Widget buildTextField({
  required TextEditingController controller,
  required String hintText,
  required String labelText,
  IconData? icon,
  bool obscureText = false,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    readOnly: readOnly, // Make the field readonly if needed
    onTap: onTap, // Trigger callback when tapped
    decoration: InputDecoration(
      labelText: labelText,
      floatingLabelBehavior: FloatingLabelBehavior.always, // Always show label above
      labelStyle: const TextStyle(
        color: Color(0xFF666666), // Label color
        fontSize: 14,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey, // Hint text color
        fontSize: 12,
        fontWeight: FontWeight.w100,
      ),
      suffixIcon: icon != null
          ? Icon(icon, color: const Color.fromARGB(255, 121, 120, 120))
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
        vertical: 12,
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
