import 'package:aoe_mosaic_app/edit/newserialnumberpage.dart';
import 'package:aoe_mosaic_app/utilities/api_calls.dart';
import 'package:aoe_mosaic_app/utilities/form.dart';
import 'package:flutter/material.dart';
import 'package:aoe_mosaic_app/utilities/utility.dart';
import 'package:aoe_mosaic_app/ui_theme.dart';
import 'package:provider/provider.dart';
import 'package:aoe_mosaic_app/utilities/models.dart';
import 'package:xml/xml.dart';
import 'dart:developer';

class MySubscriberIDPage extends StatelessWidget {
  static final List<String> fieldNames = [
    "Subscriber ID",
  ];

  static Future<List<dynamic>> formCallbackSubscriberID(BuildContext context, var responses) async {
    // Do retrieve call and store result
    String retrieveResult = await SubscriberIDRetrieveCall(responses[0]);
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
      appBar: MyStandardAppBar('Subscriber ID'),
      body: SingleChildScrollView(
        child: MyCustomForm(
          fieldNames,
          formCallbackSubscriberID,
          MyNewSerialNumberPage(),
        ),
      ),
    );
  }
}
