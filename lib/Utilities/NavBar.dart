import 'package:K9Harness/theme.dart';
import 'package:flutter/material.dart';
import '../Pages/allvitals.dart';
import '../Pages/heartrate.dart';
import '../Pages/temperature.dart';
import '../Pages/respiratory.dart';
import '../theme.dart';
import 'appbar.dart';
import 'drawer.dart';

class MyNavBar extends StatefulWidget {
  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    AllvitalsPage(),
    HeartratePage(),
    RespPage(),
    TempPage(),
  ];

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AccentColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "All Vitals",
            backgroundColor: ButtonColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            label: "Heart Rate",
            backgroundColor: ButtonColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: "Respiratory Rate",
            backgroundColor: ButtonColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat_outlined),
            label: "Temperature",
            backgroundColor: ButtonColor,
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTap,
      ),
      appBar: myAppBar(),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      drawer: MyDrawer(),
    );
  }
}
