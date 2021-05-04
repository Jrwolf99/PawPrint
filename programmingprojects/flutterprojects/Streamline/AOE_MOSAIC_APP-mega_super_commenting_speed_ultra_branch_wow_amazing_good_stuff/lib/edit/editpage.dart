import 'package:aoe_mosaic_app/settingspage.dart';
import 'package:flutter/material.dart';
import 'replaceontpage.dart';
import 'turnuppage.dart';
import '../utilities/utility.dart';
import '../ui_theme.dart';

class MyEditPage extends StatefulWidget {
  MyEditPage({Key key}) : super(key: key);

  @override
  _MyEditPageState createState() => _MyEditPageState();
}

class _MyEditPageState extends State<MyEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyStandardAppBar('Edit'),
      endDrawer: MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MenuButton('Replace ONT', MyReplaceONTPage()),
            SizedBox(
              height: 100.0,
            ),
            MenuButton('Turn-Up Data Service', MyTurnUpPage()),
          ],
        ),
      ),
    );
  }
}
