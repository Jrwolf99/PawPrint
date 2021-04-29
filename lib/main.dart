import 'package:K9Harness/Pages/BluetoothPage.dart';
import 'package:K9Harness/theme.dart';
import 'package:flutter/material.dart';
import 'package:K9Harness/splashscreen.dart';
import 'Pages/IntroPage.dart';
import 'splashscreen.dart';
import 'package:K9Harness/Pages/InfoPage.dart';

void main() {
  runApp(
    RestartWidget(
      child: MaterialApp(
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
      ),
    ),
  );
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
