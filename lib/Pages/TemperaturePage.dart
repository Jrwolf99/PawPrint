import 'package:flutter/material.dart';
import 'package:K9Harness/theme.dart';
import 'package:K9Harness/my_globals.dart';

class TempPage extends StatefulWidget {
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

                    if (snapshot.connectionState == ConnectionState.active) {
                      debugPrint("snapshot.error: ${snapshot.error}.");
                      debugPrint("snapshot.data: ${snapshot.error}.");
                      debugPrint(
                          "snapshot.connectionState: ${snapshot.connectionState}.");
                      debugPrint("snapshot.hasdata?: ${snapshot.hasData}.");

                      var currentValue = dataParser(snapshot.data);
                      debugPrint(currentValue);

                      if (currentValue[0] == 'H') {
                        currentHeartRateValue =
                            currentValue.substring(1, currentValue.length - 1);
                        HeartRateList.add(
                            double.tryParse(currentHeartRateValue) ?? 0);
                      }

                      if (currentValue[0] == 'S') {
                        currentOxygenValue =
                            currentValue.substring(1, currentValue.length - 1);
                        OxygenList.add(
                            double.tryParse(currentOxygenValue) ?? 0);
                      }

                      if (currentValue[0] == 'T') {
                        currentTemperatureValue =
                            currentValue.substring(1, currentValue.length - 1);
                        TemperatureList.add(
                            double.tryParse(currentTemperatureValue) ?? 0);
                      }
                      //finally, return the stateless page with the value that we want: (currentTemperatureValue etc.)
                      //this includes an updated scope on the page.
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Current Temperature: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.purple[900])),
                                  Text('$currentTemperatureValue',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple,
                                          fontSize: 24)),
                                ]),
                          ),
                          Expanded(
                            flex: 1,
                            child: TemperatureScope,
                          ),
                        ],
                      ));
                    } else {
                      return Text('Check the stream');
                    }
                  },
                ),
              ));
  }
}
