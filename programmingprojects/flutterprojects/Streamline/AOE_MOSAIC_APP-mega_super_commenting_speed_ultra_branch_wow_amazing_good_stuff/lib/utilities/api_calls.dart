import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

/* This is a serial number based retrieve call.
 * You send in a serial number, and it will return
 * the retrieve service response body when ready
 */
Future<String> SerialNumberRetrieveCall(var serialNumber) async {
  HttpOverrides.global = new MyHttpOverrides();
  final storage = new FlutterSecureStorage();
  /* These variables are set by the settings page input
     and used in the API call
   */
  var user = await storage.read(key: "user");
  var pass = await storage.read(key: "pass");
  var url = await storage.read(key: "url");

  var envelope = '''
<?xml version="1.0" encoding="utf-8" ?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:mod="http://models.ws.common.adtran.com"
xmlns:ns0="http://serviceactivation.models.ws.common.adtran.com">

   <soapenv:Header>
      <mod:aoewsHeader>
         <aoewss>
            <userName>$user</userName>
            <password>$pass</password>
         </aoewss>
      </mod:aoewsHeader>
   </soapenv:Header>
   <soapenv:Body>
      <ns0:retrieveServiceRequest>
        <serialNumberWrapper>
          <serialNumber>$serialNumber</serialNumber>
        </serialNumberWrapper>
      </ns0:retrieveServiceRequest>
   </soapenv:Body>
</soapenv:Envelope>
''';

  http.Response response = await http.post(url,
      headers: {
        "Content-Type": "text/xml; charset=utf-8",
      },
      body: envelope);

  return response.body;
}

/* This is a subscriber ID based retrieve call.
 * You send in a subscriber ID, and it will return
 * the retrieve service response body when ready
 */
Future<String> SubscriberIDRetrieveCall(var serviceName) async {
  HttpOverrides.global = new MyHttpOverrides();
  final storage = new FlutterSecureStorage();
  /* These variables are set by the settings page input
     and used in the API call
   */
  var user = await storage.read(key: "user");
  var pass = await storage.read(key: "pass");
  var url = await storage.read(key: "url");

  var envelope = '''
<?xml version="1.0" encoding="utf-8" ?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:mod="http://models.ws.common.adtran.com"
xmlns:ns0="http://serviceactivation.models.ws.common.adtran.com">
   <soapenv:Header>
      <mod:aoewsHeader>
         <aoewss>
            <userName>$user</userName>
            <password>$pass</password>
         </aoewss>
      </mod:aoewsHeader>
   </soapenv:Header>
   <soapenv:Body>
      <ns0:retrieveServiceRequest>
            <subscriberId>$serviceName</subscriberId>
      </ns0:retrieveServiceRequest>
   </soapenv:Body>
</soapenv:Envelope>
''';

  http.Response response = await http.post(url,
      headers: {
        "Content-Type": "text/xml; charset=utf-8",
      },
      body: envelope);

  return response.body;
}

/* This is an ONT Location based retrieve call.
 * You send in the IP address, system name, slot #, pon #, and ont #,
 * and it will return the retrieve service response body when ready
 */
Future<String> ONTLocationRetrieveCall(
    var IPAddress, var systemName, var slot, var pon, var ont) async {
  HttpOverrides.global = new MyHttpOverrides();
  final storage = new FlutterSecureStorage();
  /* These variables are set by the settings page input
     and used in the API call
   */
  //TODO make this a function
  var user = await storage.read(key: "user");
  var pass = await storage.read(key: "pass");
  var url = await storage.read(key: "url");

  var envelope = '''
<?xml version="1.0" encoding="utf-8" ?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:mod="http://models.ws.common.adtran.com"
xmlns:ns0="http://serviceactivation.models.ws.common.adtran.com">

   <soapenv:Header>
      <mod:aoewsHeader>
      <aoewss>
            <userName>$user</userName>
            <password>$pass</password>
         </aoewss>
      </mod:aoewsHeader>
   </soapenv:Header>
   <soapenv:Body>
      <ns0:retrieveServiceRequest>
            <equipment xsi:type="ns0:gpon_eqpt"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
               <ip_addr>$IPAddress</ip_addr>
               <systemName>$systemName</systemName>
               <shelf>1</shelf>
               <slot>$slot</slot>
               <ont>$ont</ont>
               <pon>$pon</pon>
            </equipment>
      </ns0:retrieveServiceRequest>
   </soapenv:Body>
</soapenv:Envelope>


''';

  http.Response response = await http.post(url,
      headers: {
        "Content-Type": "text/xml; charset=utf-8",
      },
      body: envelope);

  return response.body;
}

//This function takes the API call response in as
//a string and returns another string ready for the activate API call
Future<String> stringManipulationRetrieveToActivate(
    String myString, String newSerialNumber) async {
  final storage = new FlutterSecureStorage();
  var pass = await storage.read(key: "pass");
  //deletion of OperationStatus element
  String myStringPart1 =
      myString.substring(0, myString.indexOf("<operationStatus>"));
  String myStringPart2 =
      myString.substring((myString.indexOf("</operationStatus>") + 18));
  myString = myStringPart1 + myStringPart2;

  //add in the password
  myString = myString.replaceFirst(
      '<password></password>', '<password>$pass</password>');

  myString =
      myString.replaceAll("retrieveServiceResponse", "activateServiceRequest");

  myString = myString.replaceAll(RegExp('<ontSerialNo>.*</ontSerialNo>'),
      '<ontSerialNo>$newSerialNumber</ontSerialNo>');

  return myString;
}

/* This is a delete service API call.
 * You send in the subscriberID and return the
 * response of the deleted service call.
 */
Future<String> deleteServiceCall(var subscriberID) async {
  HttpOverrides.global = new MyHttpOverrides();
  final storage = new FlutterSecureStorage();
  var user = await storage.read(key: "user");
  var pass = await storage.read(key: "pass");
  var url = await storage.read(key: "url");

  var envelope = '''
<?xml version="1.0" encoding="utf-8" ?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
xmlns:mod="http://models.ws.common.adtran.com" 
xmlns:ser="http://serviceactivation.models.ws.common.adtran.com">
   <soapenv:Header>
      <mod:aoewsHeader>
         <aoewss>
            <userName>$user</userName>
            <password>$pass</password>
         </aoewss>
      </mod:aoewsHeader>
   </soapenv:Header>
   <soapenv:Body>
      <ser:deleteServiceRequest>
         <subscriberId>$subscriberID</subscriberId>
      </ser:deleteServiceRequest>
   </soapenv:Body>
</soapenv:Envelope>
  ''';

  http.Response response = await http.post(url,
      headers: {
        "Content-Type": "text/xml; charset=utf-8",
      },
      body: envelope);

  return response.body;
}

/* This is an activate service API call.
 * You send in the retrieveServiceResponse and
 * the newSerialNumber and return the
 * response of the activated service call.
 */
Future<String> activateServiceCall(
    String retrieveServiceResponse, String newSerialNumber) async {
  HttpOverrides.global = new MyHttpOverrides();
  String activateCall = await stringManipulationRetrieveToActivate(
      retrieveServiceResponse, newSerialNumber);

  //create a storage object and get the url
  final storage = new FlutterSecureStorage();
  var url = await storage.read(key: "url");

  http.Response response = await http.post(url,
      headers: {
        "Content-Type": "text/xml; charset=utf-8",
      },
      body: activateCall);

  return response.body;
}
