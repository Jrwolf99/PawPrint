import 'package:aoe_mosaic_app/edit/editpage.dart';
import 'package:flutter/material.dart';
import 'package:aoe_mosaic_app/ui_theme.dart';
import 'package:aoe_mosaic_app/utilities/utility.dart';
import 'package:aoe_mosaic_app/utilities/api_calls.dart';
import 'package:aoe_mosaic_app/utilities/form.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';
import '../utilities/models.dart';
import 'dart:developer';

class MyNewSerialNumberPage extends StatefulWidget {
  @override
  _MyNewSerialNumberPageState createState() => new _MyNewSerialNumberPageState();
}

class _MyNewSerialNumberPageState extends State<MyNewSerialNumberPage> {
  final _formKey = GlobalKey<FormState>();
  static final List<String> fieldNames = [
    "New ONT Serial Number",
  ];
  TextEditingController input = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  static Future<List<dynamic>> formCallbackNewSerialNumber(BuildContext context, var responses) async {

    final myModel = Provider.of<APIMetaData>(context, listen: false);
    final document = XmlDocument.parse(myModel.retrieveServiceResult);

    String subscriberID = document.findAllElements('subscriberId').single.innerText.toString();
    log(subscriberID);

    String deleteResult = await deleteServiceCall(subscriberID);
    log(deleteResult);

    String activateServiceResult = await activateServiceCall(myModel.retrieveServiceResult, responses[0]);
    log(activateServiceResult);

    // Once finished activating service, reset values
    myModel.clearValues();

    // Title, Text, Route
    return [
      'Reflow Complete!',
      'Subscriber ID: $subscriberID',
      fieldNames,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyStandardAppBar('New Serial Number'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              FormNextButton(
                _formKey,
                [input],
                formCallbackNewSerialNumber,
                MyEditPage(),
                clearPreviousPages: true,
              ),
              FormInput('New Serial Number', input),
              SmallButtonAction('Scan', scan),
            ],
          ),
        ),
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.input.text = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print('Camera permission not granted');
      } else {
        print('Unknown error: $e');
      }
    } on FormatException {
      print(
          'null {User returned using the "back"-button before scanning anything, Result)');
    } catch (e) {
      print('Unknown error: $e');
    }
  }
}
