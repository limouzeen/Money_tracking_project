import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_tracking_project/models/user.dart';
import 'package:money_tracking_project/views/subviews/income_view.dart';
import 'package:money_tracking_project/views/subviews/main_view.dart';
import 'package:money_tracking_project/views/subviews/outcome_view.dart';


class HomeUI extends StatefulWidget {
  User? user;
  HomeUI({super.key, this.user});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  int _selectedIndex = 1;

 late List<Widget> _showView;

  @override
  void initState() {
    super.initState();
    _showView = [
      IncomeView(user: widget.user,),
      MainView(user: widget.user),
      OutcomeView(user: widget.user,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showView[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(54, 137, 131, 1), // Green background
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.moneyBillTransfer), // Icon for "Income"
            label: 'Income',
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.home_24_regular), // Icon for "Main"
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.moneyBillWave), // Icon for "Outcome"
            label: 'Outcome',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white, // Color for selected icon
        unselectedItemColor: const Color.fromRGBO(170, 170, 170, 0.67), // Color for unselected icons
        selectedIconTheme: const IconThemeData(
          size: 35, // Larger size for selected icons
        ),
        unselectedIconTheme: const IconThemeData(
          size: 24, // Smaller size for unselected icons
        ),
        currentIndex: _selectedIndex,
        onTap: (paramValue) {
          setState(() {
            _selectedIndex = paramValue;
          });
        },
      ),
    );
  }
}
