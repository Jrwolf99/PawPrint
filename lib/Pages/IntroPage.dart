import 'package:K9Harness/Utilities/appbar.dart';
import 'package:K9Harness/Utilities/drawer.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Container(),
      drawer: MyDrawer(),
    );
  }
}
