import 'package:flutter/material.dart';
import 'package:K9Harness/theme.dart';
import 'package:K9Harness/my_globals.dart';

class OxygenPage extends StatefulWidget {
  @override
  _OxygenPageState createState() => _OxygenPageState();
}

class _OxygenPageState extends State<OxygenPage> {
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

                      if (currentValue[0] == 'T') {
                        currentTemperatureValue = currentValue.substring(
                            (currentValue.indexOf("T") + 1),
                            currentValue.indexOf("H"));
                        currentHeartRateValue = currentValue.substring(
                            (currentValue.indexOf("H") + 1),
                            currentValue.indexOf("S"));
                        currentOxygenValue = currentValue.substring(
                            currentValue.indexOf("S") + 1,
                            currentValue.length - 1);
                        TemperatureList.add(
                            double.tryParse(currentTemperatureValue) ?? 0);
                        HeartRateList.add(
                            double.tryParse(currentHeartRateValue) ?? 0);
                        OxygenList.add(
                            double.tryParse(currentOxygenValue) ?? 0);
                      } else {
                        currentTemperatureValue = "err";
                        currentHeartRateValue = "err";
                        currentOxygenValue = "err";
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
                                  Text('Current SP02 Level: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue[900])),
                                  Text('$currentOxygenValue%',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          fontSize: 24)),
                                ]),
                          ),
                          Expanded(
                            flex: 1,
                            child: OxygenScope,
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
