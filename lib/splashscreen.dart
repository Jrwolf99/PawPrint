import 'package:K9Harness/Pages/allvitals.dart';
import 'package:K9Harness/Utilities/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'theme.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MainColor,
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, .13 * _height, 0, 0),
                    height: 200,
                    width: 450,
                    child: Image.asset('images/ekg1.png'),
                  ), //EKG line picture
                  Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Text(
                        'PawPrint',
                        style: TextStyle(
                          fontSize: 80.0,
                          color: ButtonColor,
                          fontFamily: "Amaranth",
                        ),
                      ),
                    ),
                  ), //pawprint text
                  Container(
                    margin:
                        EdgeInsets.fromLTRB(0.15 * _width, .35 * _height, 0, 0),
                    height: 300,
                    width: 300,
                    child: Image.asset('images/Bluepaw.png'),
                  ), //Bluepaw picture
                  Container(
                    margin:
                        EdgeInsets.fromLTRB(0.6 * _width, 0.85 * _height, 0, 0),
                    height: 80,
                    width: 140,
                    child: FittedBox(
                      child: FloatingActionButton.extended(
                        backgroundColor: ButtonColor,
                        label: Text(
                          'Start',
                          style: TextStyle(
                            fontFamily: "Source Sans Pro",
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AccentColor,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/first');
                        },
                      ),
                    ),
                  ), //Start Button
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
