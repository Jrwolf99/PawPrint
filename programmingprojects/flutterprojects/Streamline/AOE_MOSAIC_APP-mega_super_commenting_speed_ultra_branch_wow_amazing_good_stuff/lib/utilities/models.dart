import 'package:flutter/foundation.dart';

class APIMetaData with ChangeNotifier {
  String retrieveServiceResult = '';

  void setRetrieveServiceResult(String s) {
    retrieveServiceResult = s;
  }

  void clearValues() {
    retrieveServiceResult = '';
  }
}