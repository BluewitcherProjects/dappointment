import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/screen/AuthChoiceScreen.dart';
import 'package:dappointment/widget/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StorageService storageService = Get.find();
  Map<String, dynamic> user;
  File _imageUrl;

  @override
  void initState() {
    super.initState();
  }

  _updateProfile(Map<String, dynamic> object) async {
    context.pop();
    BotToast.showLoading();
    storageService
        .updateUser(object, Utils.convertTypetoString(Utils.currentUser))
        .whenComplete(() {
      BotToast.closeAllLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      user = storageService.currentFireStoreUser;
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.heightBox,
            [
              Icon(
                EvaIcons.arrowBack,
                size: 30,
              ).onTap(() {
                context.pop();
              }),
              10.widthBox,
              Text(
                "Profile",
                style: headline,
              )
            ].hStack(crossAlignment: CrossAxisAlignment.center),
            18.heightBox,
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  _imageUrl = await pickerDailog();
                  if (_imageUrl != null) {
                    BotToast.showLoading();
                    await storageService
                        .updatePhoto(_imageUrl,
                            Utils.convertTypetoString(Utils.currentUser))
                        .whenComplete(() {
                      BotToast.closeAllLoading();
                    });
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Utils.mainColor.withOpacity(0.1),
                  radius: 60,
                  foregroundImage: storageService
                          .currentFireStoreUser['profilePhoto']
                          .toString()
                          .isNotEmpty
                      ? NetworkImage(
                          storageService.currentFireStoreUser['profilePhoto'])
                      : null,
                  child: Icon(
                    EvaIcons.personOutline,
                    color: blue,
                    size: 80,
                  ),
                ),
              ),
            ),
            14.heightBox,
            _profileItemWidget("Name", user['fullName'], onPressed: (s) {
              _updateProfile({"fullName": s});
            }),
            _profileItemWidget("Mobile", user['mobile'], havePrefix: true,
                onPressed: (s) {
              _updateProfile({"mobile": s});
            }),
            Utils.currentUser == AuthType.DOCTOR
                ? _profileItemWidget("Qualification", user['qualification'],
                    onPressed: (s) {
                    _updateProfile({"qualification": s});
                  })
                : Container(),
            Utils.currentUser == AuthType.PATIENT
                ? _profileItemWidget("Medical History", user['medicalHistory'],
                    onPressed: (s) {
                    _updateProfile({"medicalHistory": s});
                  })
                : Container(),
            Utils.currentUser == AuthType.DOCTOR
                ? _profileItemWidget("About", user['about'], onPressed: (s) {
                    _updateProfile({"about": s});
                  })
                : Container(),
            Utils.currentUser == AuthType.DOCTOR
                ? _profileItemWidget("Specialization", user['specialization'],
                    onPressed: (s) {
                    _updateProfile({"specialization": s});
                  })
                : Container(),
            // _profileItemWidget("State", "${user.user.value.state}",
            //     onPressed: (s) {
            //   _updateProfile({"state": s});
            // }),
            // _profileItemWidget("Aadhaar No", "${user.user.value.aadharNo}",
            //     onPressed: (s) {
            //   _updateProfile({"aadhar_no": s});
            // }),
          ],
        ).px(16),
      );
    }));
  }

  _profileItemWidget(String title, String content,
      {void onPressed(String s), bool havePrefix = false}) {
    TextEditingController textEditingController = TextEditingController();
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text((havePrefix ? "+91 " : "") + content,
                  style: TextStyle(fontSize: 20)),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Dialogs.materialDialog(
                      context: context,
                      customView: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          16.heightBox,
                          "Edit $title".text.textStyle(subtitle1).make(),
                          16.heightBox,
                          CupertinoTextField(
                            style: subtitle1,
                            controller: textEditingController,
                            prefix: havePrefix
                                ? Text(
                                    "  +91",
                                    style: subtitle1,
                                  )
                                : null,
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            placeholder: "$content",
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: blue.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(12)),
                          ).px(14),
                        ],
                      ),
                      actions: [
                        IconsOutlineButton(
                          onPressed: () {
                            context.pop();
                          },
                          text: 'Cancel',
                          iconData: Icons.cancel_outlined,
                          textStyle: TextStyle(color: Colors.grey),
                          iconColor: Colors.grey,
                        ),
                        IconsButton(
                          onPressed: () {
                            onPressed(textEditingController.text);
                          },
                          text: 'Save',
                          iconData: Icons.check,
                          color: blue,
                          textStyle: TextStyle(color: Colors.white),
                          iconColor: Colors.white,
                        ),
                      ]);
                },
              ),
            ],
          ),
          Divider()
        ],
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
                        EvaIcons.cameraOutline,
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
                        EvaIcons.imageOutline,
                        color: Colors.blue,
                      ),
                      title: Text("Gallery"),
                    )
                  ],
                ),
              ),
            ));
  }
}
