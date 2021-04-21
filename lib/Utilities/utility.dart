import 'package:flutter/material.dart';
import 'package:K9Harness/my_globals.dart';
import 'dart:convert' show utf8;

void updateVitalLists() {
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
  currentTemperatureValue = "err";
  currentHeartRateValue = "err";
  currentOxygenValue = "err";
}

String dataParser(List<int> dataFromDevice) {
  debugPrint("current value is-> ${utf8.decode(dataFromDevice)}");
  return utf8.decode(dataFromDevice);
}
