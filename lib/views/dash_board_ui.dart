import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00695C), // Background color for header
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF00695C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Profile Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Firstname Lastname',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150', // Replace with profile image URL
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Balance Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'ยอดเงินคงเหลือ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '2,500.00',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Column(
                              children: [
                                Text(
                                  'ยอดเงินเข้ารวม',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '5,700.00',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'ยอดเงินออกรวม',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '2,200.00',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Transaction List Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'เงินเข้า/เงินออก',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // List of Transactions
                  ...List.generate(transactions.length, (index) {
                    final transaction = transactions[index];
                    return ListTile(
                      leading: Icon(
                        transaction['type'] == 'income'
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transaction['type'] == 'income'
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(transaction['title'] ??
                          'Unknown title'), // Default value for null
                      subtitle: Text(transaction['date'] ??
                          'Unknown date'), // Default value for null
                      trailing: Text(
                        transaction['amount'] ??
                            '0.00', // Default value for null
                        style: TextStyle(
                          fontSize: 16,
                          color: transaction['type'] == 'income'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle navigation
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}

// Dummy transaction data
final List<Map<String, String>> transactions = [
  {
    'title': 'ซื้รองเท้า Nike Air มือ 2',
    'date': '2 กุมภาพันธ์ 2567',
    'amount': '800.00',
    'type': 'expense',
  },
  {
    'title': 'กิน KFC',
    'date': '15 มกราคม 2567',
    'amount': '500.00',
    'type': 'expense',
  },
  {
    'title': 'ขายของออนไลน์',
    'date': '12 มกราคม 2567',
    'amount': '2,200.00',
    'type': 'income',
  },
  {
    'title': 'ซื้อคีย์บอร์ด',
    'date': '10 มกราคม 2567',
    'amount': '1,200.00',
    'type': 'expense',
  },
  {
    'title': 'เงินเดือน',
    'date': '5 มกราคม 2567',
    'amount': '3,500.00',
    'type': 'income',
  },
];
