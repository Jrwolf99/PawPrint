import 'package:flutter/material.dart';
import 'package:aoe_mosaic_app/ui_theme.dart';

class MyTurnUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyStandardAppBar('Turn Up'),
      endDrawer: MyDrawer(),
      body: Center(
        child: Text("Turn-Up Data Service", textScaleFactor: 2),
      ),
    );
  }
}
