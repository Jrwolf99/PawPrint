import 'package:aoe_mosaic_app/utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'successpage.dart';
import 'package:aoe_mosaic_app/ui_theme.dart';
import 'models.dart';
import 'package:provider/provider.dart';

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  final fieldNames;
  final Future<List<dynamic>> Function(BuildContext, dynamic) formCallback;
  final Widget nextRoute;
  final bool clearPreviousPages;
  final PageArguments nextRouteArgs;
  MyCustomForm(this.fieldNames, this.formCallback, this.nextRoute, {this.nextRouteArgs, this.clearPreviousPages});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState(fieldNames, formCallback, nextRoute, nextRouteArgs: nextRouteArgs, clearPreviousPages: clearPreviousPages);
  }
}

// Create a corresponding State class.
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final fieldNames;
  final Future<List<dynamic>> Function(BuildContext, dynamic) formCallback;
  final List<TextEditingController> myControllers = new List();
  final Widget nextRoute;
  final PageArguments nextRouteArgs;
  final bool clearPreviousPages;
  MyCustomFormState(this.fieldNames, this.formCallback, this.nextRoute, {this.nextRouteArgs, this.clearPreviousPages});

  @override
  void dispose() {
    for (var myController in myControllers) myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < fieldNames.length; i++) {
      myControllers.add(TextEditingController());
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormNextButton(_formKey, myControllers, formCallback, nextRoute, nextRouteArgs: nextRouteArgs, clearPreviousPages: clearPreviousPages),
          for (var i = 0; i < fieldNames.length; i++)
            FormInput(fieldNames[i], myControllers[i]),
        ],
      ),
    );
  }
}

class FormInput extends StatelessWidget {
  final labelText;
  final myController;
  FormInput(this.labelText, this.myController);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: TextFormField(
        controller: myController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: '$labelText',
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'Field cannot be blank';
          }
          return null;
        },
      ),
    );
  }
}

class FormNextButton extends StatelessWidget {
  final _formKey;
  final myControllers;
  final Future<List<dynamic>> Function(BuildContext, dynamic) formCallback;
  final Widget nextRoute;
  final PageArguments nextRouteArgs;
  final bool clearPreviousPages;
  FormNextButton(this._formKey, this.myControllers, this.formCallback, this.nextRoute, {this.nextRouteArgs, this.clearPreviousPages});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: Container(
          width: 100,
          height: 50,
          child: RaisedButton(
            color: AdtranButtonColor,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                List<String> responses = new List();
                for (var controller in myControllers)
                  responses.add(controller.text);
                List<dynamic> args = await formCallback(context, responses);

                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(
                    arguments: PageArguments(
                      title: args[0], // title
                      text: args[1], // text
                      fieldNames: args[2], // field names
                      responses: responses,
                      nextRoute: this.nextRoute,
                      nextRouteArgs: this.nextRouteArgs,
                      clearPreviousPages: this.clearPreviousPages,
                    ),
                  ),
                  screen: SuccessPage(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }
            },
            child: Text('Next ->',
              style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Source Sans Pro',
            ),),
          ),
        ),
      ),
    );
  }
}
