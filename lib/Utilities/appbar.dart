import 'package:flutter/material.dart';
import '../theme.dart';

Widget myAppBar() {
  return AppBar(
    centerTitle: true,
    backgroundColor: ButtonColor,
    title: Text(
      'PawPrint',
      style: TextStyle(
        color: MainColor,
        fontFamily: 'Amaranth',
        fontSize: 28,
      ),
    ),
    actions: <Widget>[
      Container(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image(
            image: AssetImage('images/lightbluepaw.png'),
          ),
        ),
      ),
      SizedBox(
        width: 100,
      )
    ],
  );
}
