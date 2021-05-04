import 'package:flutter/material.dart';

import 'subscriberidpage.dart';
import 'serialnumberpage.dart';
import 'originalontlocation.dart';
import '../utilities/utility.dart';
import '../ui_theme.dart';

class MyReplaceONTPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyStandardAppBar('Replace ONT'),
      endDrawer: MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MenuButton('Subscriber ID', MySubscriberIDPage()),
            MenuButton('Original ONT Serial Number', MySerialNumberPage()),
            MenuButton('Original ONT Location', MyOriginalONTLocation()),
          ],
        ),
      ),
    );
  }
}
