import 'package:dappointment/screen/AuthChoiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Color mainColor = Colors.blue;
  static AuthType currentUser = AuthType.DOCTOR;
  static Future<void> changeUserType(AuthType type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userType', type != AuthType.DOCTOR ? false : true);
    currentUser = type;
    mainColor = type != AuthType.DOCTOR ? Colors.purple : Colors.blue;
  }

  static Future<AuthType> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("userType")) {
      bool tp = prefs.getBool('userType');
      currentUser = tp ? AuthType.DOCTOR : AuthType.PATIENT;
      mainColor = tp ? Colors.blue : Colors.purple;
      return tp ? AuthType.DOCTOR : AuthType.PATIENT;
    } else {
      await changeUserType(AuthType.DOCTOR);
      return currentUser;
    }
  }

  static String convertTypetoString(AuthType authType) {
    return authType == AuthType.DOCTOR ? "Doctors" : "Patients";
  }

  static Color getColorFromStatus(String s) {
    switch (s) {
      case 'pending':
        return Colors.orange[400];
      case 'approved':
        return Colors.blue[400];
      case 'cancelled':
        return Colors.red[400];
      case 'completed':
        return Colors.green[400];
      default:
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime setTimeOfDay(TimeOfDay time) {
    return DateTime(this.year, this.month, this.day, time.hour, time.minute);
  }

  DateTime setTime(
      {int hours = 0,
      int minutes = 0,
      int seconds = 0,
      int milliSeconds = 0,
      int microSeconds = 0}) {
    return DateTime(this.year, this.month, this.day, hours, minutes, seconds,
        milliSeconds, microSeconds);
  }

  DateTime clearTime() {
    return DateTime(this.year, this.month, this.day, 0, 0, 0, 0, 0);
  }

  ///..... add more methods/properties for your convenience
}
