import 'package:K9Harness/Pages/BluetoothPage.dart';
import 'package:K9Harness/theme.dart';
import 'package:flutter/material.dart';
import 'package:K9Harness/splashscreen.dart';
import 'Pages/IntroPage.dart';
import 'splashscreen.dart';
import 'package:K9Harness/Pages/InfoPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K9 Harness',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: ButtonColor),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: ButtonColor),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/first': (context) => IntroPage(),
        '/second': (context) => MyBluetoothPage(),
        '/third': (context) => MyInfoPage(),
      },
    );
  }
}
