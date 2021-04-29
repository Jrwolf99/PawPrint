import 'package:flutter/material.dart';
import 'package:K9Harness/my_globals.dart';
import 'dart:convert' show utf8;
import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:K9Harness/main.dart';

void passToLists(BuildContext context, BluetoothDevice device) {
  bool goodTempData = true;
  bool goodHRData = true;
  bool goodOxData = true;

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
  debugPrint("here is the curr temp val: " + "$currTempValue");
  debugPrint("here is the curr HR val: " + "$currHRValue");
  debugPrint("here is the curr Ox val: " + "$currOxValue");

  //create our previous bool values
  double prevTempValue = TemperatureList.last;
  double prevHRValue = HeartRateList.last;
  double prevOxValue = OxygenList.last;

  debugPrint("here is the last temp val: " + "$prevTempValue");
  debugPrint("here is the last HR val: " + "$prevHRValue");
  debugPrint("here is the last Ox val: " + "$prevOxValue");

  //start TEMP error timer if TEMP data is out of range.
  if ((currTempValue <= (.75 * prevTempValue)) &&
      (currTempValue >= (1.25 * prevTempValue))) {
    goodTempData = false; //received bad temp data
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text("Out Of Range Temperature Data"),
    //     duration: const Duration(seconds: 2),
    //   ),
    // );
  }
  if (goodTempData) {
    TemperatureList.add(currTempValue ?? 0);
  }

  //start HR error timer if HR data is out of range.
  if ((currHRValue <= (.25 * prevHRValue)) &&
      (currHRValue >= (1.75 * prevHRValue))) {
    goodHRData = false; //received bad HR data
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text("Out Of Range Heart Rate Data"),
    //     duration: const Duration(seconds: 2),
    //   ),
    // );
  }
  if (goodHRData) {
    HeartRateList.add(currHRValue ?? 0);
  }

  //add to Oxygen list if in good range
  if ((currOxValue <= (prevOxValue - 5)) &&
      (currOxValue >= (prevOxValue + 5))) {
    goodOxData = false;
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text("Out Of Range SPO2 Data"),
    //     duration: const Duration(seconds: 2),
    //   ),
    // );
  }
  if (goodOxData) {
    OxygenList.add(currOxValue ?? 0);
  }

  if (TemperatureList.length == 1) TemperatureList.add(currTempValue ?? 0);
  if (OxygenList.length == 1) OxygenList.add(currOxValue ?? 0);
  if (HeartRateList.length == 1) HeartRateList.add(currHRValue ?? 0);
}

void errorLists(BuildContext context, BluetoothDevice device) {
  //start the error timer, and the callback function in the timer will reach 20
  //seconds and then alert the user that an error has occurred.
  myErrorWatchdogTimer = startTimer(context, device,
      "Bad radio data transmission."); //call the startTimer function.
}

String dataParser(List<int> dataFromDevice) {
  debugPrint("current value is-> ${utf8.decode(dataFromDevice)}");
  return utf8.decode(dataFromDevice);
}

//start the timer, and after 10 seconds alert user of error.

Timer startTimer(BuildContext context, BluetoothDevice device, String desc) {
  return Timer(Duration(seconds: 5), () {
    SnackBar(
      content: Text("currently receiving bad data..."),
      duration: const Duration(seconds: 1),
    );
    // showDialog(
    //   context: context,
    //   builder: (ctx) => (CustomAlertDialogBox(args, device)),
    // );
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
            Navigator.pushReplacementNamed(context, '/second');
          },
          child: Text("Close"),
        ),
      ],
    );
  }
}

Widget disconnect_button(BuildContext context, BluetoothDevice device) {
  return ElevatedButton(
    child: Text(
      'Disconnect',
      style: TextStyle(fontSize: 15, color: Colors.white),
    ),
    onPressed: (() {
      device.disconnect();
      RestartWidget.restartApp(context);
    }),
  );
}
