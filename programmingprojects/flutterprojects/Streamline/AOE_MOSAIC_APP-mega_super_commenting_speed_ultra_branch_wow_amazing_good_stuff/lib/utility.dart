import 'package:aoe_mosaic_app/settingspage.dart';
import 'package:aoe_mosaic_app/ui_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class PageArguments {
  final String title;
  final String text;
  final Widget nextRoute;
  final List<String> fieldNames;
  final List<String> responses;
  final PageArguments nextRouteArgs;
  final bool clearPreviousPages;

  PageArguments(
      {this.title,
      this.text,
      this.nextRoute,
      this.nextRouteArgs,
      this.fieldNames,
      this.responses,
      this.clearPreviousPages});
}

class MenuButton extends StatelessWidget {
  final buttonText;
  final route;
  final args;
  MenuButton(this.buttonText, this.route, {this.args});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 350,
      child: RaisedButton(
        color: AdtranButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
            color: Colors.black12,
            width: 2,
          ),
        ),
        child: Text(
          '$buttonText',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Source Sans Pro',
            fontSize: 27,
          ),
        ),
        onPressed: () {
          if (args == null) {
            pushNewScreen(
              context,
              screen: this.route,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          } else {
            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(
                arguments: args,
              ),
              screen: this.route,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          }
        },
      ),
    );
  }
}

class SmallButtonAction extends StatelessWidget {
  final buttonText;
  final action;

  SmallButtonAction(this.buttonText, this.action);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 125,
      child: RaisedButton(
        color: AdtranButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.black12,
            width: 2,
          ),
        ),
        child: Text(
          '$buttonText',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Source Sans Pro',
            fontSize: 20,
          ),
        ),
        onPressed: action,
      ),
    );
  }
}

//This widget is a drawer button used in the drawer to access settings, and future options
class DrawerButton extends StatelessWidget {
  final String title;
  final IconData icon;

  DrawerButton(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => pushNewScreen(
        context,
        screen: MySettingsPage(),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 20,
            ),
            Text(
              '$title',
              style: TextStyle(fontFamily: 'Source Sans Pro', fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
