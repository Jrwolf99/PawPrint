import 'package:K9Harness/Utilities/appbar.dart';
import 'package:K9Harness/Utilities/drawer.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myFirstAppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Hello! Welcome to the app PawPrint! ' +
                  'This is an app designed to output the vital signs of your K9.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'To get started, click the menu in the top left and search for the K9 Unit Device. This will bring you to a menu, where you search for, and then connect to, the turned-on bluetooth device on the K9. Once connected, you will be able to monitor the K9.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}
