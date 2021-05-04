import 'package:aoe_mosaic_app/ui_theme.dart';
import 'package:flutter/material.dart';

class MySuspendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyStandardAppBar('Suspend'),
      endDrawer: MyDrawer(),
      body: Center(
        child: Text("Suspend", textScaleFactor: 2),
      ),
    );
  }
}
