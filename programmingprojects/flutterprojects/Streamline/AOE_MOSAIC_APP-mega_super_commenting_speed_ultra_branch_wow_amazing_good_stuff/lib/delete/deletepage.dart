import 'package:flutter/material.dart';
import 'package:aoe_mosaic_app/ui_theme.dart';

class MyDeletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyStandardAppBar('Delete'),
      endDrawer: MyDrawer(),
      body: Center(
        child: Text("Delete", textScaleFactor: 2),
      ),
    );
  }
}
