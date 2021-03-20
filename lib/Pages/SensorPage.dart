import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';

import 'package:K9Harness/Pages/HeartratePage.dart';
import 'package:K9Harness/Utilities/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oscilloscope/oscilloscope.dart';

import '../theme.dart';
import 'AllvitalsPage.dart';
import 'OxygenPage.dart';
import 'TemperaturePage.dart';

import 'package:K9Harness/my_globals.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;
  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  final String SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  final String CHARACTERISTIC_UUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

  //initialize stream here?
  List<double> traceDust = List();

  int selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    AllvitalsPage(),
    HeartratePage(),
    OxygenPage(),
    TempPage(),
  ];

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    //timeout timer, watchdog timer if you will
    new Timer(const Duration(seconds: 60), () {
      if (!isReady) {
        disconnectFromDevice();
        _Pop();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _Pop();
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            debugPrint("reached Here before isready sets pos!");
            debugPrint("isReady = " + isReady.toString());
            mystream.addStream(characteristic
                .value); //this line if mystream is a streamcontroller.
            //mystream = characteristic.value; //this line is if mystream is a stream and not a streamcontroller.
            setState(() {
              isReady = true;
            });
          }
        });
      }
    });

    if (!isReady) {
      _Pop();
    }
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    Oscilloscope HeartRateScope = Oscilloscope(
      showYAxis: true,
      backgroundColor: Colors.black,
      traceColor: Colors.green,
      yAxisMax: 50.0,
      yAxisMin: 0.0,
      dataSet: HeartRateList,
    );
    Oscilloscope OxygenScope = Oscilloscope(
      showYAxis: true,
      backgroundColor: Colors.black,
      traceColor: Colors.blue,
      yAxisMax: 50.0,
      yAxisMin: 0.0,
      dataSet: OxygenList,
    );
    Oscilloscope TemperatureScope = Oscilloscope(
      showYAxis: true,
      backgroundColor: Colors.black,
      traceColor: Colors.purple,
      yAxisMax: 50.0,
      yAxisMin: 0.0,
      dataSet: TemperatureList,
    );

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AccentColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "All Vitals",
            backgroundColor: ButtonColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            label: "Heart Rate",
            backgroundColor: ButtonColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: "SP02",
            backgroundColor: ButtonColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat_outlined),
            label: "Temperature",
            backgroundColor: ButtonColor,
          ),
        ],
        currentIndex: selectedIndex,
        onTap:
            onItemTap, //on item tap, go to the selected index, and update the current index to the
        /////////////////page that is desired: index of 0:Allvitalspage, 1:Heartrate, 2:oxygen, 3:temp
      ),
      appBar: myAppBar(),
      body: widgetOptions[selectedIndex],
    );
  }
}
