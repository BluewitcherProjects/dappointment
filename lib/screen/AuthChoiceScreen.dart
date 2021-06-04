import 'package:dappointment/screen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AuthType { DOCTOR, PATIENT }

class AuthChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Who are you ?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              SizedBox(
                height: 100,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: EdgeInsets.symmetric(
                        vertical: 40,
                      )),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(
                            authType: AuthType.PATIENT,
                          ),
                        ));
                  },
                  child: Center(
                    child: Text(
                      "Patient",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: EdgeInsets.symmetric(
                        vertical: 40,
                      )),
                  onPressed: () {
                    Get.to(
                      () => LoginScreen(
                        authType: AuthType.DOCTOR,
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Doctor",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
