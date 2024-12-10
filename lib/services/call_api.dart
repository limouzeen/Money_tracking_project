


import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:money_tracking_project/models/money.dart';
import 'package:money_tracking_project/models/user.dart';
import 'package:money_tracking_project/utils/env.dart';

class CallAPI{


  static Future<User> callregisterUserAPI(User user) async {
    final responseData = await http.post(
      Uri.parse(Env.hostName + '/moneytracking/apis/newUserAPI.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (responseData.statusCode == 200) {
      return User.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception('Failed to call API');
    }
  }


    static Future<Money> callinsertIncomeAPI(Money money) async {
    final responseData = await http.post(
      Uri.parse(Env.hostName + '/moneytracking/apis/newIncomeAPI.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(money.toJson()),
    );

    if (responseData.statusCode == 200) {
      return Money.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception('Failed to call API');
    }
  }


  static Future<User> callloginUserAPI(User user) async {
    final responseData = await http.post(
      Uri.parse(Env.hostName + '/moneytracking/apis/checkLoginUserAPI.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (responseData.statusCode == 200) {
      return User.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception('Failed to call API');
    }
  }

  static Future<List<Money>> callGetAllmoneybyUserID(Money money) async {
    //เรียกใช้ API แล้วเก็บค่าที่ได้จาก API ไว้ในตัวแปร
    final responseData = await http.post(
      Uri.parse(Env.hostName + '/moneytracking/apis/getAllMoneyByUserIdAPI.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(money.toJson()),
    );

    if (responseData.statusCode == 200) {
      final dataList = await jsonDecode(responseData.body).map<Money>((json) {
        return Money.fromJson(json);
      }).toList();

      return dataList;
    } else {
      throw Exception('Failed to call API');
    }
  }


}