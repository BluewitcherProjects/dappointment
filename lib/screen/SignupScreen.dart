import 'package:bot_toast/bot_toast.dart';
import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/authService.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/screen/doctor/DoctorRegisterFirstScreen.dart';
import 'package:dappointment/screen/patient/PatientRegisterScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AuthChoiceScreen.dart';

class SignUpScreen extends StatefulWidget {
  final AuthType authType;
  SignUpScreen({Key key, this.authType}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
            child: Form(
              child: Column(
                children: [
                  Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  _textField(hint: "Email", controller: email),
                  SizedBox(
                    height: 20,
                  ),
                  _textField(
                      hint: "Password", obsureText: true, controller: password),
                  SizedBox(
                    height: 20,
                  ),
                  _textField(
                      hint: "Re-enter Password",
                      obsureText: true,
                      controller: password2),
                  SizedBox(
                    height: 70,
                  ),
                  Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: widget.authType != AuthType.DOCTOR
                                ? Colors.purple
                                : Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15)),
                        child: Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {
                          if (email.text.isEmail &&
                              password.text == password2.text) {
                            BotToast.showLoading();
                            AuthenticationService(FirebaseAuth.instance)
                                .signUp(
                                    email: email.text, password: password.text)
                                .then((value) {
                              BotToast.closeAllLoading();
                              if (value != null) {
                                var service =
                                    Get.put(StorageService(), permanent: true);
                                service
                                    .getUserdata(
                                        value,
                                        Utils.convertTypetoString(
                                            Utils.currentUser))
                                    .whenComplete(() {
                                  widget.authType == AuthType.PATIENT
                                      ? Get.offUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PatientRegister()),
                                          (route) => false)
                                      : Get.offUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DoctorRegisterFirst()),
                                          (route) => false);
                                });
                              }
                            });
                          } else {
                            BotToast.showText(text: "Check all the fields");
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _textField(
      {Function onSaved,
      Function validator,
      String hint,
      TextInputType textInputType = TextInputType.text,
      TextEditingController controller,
      bool obsureText = false}) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      keyboardType: textInputType,
      style: TextStyle(fontSize: 15),
      controller: controller,
      obscureText: obsureText,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.all(18),
        filled: true,
        hintStyle: TextStyle(color: Colors.black45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: Colors.black54, width: 2, style: BorderStyle.solid),
        ),
      ),
    );
  }
}
