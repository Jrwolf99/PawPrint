import 'package:flutter/material.dart';
import 'package:aoe_mosaic_app/ui_theme.dart';

class MyResumePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyStandardAppBar('Resume'),
      endDrawer: MyDrawer(),
      body: Center(
        child: Text("Resume", textScaleFactor: 2),
      ),
    );
  }
}
