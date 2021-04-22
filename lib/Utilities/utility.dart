import 'package:flutter/material.dart';
import 'package:K9Harness/my_globals.dart';
import 'dart:convert' show utf8;
import 'dart:async';
import 'package:K9Harness/main.dart';
import 'package:flutter_blue/flutter_blue.dart';

void updateVitalLists() {
  if (currentValue != null)
    myErrorWatchdogTimer
        .cancel(); //stop the timer if good data has come through.
  currentTemperatureValue = currentValue.substring(
      (currentValue.indexOf("T") + 1), currentValue.indexOf("H"));
  currentHeartRateValue = currentValue.substring(
      (currentValue.indexOf("H") + 1), currentValue.indexOf("S"));
  currentOxygenValue = currentValue.substring(
      currentValue.indexOf("S") + 1, currentValue.length - 1);

  TemperatureList.add(double.tryParse(currentTemperatureValue) ?? 0);
  HeartRateList.add(double.tryParse(currentHeartRateValue) ?? 0);
  OxygenList.add(double.tryParse(currentOxygenValue) ?? 0);
}

void errorLists(BuildContext context, BluetoothDevice device) {
  //start the error timer, and the callback function in the timer will reach 10
  //seconds and then alert the user that an error has occurred.
  myErrorWatchdogTimer =
      startTimer(context, device); //call the startTimer function.
  // currentTemperatureValue = "err";
  // currentHeartRateValue = "err";
  // currentOxygenValue = "err";
}

String dataParser(List<int> dataFromDevice) {
  debugPrint("current value is-> ${utf8.decode(dataFromDevice)}");
  return utf8.decode(dataFromDevice);
}

//start the timer, and after 10 seconds alert user of error.

Timer startTimer(BuildContext context, BluetoothDevice device) {
  final List<dynamic> args = ["Error Occurred", "Reconnect Dog."];
  return Timer(Duration(seconds: 10), () {
    showDialog(
      context: context,
      builder: (ctx) => (CustomAlertDialogBox(args, device)),
    );
  });
}

class CustomAlertDialogBox extends StatelessWidget {
  final List<dynamic> args;
  final BluetoothDevice device;

  CustomAlertDialogBox(this.args, this.device);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(args[0]),
      content: Text(args[1]),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            device.disconnect();
            RestartWidget.restartApp(context);
          },
          child: Text("Close"),
        ),
      ],
    );
  }
}
