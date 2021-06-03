import 'package:dappointment/screen/AuthChoiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Color mainColor = Colors.blue;
  static AuthType currentUser = AuthType.DOCTOR;
  static changeUserType(AuthType type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userType', type != AuthType.DOCTOR ? false : true);
    currentUser = type;
    mainColor = type != AuthType.DOCTOR ? Colors.purple : Colors.blue;
  }

  static Future<AuthType> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool tp = prefs.getBool('userType') ?? true;
    currentUser = tp ? AuthType.DOCTOR : AuthType.PATIENT;
    mainColor = tp ? Colors.blue : Colors.purple;
    return tp ? AuthType.DOCTOR : AuthType.PATIENT;
  }
}
