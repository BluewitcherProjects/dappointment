import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/screen/AuthChoiceScreen.dart';
import 'package:dappointment/screen/AuthWrapper.dart';
import 'package:dappointment/screen/doctor/DoctorHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class DoctorRegisterSecond extends StatefulWidget {
  @override
  _DoctorRegisterSecondState createState() => _DoctorRegisterSecondState();
}

class _DoctorRegisterSecondState extends State<DoctorRegisterSecond> {
  File profilePic, documentPic;
  TextEditingController qualification = TextEditingController();
  TextEditingController about = TextEditingController();
  StorageService storageService = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Form(
              child: Column(
                children: [
                  Text(
                    'Profile Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      profilePic = await pickerDailog();
                    },
                    child: CircleAvatar(
                        backgroundColor: Vx.blue700,
                        radius: 50,
                        foregroundImage: profilePic == null
                            ? null
                            : FileImage(
                                profilePic,
                              ),
                        child: profilePic == null
                            ? Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 40,
                              )
                            : null),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _textField(hint: "Qualification", controller: qualification),
                  SizedBox(
                    height: 20,
                  ),
                  _textField(hint: "About", controller: about),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue[100],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15)),
                        child: Text(
                          documentPic != null
                              ? documentPic.path.split('/').last
                              : "Upload Document",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        onPressed: () async {
                          documentPic = await pickerDailog();
                        }),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
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
                          if (qualification.text.isNotEmpty &&
                              about.text.isNotEmpty &&
                              profilePic != null &&
                              documentPic != null) {
                            BotToast.showLoading();
                            storageService
                                .addAdditionalDetailsForDoctor(
                                    qualification: qualification.text,
                                    about: about.text,
                                    profilePic: profilePic,
                                    document: documentPic)
                                .whenComplete(() {
                              BotToast.closeAllLoading();
                              Utils.changeUserType(AuthType.DOCTOR);
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

  Future<File> _pickImage(ImageSource imageSource) async {
    File _image;
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    return _image;
  }

  Future<File> pickerDailog() async {
    return await showDialog<File>(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () async {
                        Navigator.pop(
                            context, await _pickImage(ImageSource.camera));
                      },
                      leading: Icon(
                        Icons.camera,
                        color: Colors.blue,
                      ),
                      title: Text("Camera"),
                    ),
                    Divider(
                      height: 0,
                    ),
                    ListTile(
                      onTap: () async {
                        Navigator.pop(
                            context, await _pickImage(ImageSource.gallery));
                      },
                      leading: Icon(
                        Icons.photo_library,
                        color: Colors.blue,
                      ),
                      title: Text("Gallery"),
                    )
                  ],
                ),
              ),
            ));
  }

  _textField(
      {Function onSaved,
      Function validator,
      String hint,
      TextInputType textInputType = TextInputType.text,
      TextEditingController controller}) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      keyboardType: textInputType,
      controller: controller,
      style: TextStyle(fontSize: 15),
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
