import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracking_project/models/money.dart';
import 'package:money_tracking_project/models/user.dart';
import 'package:money_tracking_project/services/call_api.dart';
import 'package:money_tracking_project/utils/env.dart';
import 'package:money_tracking_project/views/login_ui.dart';
import 'package:money_tracking_project/views/welcome_ui.dart';

class MainView extends StatefulWidget {
  User? user;
  MainView({super.key, this.user});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Future<List<Money>>? futureMoney;

  
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double balance = 0.0;

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

//Logout Profile

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
          Column(
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
                'เงินเข้า/เงินออก',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),

              // Transaction List
              Expanded(
                child: FutureBuilder<List<Money>>(
                  future: futureMoney, // The future that fetches money data
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final money = snapshot.data![index];
                          final isIncome = money.moneyType == "1"; // Check if it's income

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Icon for Income or Expense
                                    Icon(
                                      isIncome
                                          ? Icons.arrow_circle_down_rounded
                                          : Icons.arrow_circle_up_rounded,
                                      color: isIncome ? Colors.green : Colors.red,
                                      size: 30,
                                    ),
                                    const SizedBox(width: 10),

                                    // Transaction Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            money.moneyDetail ?? 'ไม่มีข้อมูล',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w100,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            money.moneyDate ?? 'ไม่มีวันที่',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Amount
                                    Text(
                                     
                                      '${isIncome ? '+' : '-'}${NumberFormat('#,##0.00').format(double.tryParse(money.moneyInOut ?? '0') ?? 0)}',
                                      
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isIncome ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),

                                // Divider between items
                                const Divider(
                                  thickness: 1,
                                  color: Color.fromARGB(255, 197, 197, 197),
                                  height: 15,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("ไม่มีข้อมูล"));
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
