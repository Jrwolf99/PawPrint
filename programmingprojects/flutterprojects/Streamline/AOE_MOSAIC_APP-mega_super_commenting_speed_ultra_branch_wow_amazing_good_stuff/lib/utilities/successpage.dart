import 'package:aoe_mosaic_app/ui_theme.dart';
import 'package:aoe_mosaic_app/utilities/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../splashscreen.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PageArguments args = ModalRoute.of(context).settings.arguments;

    var responseReceiptWidgets = List<Widget>();
    for (var i = 0; i < args.fieldNames.length; i++) {
      responseReceiptWidgets.add(Opacity(
        opacity: 0.8,
        child: Card(
          color: AdtranColor,
          margin: EdgeInsets.all(11),
          child: ListTile(
            title: Text(
              args.fieldNames[i] + ": " + args.responses[i],
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17.0,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 1.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: MyStandardAppBar(args.title),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.green,
                  ),
                  margin: EdgeInsets.all(10),
                  child: Text(
                    args.text,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Source Sans Pro',
                        fontSize: 27),
                  ),
                  padding: EdgeInsets.all(10),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: responseReceiptWidgets,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.all(10),
        height: 60,
        child: FittedBox(
          child: FloatingActionButton.extended(
            backgroundColor: AdtranButtonColor,
            label: Text(
              'Continue',
              style: TextStyle(
                fontFamily: "Source Sans Pro",
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              if (args.clearPreviousPages != null) {
                Navigator.of(context).popUntil((route) => (route.isFirst));
              } else {
                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(
                    arguments: args.nextRouteArgs,
                  ),
                  screen: args.nextRoute,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
