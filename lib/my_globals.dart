import 'dart:async';
import 'dart:convert' show utf8;
import 'package:flutter/material.dart';

var currentHeartRateValue;
var currentOxygenValue;
var currentTemperatureValue;
//Stream<List<int>> mystream;

StreamController<List<int>> mystream = StreamController<List<int>>.broadcast();

bool isReady;

List<double> HeartRateList = List();
List<double> OxygenList = List();
List<double> TemperatureList = List();

String dataParser(List<int> dataFromDevice) {
  debugPrint("current value is-> ${utf8.decode(dataFromDevice)}");
  return utf8.decode(dataFromDevice);
}
