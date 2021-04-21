import 'package:flutter/material.dart';
import 'package:K9Harness/my_globals.dart';
import 'dart:convert' show utf8;
import 'dart:async';

void updateVitalLists() {
  myErrorWatchdogTimer.cancel(); //stop the timer if good data has come through.
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

void errorLists() {
  //start the error timer, and the callback function in the timer will reach 10
  //seconds and then alert the user that an error has occurred.
  myErrorWatchdogTimer = startTimer(); //call the startTimer function.
  currentTemperatureValue = "err";
  currentHeartRateValue = "err";
  currentOxygenValue = "err";
}

String dataParser(List<int> dataFromDevice) {
  debugPrint("current value is-> ${utf8.decode(dataFromDevice)}");
  return utf8.decode(dataFromDevice);
}

//start the timer, and after 10 seconds alert user of error.
Timer startTimer() {
  return Timer(Duration(seconds: 10), () {
    debugPrint("10 SECONDS REACHED!");
  });
}
