import 'package:aoe_mosaic_app/pagemenu.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'ui_theme.dart';


class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdtranColor,
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 250.0, 20.0, 10.0),
                child: Image.asset('images/adtran_white.png'),
              ),
              Text(
                'Streamline',
                style: TextStyle(fontSize: 40.0, color: Colors.white),
              ),
              SizedBox(
                height: 120.0,
              ),
              Container(
                height: 70,
                child: FittedBox(
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.white,
                    label: Text(
                      'Start',
                      style: TextStyle(
                        fontFamily: "Source Sans Pro",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AdtranColor,
                      ),
                    ),
                    onPressed: () {
                      pushNewScreen(
                        context,
                        screen: MyPageMenu(),
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
