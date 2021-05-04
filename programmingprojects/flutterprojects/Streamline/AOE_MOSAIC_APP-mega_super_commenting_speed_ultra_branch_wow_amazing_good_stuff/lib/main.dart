import 'package:aoe_mosaic_app/utilities/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => APIMetaData())],
      child: MaterialApp(
        title: 'Streamline',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}