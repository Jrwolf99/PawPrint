import 'package:K9Harness/Utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:K9Harness/theme.dart';
import 'package:K9Harness/my_globals.dart';
import 'package:flutter_blue/flutter_blue.dart';

class TempPage extends StatefulWidget {
  const TempPage({this.device});
  final BluetoothDevice device;
  @override
  _TempPageState createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: !isReady
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Waiting for device to connect... Click to another page down below. If that does not work, try to disconnect the phone or tablet from bluetooth and try to reconnect.",
                    style: TextStyle(fontSize: 14, color: ButtonColor),
                  ),
                ),
              )
            : Container(
                child: StreamBuilder<List<int>>(
                  //this streambuilder takes the snapshot of the incoming stream called "stream"
                  //and builds a snapshot of the data given.
                  stream: mystream.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<int>> snapshot) {
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');

                    if ((snapshot.connectionState == ConnectionState.active) &&
                        snapshot.data != null) {
                      // debugPrint("snapshot.error: ${snapshot.error}.");
                      // debugPrint("snapshot.data: ${snapshot.error}.");
                      // debugPrint(
                      //     "snapshot.connectionState: ${snapshot.connectionState}.");
                      // debugPrint("snapshot.hasdata?: ${snapshot.hasData}.");

                      currentValue = dataParser(snapshot.data);
                      debugPrint(currentValue);

                      //check if SPO2 data is 2 or more characters:
                      bool SPO2Check = false;
                      if (currentValue.contains("S")) {
                        SPO2Check = false;
                        int SP02CheckCount = 0;
                        //scan from the number directly after "S" to the end of the array
                        //and count the amount of characters.
                        for (int i = (currentValue.indexOf("S") + 1);
                            i < currentValue.length();
                            i++) {
                          SP02CheckCount++;
                        }
                        //if the
                        if (SP02CheckCount >= 2) {
                          SPO2Check = true;
                        }
                      }

                      //if the data is good to be graphed
                      if (currentValue != null) {
                        //if the data is good to be graphed
                        if ((currentValue.contains("T")) &&
                            (currentValue.contains("H")) &&
                            (currentValue.contains("S")) &&
                            (SPO2Check)) {
                          //if the data is ALSO within good range of previous value, print.

                          passToLists(context, widget.device);
                        } else {
                          errorLists(context, widget.device);
                        }
                      }

                      //finally, return the stateless page with the value that we want: (currentTemperatureValue etc.)
                      //this includes an updated scope on the page.
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child:
                                      disconnect_button(context, widget.device),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Current Temperature: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.purple[900])),
                                  Text('$currentTemperatureValue°F',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple,
                                          fontSize: 24)),
                                ]),
                          ),
                          Expanded(
                            flex: 6,
                            child: TemperatureScope,
                          ),
                        ],
                      ));
                    } else {
                      return Center(child: Text('Waiting...'));
                    }
                  },
                ),
              ));
  }
}
