import 'package:K9Harness/Pages/BluetoothPage.dart';
import 'package:K9Harness/Utilities/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:K9Harness/splashscreen.dart';
import 'splashscreen.dart';
import 'package:K9Harness/Pages/InfoPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K9 Harness',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/first': (context) => MyNavBar(),
        '/second': (context) => MyBluetoothPage(),
        '/third': (context) => MyInfoPage(),
      },
    );
  }
}
