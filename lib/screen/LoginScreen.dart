import 'package:bot_toast/bot_toast.dart';
import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/authService.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/screen/AuthWrapper.dart';
import 'package:dappointment/screen/SignupScreen.dart';
import 'package:dappointment/screen/doctor/DoctorHomeScreen.dart';
import 'package:dappointment/screen/doctor/DoctorRegisterFirstScreen.dart';
import 'package:dappointment/screen/patient/HomeScreen.dart';
import 'package:dappointment/screen/patient/PatientRegisterScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './AuthChoiceScreen.dart';

class LoginScreen extends StatefulWidget {
  final AuthType authType;

  const LoginScreen({Key key, this.authType}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _submiting = false;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  void initState() {
    super.initState();
    Utils.changeUserType(widget.authType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Text(
                          "DAPPOINTMENT",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        widget.authType == AuthType.DOCTOR
                            ? Text("Hello Doctor !",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 25,
                                    color: Colors.blue))
                            : Text("Patient",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 25,
                                    color: Colors.purple)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 20)),
                        SizedBox(
                          height: 50,
                        ),
                        Form(
                            child: Column(
                          children: [
                            TextFormField(
                              onSaved: (newValue) {
                                // _note["title"] = newValue;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter title";
                                } else {
                                  return null;
                                }
                              },
                              controller: email,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                hintText: "Email ID",
                                contentPadding: EdgeInsets.all(18),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.black45),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.black54,
                                        width: 2,
                                        style: BorderStyle.solid)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              onSaved: (newValue) {
                                // _note["title"] = newValue;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter title";
                                } else {
                                  return null;
                                }
                              },
                              controller: pass,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 15),
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password",
                                contentPadding: EdgeInsets.all(18),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.black45),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.black54,
                                        width: 2,
                                        style: BorderStyle.solid)),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              width: double.maxFinite,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          widget.authType != AuthType.DOCTOR
                                              ? Colors.purple
                                              : Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15)),
                                  child: _submiting
                                      ? CircularProgressIndicator()
                                      : Text(
                                          "Login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                  onPressed: () {
                                    if (email.text.isEmail &&
                                        pass.text.isNotEmpty) {
                                      BotToast.showLoading();
                                      AuthenticationService(
                                              FirebaseAuth.instance)
                                          .signIn(
                                              email: email.text,
                                              password: pass.text)
                                          .then((value) {
                                        BotToast.closeAllLoading();
                                        if (value != null) {
                                          var service = Get.put(
                                              StorageService(),
                                              permanent: true);
                                          service
                                              .getUserdata(
                                                  value,
                                                  Utils.convertTypetoString(
                                                      Utils.currentUser))
                                              .whenComplete(() {
                                            Get.offUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AuthWrapper()),
                                                (route) => false);
                                          });
                                        }
                                      });
                                    } else {
                                      BotToast.showText(
                                          text: "Fill all the Boxes");
                                    }
                                  }),
                            ),
                          ],
                        ))
                      ]),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New User ? "),
                    TextButton(
                        onPressed: () {
                          Get.to(() => SignUpScreen(
                                authType: widget.authType,
                              ));
                        },
                        child: Text(
                          "Register",
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
