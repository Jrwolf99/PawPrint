import 'package:flutter/material.dart';
import 'package:K9Harness/theme.dart';
import 'package:flutter_blue/flutter_blue.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AccentColor2,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                  height: 50,
                ),
                FlatButton.icon(
                  icon: Icon(Icons.bluetooth),
                  label: Text(
                    'Bluetooth Connect',
                    style: TextStyle(fontSize: 25),
                  ),
                  color: AccentColor2,
                  onPressed: () {
                    Navigator.pushNamed(context, '/second');
                  },
                  textColor: AccentColor,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                  height: 50,
                ),
                FlatButton.icon(
                    icon: Icon(Icons.info_outline),
                    label: Text(
                      'Info',
                      style: TextStyle(fontSize: 25),
                    ),
                    color: AccentColor2,
                    onPressed: () {
                      Navigator.pushNamed(context, '/third');
                    },
                    textColor: AccentColor,
                    padding: const EdgeInsets.fromLTRB(10, 0, 100, 0)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
