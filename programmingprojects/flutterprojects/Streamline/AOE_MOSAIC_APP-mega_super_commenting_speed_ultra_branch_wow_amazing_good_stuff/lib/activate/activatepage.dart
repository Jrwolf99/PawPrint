import 'package:flutter/material.dart';
import 'package:aoe_mosaic_app/ui_theme.dart';

class MyActivatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyStandardAppBar('Activate'),
      endDrawer: MyDrawer(),
      body: Center(
        child: Text("Activate", textScaleFactor: 2),
      ),
    );
  }
}
