import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/screen/SplashScreen.dart';
import 'package:dappointment/screen/doctor/DoctorHomeScreen.dart';
import 'package:dappointment/screen/patient/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AuthChoiceScreen.dart';

class AuthWrapper extends StatefulWidget {
  AuthWrapper({Key key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FutureBuilder<AuthType>(
        future: Utils.getUserType(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var service = Get.put(StorageService(), permanent: true);
            return FutureBuilder(
              future: service.getUserdata(user,
                  snapshot.data == AuthType.DOCTOR ? "Doctors" : "Patients"),
              builder: (BuildContext context, AsyncSnapshot snap) {
                if (snap.hasData) {
                  return snapshot.data == AuthType.DOCTOR
                      ? DoctorHomeScreen()
                      : PatientHomeScreen();
                }
                return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            );
          }
          return Container();
        },
      );
    } else
      return AuthChoiceScreen();
  }
}
