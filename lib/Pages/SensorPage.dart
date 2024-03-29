import 'dart:async';
import 'package:K9Harness/Pages/HeartratePage.dart';
import 'package:K9Harness/Utilities/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../theme.dart';
import 'AllvitalsPage.dart';
import 'OxygenPage.dart';
import 'TemperaturePage.dart';

import 'package:K9Harness/my_globals.dart';

class SensorPage extends StatefulWidget {
  final BluetoothDevice device;
  SensorPage({Key key, @required this.device}) : super(key: key);

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  final String SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  final String CHARACTERISTIC_UUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

  //initialize stream here?
  List<double> traceDust = [];

  int selectedIndex = 0;
  List<Widget> widgetOptions;

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    widgetOptions = <Widget>[
      AllvitalsPage(device: widget.device),
      HeartratePage(device: widget.device),
      OxygenPage(device: widget.device),
      TempPage(device: widget.device),
    ];

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: myFirstAppBar(),
        body: widgetOptions[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "All Vitals",
              backgroundColor: ButtonColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesome.heartbeat),
              label: "Heart Rate",
              backgroundColor: ButtonColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.airballoon),
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
      ),
    );
  }
}
