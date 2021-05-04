import 'package:aoe_mosaic_app/utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:aoe_mosaic_app/utilities/form.dart';

const Color AdtranColor = Color(0xFF0277bd);
const Color AdtranButtonColor = Color.fromRGBO(2, 119, 189, 1);

const Color AppBarColor1 = Color(0xFF0277bd); // start of gradient
const Color AppBarColor2 = Color(0xFF72c9fe); // end of gradient

const Color AdtranAccentColor = Color(0xFF00d0e7);

class MyAppBarGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppBarColor1, AppBarColor2],
        ),
      ),
    );
  }
}

Widget myEntryBox(String title, String text) {
  return Container(
    child: Column(
      children: [
        Container(
            width: 320,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(width: 2.0),
              color: AdtranColor,
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Source Sans Pro',
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        Container(
          width: 320,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(width: 2.0),
            color: Colors.grey,
          ),
          child: Center(
            child: FormInput(text, TextEditingController()),
          ),
        ),
      ],
    ),
  );
}

//This Custom Standard App Bar is a stateless widget so buttons can interact with the rest of the app.
class MyStandardAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String text;

  MyStandardAppBar(this.text, {Key key})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          text,
          style: TextStyle(
            fontFamily: 'Source Sans Pro',
            shadows: [
              Shadow(
                blurRadius: 1.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          Container(
            width: 100,
            child: Image(
              image: AssetImage('images/adtran_white.png'),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer()),
        ],
        flexibleSpace: MyAppBarGradient(),
      ),
    );
  }
}

//This Custom Standard App Bar is a stateless widget so buttons can interact with the rest of the app.
class MyStandardAppBarWithoutMenuIcon extends StatelessWidget
    with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String text;

  MyStandardAppBarWithoutMenuIcon(this.text, {Key key})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          text,
          style: TextStyle(
            fontFamily: 'Source Sans Pro',
            shadows: [
              Shadow(
                blurRadius: 1.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          Container(
            width: 100,
            child: Image(
              image: AssetImage('images/adtran_white.png'),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
        flexibleSpace: MyAppBarGradient(),
      ),
    );
  }
}

//A custom drawer implemented as an endDrawer throughout the app.
class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(15.0),
        children: [
          DrawerHeader(
            child: Card(
              color: AdtranButtonColor,
              child: Image(
                image: AssetImage('images/adtran_white.png'),
              ),
            ),
          ),
          DrawerButton('Settings', Icons.settings),
        ],
      ),
    );
  }
}
