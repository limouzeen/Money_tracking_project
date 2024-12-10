import 'package:flutter/material.dart';
import 'package:money_tracking_project/models/money.dart';
import 'package:money_tracking_project/models/user.dart';
import 'package:money_tracking_project/services/call_api.dart';
import 'package:money_tracking_project/utils/env.dart';
import 'package:money_tracking_project/views/login_ui.dart';
import 'package:money_tracking_project/views/welcome_ui.dart';
import 'package:intl/intl.dart';


class IncomeView extends StatefulWidget {
  String? userId;
  User? user;  
  IncomeView({super.key, this.user});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {

  Future<List<Money>>? futureMoney;

  
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double balance = 0.0;


  final TextEditingController incomedetailController = TextEditingController(text: '');
  final TextEditingController incomeamountController = TextEditingController(text: '');
  final TextEditingController incomedateController = TextEditingController(text: '');



  getAllMoneyByUserId(Money money) async {
    setState(() {
      futureMoney = CallAPI.callGetAllmoneybyUserID(money);
    });

    futureMoney!.then((moneyList) {
  print('Received Money List: $moneyList'); // Debugging
  calculateTotals(moneyList);
}).catchError((error) {
  print('Error fetching money data: $error'); // Debugging
});

  }

void calculateTotals(List<Money> moneyList) {
  double income = 0.0;
  double expense = 0.0;

  for (var money in moneyList) {
    final moneyValue = double.tryParse(money.moneyInOut ?? "0");
    if (moneyValue == null) {
      print('Parsing error for moneyInOut: ${money.moneyInOut}'); // Debugging
      continue;
    }

    if (money.moneyType == "1") {
      income += moneyValue;
    } else if (money.moneyType == "2") {
      expense += moneyValue;
    }
  }

  setState(() {
    totalIncome = income;
    totalExpense = expense;
    balance = income - expense;
  });

  print('Income: $income, Expense: $expense, Balance: $balance'); // Debugging
}



void _showAccountOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              Navigator.pop(context); // Close the BottomSheet
              _signOutAndNavigateToLogin(context); // Call the sign-out function
            },
          ),
        ],
      );
    },
  );
}


void _signOutAndNavigateToLogin(BuildContext context) {
  // Clear any stored session or user data
  // Example: SharedPreferences, API tokens, etc.
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  // Navigate to LoginUI and clear the navigation stack
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => WelcomeUI()),
    (route) => false,
  );
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
  void initState() {
    Money money = Money(
      userId: widget.user!.userId,
    );

    getAllMoneyByUserId(money);

    

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
      final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF3E7C78),
      body: Stack(
        children: [
          // White Background with Rounded Top
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenSize.height * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),

          // Background Green Rectangle
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Rectangle.png', // Green background image
              width: screenSize.width,
              height: screenSize.height * 0.35,
              fit: BoxFit.cover, // Ensures the image covers its box
            ),
          ),

          // Content Section
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.07),
            
                // Profile Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user!.userFullname ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.1),
                    GestureDetector(
                      onTap: () {
                        _showAccountOptions(context);
                      },
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: widget.user!.userImage != null
                            ? NetworkImage(
                                '${Env.hostName}/moneytracking/picupload/user/${widget.user!.userImage!}?v=${DateTime.now().millisecondsSinceEpoch}',
                              )
                            : const AssetImage('assets/images/user.png') as ImageProvider,
                      ),
                    ),
                  ],
                ),
            
                SizedBox(height: screenSize.height * 0.035),
            
                // Balance Card
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFF2F7E79),
                //     borderRadius: BorderRadius.circular(20),
                //     boxShadow: [
                //       BoxShadow(
                //         color: const Color.fromARGB(255, 105, 165, 156).withOpacity(0.5),
                //         blurRadius: 10,
                //         offset: const Offset(0, 10),
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     children: [
                //       const Text(
                //         'ยอดเงินคงเหลือ',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //       Text(
                //         balance.toStringAsFixed(2),
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 30,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       const SizedBox(height: 20),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Row(
                //                 children: const [
                //                   Icon(Icons.arrow_circle_down_rounded,
                //                       color: Colors.white, size: 20),
                //                   SizedBox(width: 5),
                //                   Text(
                //                     'ยอดเงินเข้ารวม',
                //                     style: TextStyle(color: Colors.white, fontSize: 12),
                //                   ),
                //                 ],
                //               ),
                //               const SizedBox(height: 5),
                //               Text(
                //                 totalIncome.toStringAsFixed(2),
                //                 style: const TextStyle(
                //                   color: Colors.white,
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 16,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Row(
                //                 children: const [
                //                   Text(
                //                     'ยอดเงินออกรวม',
                //                     style: TextStyle(color: Colors.white, fontSize: 12),
                //                   ),
                //                   SizedBox(width: 5),
                //                   Icon(Icons.arrow_circle_up_rounded,
                //                       color: Colors.white, size: 20),
                //                 ],
                //               ),
                //               const SizedBox(height: 5),
                //               Text(
                //                 totalExpense.toStringAsFixed(2),
                //                 style: const TextStyle(
                //                   color: Colors.white,
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 16,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                Container(
  margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
  decoration: BoxDecoration(
    color: const Color(0xFF2F7E79),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 105, 165, 156).withOpacity(0.5),
        blurRadius: 10,
        offset: const Offset(0, 10),
      ),
    ],
  ),
  child: Column(
    children: [
      const Text(
        'ยอดเงินคงเหลือ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        NumberFormat('#,##0.00').format(balance),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: const [
                  Icon(Icons.arrow_circle_down_rounded,
                      color: Colors.white, size: 20),
                  SizedBox(width: 5),
                  Text(
                    'ยอดเงินเข้ารวม',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                NumberFormat('#,##0.00').format(totalIncome),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: const [
                  Text(
                    'ยอดเงินออกรวม',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_circle_up_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                NumberFormat('#,##0.00').format(totalExpense),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
),

                SizedBox(height: screenSize.height * 0.04),
            
                // Transaction Section Title
                const Text(
                  'เงินเข้า',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),


                SizedBox(height: screenSize.height * 0.03),
            
                // TextField
            
            
                Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust padding as needed
              child: buildTextField(
                controller: incomedetailController,
                hintText: 'DETAIL',
                labelText: 'รายการเงินเข้า',
                inputType: TextInputType.text,
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust padding as needed
              child: buildTextField(
                controller: incomeamountController,
                hintText: '0.00',
                labelText: 'จำนวนเงินเข้า',
                inputType: TextInputType.number,
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust padding as needed
              child: buildTextField(
                controller: incomedateController,
                hintText: 'DATE INCOME',
                labelText: 'วัน-เดือน-ปี เกิด',
                icon: Icons.calendar_today,
                readOnly: true, // Make the text field readonly
                onTap: () {
                  _openCalendar(true, incomedateController); // Pass the controller for updating
                },
              ),
            ),

               SizedBox(
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), 
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () {

                            // Logic Save

                          if(incomeamountController.text.trim() == '' || incomedetailController.text.trim() == '' || incomedateController.text.trim() == '') {
                            showWarningDialog(context, 'กรุณาป้อนข้อมูลให้ครบถ้วน');
                          } else{
                            String moneyType = '1';

                            Money money = Money(
                              moneyInOut: incomeamountController.text.trim(),
                              moneyDetail: incomedetailController.text.trim(),
                              moneyDate: incomedateController.text.trim(),
                              moneyType: moneyType,
                              userId: widget.user!.userId,

                            );


                            try {
  CallAPI.callinsertIncomeAPI(money).then((value) {
    if (value.message == '1') {
      showCompleteDialog(context, 'เพิ่มข้อมูลเงินเข้าเรียบร้อย');

       // Reload data from the database
            Money reloadMoney = Money(userId: widget.user!.userId);
            getAllMoneyByUserId(reloadMoney);
      setState(() {
        incomeamountController.clear();
        incomedetailController.clear();
        incomedateController.clear();


      });
    } else {
      showWarningDialog(context, 'เพิ่มข้อมูลเงินเข้าไม่สําเร็จ');
    }
  }).catchError((error) {
    // Handle API or network errors
    showWarningDialog(context, 'เกิดข้อผิดพลาด: $error');
  });
} catch (error) {
  // Handle unexpected exceptions
  showWarningDialog(context, 'เกิดข้อผิดพลาดที่ไม่คาดคิด: $error');
}

                          }
                      
                          
                        
                          },
                          child: const Text(
                            'บันทึกเงินเข้า',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                            ),
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
  TextInputType inputType = TextInputType.text, // Add inputType parameter with a default value
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    readOnly: readOnly, // Make the field readonly if needed
    onTap: onTap, // Trigger callback when tapped
    keyboardType: inputType, // Set the input type dynamically
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
        vertical: 10,
        horizontal: 15,
      ),
    ),
    style: const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
  );
}

}
