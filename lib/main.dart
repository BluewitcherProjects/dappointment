import 'package:bot_toast/bot_toast.dart';
import 'package:dappointment/screen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [
        BotToastNavigatorObserver()
      ], //2. registered route observe
      theme: ThemeData(
          primaryColor: Color.fromRGBO(41, 121, 255, 1),
          primarySwatch: Colors.blue,
          fontFamily: "Roboto",
          textTheme: TextTheme()),
      home: SplashScreen(),
    );
  }
}
