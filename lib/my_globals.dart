import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';

var currentValue;

var currentHeartRateValue;
var currentOxygenValue;
var currentTemperatureValue;

StreamController<List<int>> mystream = StreamController<List<int>>.broadcast();

bool isReady;

List<double> HeartRateList = [];
List<double> OxygenList = [];
List<double> TemperatureList = [];

Oscilloscope HeartRateScope = Oscilloscope(
  showYAxis: true,
  backgroundColor: Colors.black,
  traceColor: Colors.teal,
  yAxisMax: 250.0,
  yAxisMin: 20.0,
  dataSet: HeartRateList,
);
Oscilloscope OxygenScope = Oscilloscope(
  showYAxis: true,
  backgroundColor: Colors.black,
  traceColor: Colors.blue,
  yAxisMax: 120.0,
  yAxisMin: 80.0,
  dataSet: OxygenList,
);
Oscilloscope TemperatureScope = Oscilloscope(
  showYAxis: true,
  backgroundColor: Colors.black,
  traceColor: Colors.purple,
  yAxisMax: 120.0,
  yAxisMin: 80.0,
  dataSet: TemperatureList,
);

Timer myErrorWatchdogTimer;
