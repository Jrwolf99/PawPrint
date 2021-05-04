import 'package:aoe_mosaic_app/edit/newserialnumberpage.dart';
import 'package:aoe_mosaic_app/utilities/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:aoe_mosaic_app/ui_theme.dart';
import 'package:aoe_mosaic_app/utilities/form.dart';
import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';
import '../utilities/models.dart';

class MyOriginalONTLocation extends StatelessWidget {
  static final List<String> fieldNames = [
    "IP Address",
    "System Name",
    "Slot",
    "PON",
    "ONT"
  ];

  static Future<List<dynamic>> formCallbackONTLocation(BuildContext context, var responses) async {
    String retrieveResult = await ONTLocationRetrieveCall(responses[0], responses[1], responses[2], responses[3], responses[4]);
    log(retrieveResult);
    final myModel = Provider.of<APIMetaData>(context, listen: false);
    myModel.setRetrieveServiceResult(retrieveResult);

    final document = XmlDocument.parse(myModel.retrieveServiceResult);
    String serialNumber = document.findAllElements('ontSerialNo').single.innerText.toString();
    log(serialNumber);

    // Title, Text, Route
    return ['Subscriber Found!', 'ONT Serial #: $serialNumber', fieldNames];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyStandardAppBar('ONT Location'),
      body: SingleChildScrollView(
        child: MyCustomForm(
          fieldNames,
          formCallbackONTLocation,
          MyNewSerialNumberPage()
        ),
      ),
    );
  }
}