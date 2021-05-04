import 'package:aoe_mosaic_app/ui_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MySettingsPage extends StatefulWidget {
  @override
  _MySettingsPageState createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  static TextEditingController _userTextEditingController;
  static TextEditingController _passTextEditingController;
  static TextEditingController _urlTextEditingController;
  final storage = new FlutterSecureStorage();
  String _user = '';
  String _pass = '';
  String _url = '';

  @override
  void initState() {
    super.initState();
    _loadAllSettings();
    _userTextEditingController = TextEditingController(text: _user);
    _passTextEditingController = TextEditingController(text: _pass);
    _urlTextEditingController = TextEditingController(text: _url);
  }

  //Loading setting values on start
  _loadAllSettings() async {
    _user = (await storage.read(key: "user") ?? '');
    _userTextEditingController.text = _user;
    _pass = (await storage.read(key: "pass") ?? '');
    _passTextEditingController.text = _pass;
    _url = (await storage.read(key: "url") ?? '');
    _urlTextEditingController.text = _url;
  }

  _updateSetting(String key, String newValue) async {
    await storage.write(key: key, value: newValue);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyStandardAppBarWithoutMenuIcon('Settings'),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            //this container is the header picture
            Container(
              margin: EdgeInsets.fromLTRB(15, 15, 15, 20),
              // padding: EdgeInsets.all(15),
              child: Card(
                color: AdtranColor,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Image(
                    image: AssetImage('images/adtran_white.png'),
                  ),
                ),
              ),
            ),

            //The below container starts the buttons in the settings page
            Container(
              width: screenWidth,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    width: screenWidth - 30,
                    child: Card(
                      color: Colors.blueGrey[50],
                      child: Column(
                        children: [
                          Row(
                            children: [
                              //Bold URL Container
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(
                                  "Username",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              //Text Field Container
                              Expanded(
                                child: TextField(
                                  controller: _userTextEditingController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Your Username Here',
                                  ),
                                  textAlign: TextAlign.center,
                                  onSubmitted: (String username) {
                                    setState(() {
                                      _userTextEditingController.text =
                                          username;
                                    });
                                    _updateSetting("user", username);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                              children: [
                              //Bold URL Container
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(
                                  "Password",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              //Text Field Container
                              Expanded(
                                child: TextField(
                                  obscureText: true,
                                  controller: _passTextEditingController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Your Password Here',
                                  ),
                                  textAlign: TextAlign.center,
                                  onSubmitted: (String password) {
                                    setState(() {
                                      _passTextEditingController.text = password;
                                    });
                                    _updateSetting("pass", password);
                                  },
                                ),
                              ),
                            ]
                          ),
                          Row(
                            children: [
                              //Bold URL Container
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(
                                  "URL",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              //Text Field Container
                              Expanded(
                                child: TextField(
                                  controller: _urlTextEditingController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Your Url Here',
                                  ),
                                  textAlign: TextAlign.center,
                                  onSubmitted: (String domainName) {
                                    setState(() {
                                      _urlTextEditingController.text =
                                          domainName;
                                    });
                                    _updateSetting("url", domainName);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
