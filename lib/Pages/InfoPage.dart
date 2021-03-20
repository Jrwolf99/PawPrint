import 'package:flutter/material.dart';
import 'package:K9Harness/Utilities/appbar.dart';

class MyInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text('Hello! Welcome to the app PawPrint! ' +
                'This is an app designed to output the vital signs of your K9.'),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
                'The K9 Vital Sensing System is a project made by students at the University of Alabama. These students are: '),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text('Alexa Golubjatnikov'),
                SizedBox(height: 10),
                Text('Andrew Lawson'),
                SizedBox(height: 10),
                Text('Salman Alsaidi'),
                SizedBox(height: 10),
                Text('Jonathan Wolf'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
