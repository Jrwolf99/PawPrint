import 'package:flutter/material.dart';
import 'package:K9Harness/my_globals.dart';
import 'dart:convert' show utf8;
import 'dart:async';
import 'package:K9Harness/main.dart';
import 'package:flutter_blue/flutter_blue.dart';

void passToLists(BuildContext context, BluetoothDevice device) {
  Timer HRErrorTimer = startTimer(
      context, device, "Bad Heart Rate data. Try reconnecting to K9.");
  Timer TEMPErrorTimer = startTimer(
      context, device, "Bad Temperature data. Try reconnecting to K9.");
  Timer SPO2ErrorTimer =
      startTimer(context, device, "Bad SP02 data. Try reconnecting to K9.");

  if (myErrorWatchdogTimer != null)
    myErrorWatchdogTimer
        .cancel(); //stop the timer if good data has come through.

  //parse out the data into the three separate numbers.
  currentTemperatureValue = currentValue.substring(
      (currentValue.indexOf("T") + 1), currentValue.indexOf("H"));
  currentHeartRateValue = currentValue.substring(
      (currentValue.indexOf("H") + 1), currentValue.indexOf("S"));
  currentOxygenValue = currentValue.substring(
      currentValue.indexOf("S") + 1, currentValue.length - 1);

  //convert values to double
  double currTempValue = double.tryParse(currentTemperatureValue);
  double currHRValue = double.tryParse(currentHeartRateValue);
  double currOxValue = double.tryParse(currentOxygenValue);

  //add to temp list if in good range
  if (TemperatureList.isNotEmpty) {
    //create our previous bool values
    double prevTempValue = TemperatureList.last;
    double prevHRValue = HeartRateList.last;
    double prevOxValue = OxygenList.last;

    //start TEMP error timer if TEMP data is out of range.
    if (currTempValue <= .75 * prevTempValue &&
        currTempValue >= 1.25 * prevTempValue) {
      debugPrint("---KEEP ERROR TIMER FOR TEMP---");
      return;
    } else if (TEMPErrorTimer.isActive) {
      debugPrint("---CANCELLING TIMER TEMP---");
      TEMPErrorTimer.cancel();
    }

    //start HR error timer if HR data is out of range.
    if (currHRValue <= .75 * prevHRValue && currHRValue >= 1.25 * prevHRValue) {
      debugPrint("---KEEP ERROR TIMER FOR HR---");
      return;
    } else if (HRErrorTimer.isActive) {
      debugPrint("---CANCELLING HR TEMP---");
      HRErrorTimer.cancel();
    }

    //add to Oxygen list if in good range
    if (currOxValue <= (prevOxValue - 5) && currOxValue >= (prevOxValue + 5)) {
      debugPrint("---KEEP ERROR TIMER FOR SPO2---");
      return;
    } else if (SPO2ErrorTimer.isActive) {
      debugPrint("---CANCELLING SPO2 TEMP---");
      SPO2ErrorTimer.cancel();
    }
  }

  TemperatureList.add(currTempValue ?? 0);
  HeartRateList.add(currHRValue ?? 0);
  OxygenList.add(currOxValue ?? 0);
}

void errorLists(BuildContext context, BluetoothDevice device) {
  //start the error timer, and the callback function in the timer will reach 10
  //seconds and then alert the user that an error has occurred.
  myErrorWatchdogTimer = startTimer(context, device,
      "Bad radio data transmission. Numbers were not in the proper format."); //call the startTimer function.
}

String dataParser(List<int> dataFromDevice) {
  debugPrint("current value is-> ${utf8.decode(dataFromDevice)}");
  return utf8.decode(dataFromDevice);
}

//start the timer, and after 10 seconds alert user of error.

Timer startTimer(BuildContext context, BluetoothDevice device, String desc) {
  final List<dynamic> args = ["Error Occurred", "$desc"];
  return Timer(Duration(seconds: 20), () {
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
