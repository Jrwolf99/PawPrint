import 'package:K9Harness/Pages/BluetoothPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:K9Harness/theme.dart';
import 'package:flutter_blue/flutter_blue.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String k9connection = 'disconnected';

  @override
  Widget build(BuildContext context) {
    double appHeight = MediaQuery.of(context).size.height;
    double appWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: (appHeight / 8),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      width: appWidth,
                      height: appHeight / 8,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5);
                              return null; // Use the component's default.
                            },
                          ),
                        ),
                        child: Text(
                          'Search for K9 Unit',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        onPressed: (() {
                          Navigator.pushNamed(context, '/second');
                          return FlutterBlue.instance
                              .startScan(
                                  scanMode: ScanMode.balanced,
                                  withServices: [
                                    Guid("6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
                                  ],
                                  timeout: Duration(seconds: 4))
                              .catchError(
                            (error) {
                              print("error starting scan $error");
                            },
                          );
                        }),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              "Currently the K9 is $k9connection.",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            drawerButton('Information', Icons.info_outline, context, '/third'),
          ],
        ),
      ),
    );
  }
}

Widget drawerButton(
        String name, IconData icon, BuildContext context, String route) =>
    Row(
      children: [
        SizedBox(
          width: 10,
          height: 50,
        ),
        TextButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Theme.of(context).colorScheme.primary.withOpacity(0);
                return null; // Use the component's default.
              },
            ),
          ),
          icon: Icon(icon),
          label: Text(
            '$name',
          ),
          onPressed: () {
            Navigator.pushNamed(context, '$route');
          },
        ),
      ],
    );
