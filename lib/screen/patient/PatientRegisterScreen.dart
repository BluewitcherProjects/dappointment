import 'package:bot_toast/bot_toast.dart';
import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/screen/patient/HomeScreen.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../AuthChoiceScreen.dart';
import '../AuthWrapper.dart';

class PatientRegister extends StatefulWidget {
  @override
  _PatientRegisterState createState() => _PatientRegisterState();
}

class _PatientRegisterState extends State<PatientRegister> {
  final _dobController = TextEditingController();
  final fullName = TextEditingController();
  final medicalHistory = TextEditingController();
  final phone = TextEditingController();
  DateTime date;
  String selectedGender = '';
  StorageService storageService = Get.find();

  @override
  Widget build(BuildContext context) {
    print(storageService.user.email);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  _textField(hint: "Full name", controller: fullName),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: "Gender",
                        contentPadding: EdgeInsets.all(18),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.black45),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Colors.black54,
                              width: 2,
                              style: BorderStyle.solid),
                        ),
                      ),
                      items: <String>["Male", "Female"].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {
                        setState(() {
                          selectedGender = _;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _dobController,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(Duration(days: 36500)),
                              lastDate: DateTime.now())
                          .then((value) {
                        setState(() {
                          if (value != null) {
                            _dobController.text =
                                formatDate(value, [dd, '/', mm, '/', yyyy]);
                            setState(() {
                              date = value;
                            });
                          }
                        });
                      });
                    },
                    readOnly: true,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today_outlined),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(Duration(days: 36500)),
                                    lastDate: DateTime.now())
                                .then((value) {
                              setState(() {
                                if (value != null) {
                                  _dobController.text = formatDate(
                                      value, [dd, '/', mm, '/', yyyy]);
                                  setState(() {
                                    date = value;
                                  });
                                }
                              });
                            });
                          }),
                      contentPadding: EdgeInsets.all(18),
                      filled: true,
                      hintText: "Date of Birth",
                      hintStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                            color: Colors.black54,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _textField(
                      hint: "Phone Number",
                      textInputType: TextInputType.phone,
                      maxLength: 10,
                      helper: 'Enter 10 digit phone number',
                      controller: phone),
                  SizedBox(
                    height: 20,
                  ),
                  _textField(
                      hint: "Medical History", controller: medicalHistory),
                  SizedBox(
                    height: 45,
                  ),
                  Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15)),
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {
                          if (fullName.text.isNotEmpty &&
                              selectedGender.isNotEmpty &&
                              _dobController.text.isNotEmpty &&
                              phone.text.isPhoneNumber &&
                              medicalHistory.text.isNotEmpty) {
                            BotToast.showLoading();
                            storageService
                                .createNewPatient(
                                    fullName: fullName.text,
                                    gender: selectedGender,
                                    mobile: phone.text,
                                    dob: date,
                                    medicalHistory: medicalHistory.text)
                                .whenComplete(() {
                              BotToast.closeAllLoading();
                              Utils.changeUserType(AuthType.PATIENT);
                              Get.offUntil(
                                  MaterialPageRoute(
                                      builder: (c) => AuthWrapper()),
                                  (route) => false);
                            });
                          } else {
                            BotToast.showText(
                                text: "Fill all the fields correctly.");
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
      int maxLength,
      String helper,
      bool obsureText = false}) {
    return TextFormField(
      controller: controller,
      onSaved: onSaved,
      validator: validator,
      keyboardType: textInputType,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      style: TextStyle(fontSize: 15),
      obscureText: obsureText,
      decoration: InputDecoration(
        hintText: hint,
        helperText: helper,
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
