import 'package:flutter/material.dart';
import 'package:K9Harness/Utilities/appbar.dart';

class MyInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Text('Hello! Welcome to the app PawPrint!' +
            'This is an app designed to output the vital signs of your K9.'),
      ),
    );
  }
}
