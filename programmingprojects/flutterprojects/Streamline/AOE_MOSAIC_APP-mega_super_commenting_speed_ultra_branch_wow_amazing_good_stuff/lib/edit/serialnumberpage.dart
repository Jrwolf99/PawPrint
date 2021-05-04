import 'package:aoe_mosaic_app/edit/newserialnumberpage.dart';
import 'package:aoe_mosaic_app/utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:aoe_mosaic_app/ui_theme.dart';
import 'package:aoe_mosaic_app/utilities/api_calls.dart';
import 'package:aoe_mosaic_app/utilities/form.dart';
import 'dart:async';
import '../utilities/models.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:developer';


class MySerialNumberPage extends StatefulWidget {
  @override
  _MySerialNumberPageState createState() => new _MySerialNumberPageState();
}

class _MySerialNumberPageState extends State<MySerialNumberPage> {
  final _formKey = GlobalKey<FormState>();
  static final List<String> fieldNames = [
    "ONT Serial Number",
  ];
  TextEditingController input = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  static Future<List<dynamic>> formCallbackSerialNumber(BuildContext context, var responses) async {
    // Do retrieve call and store result
    String retrieveResult = await SerialNumberRetrieveCall(responses[0]);
    log(retrieveResult);
    final myModel = Provider.of<APIMetaData>(context, listen: false);
    myModel.setRetrieveServiceResult(retrieveResult);

    final document = XmlDocument.parse(myModel.retrieveServiceResult);
    String subscriberID = document.findAllElements('subscriberId').single.innerText.toString();

    // Title, Text, Route
    return ['Subscriber Found!', 'Subscriber ID: $subscriberID', fieldNames];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyStandardAppBar('ONT Serial Number'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              FormNextButton(
                _formKey,
                [input],
                formCallbackSerialNumber,
                MyNewSerialNumberPage(),
              ),
              FormInput('ONT Serial Number', input),
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
