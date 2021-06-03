import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/widget/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorHomeScreen extends StatefulWidget {
  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  StorageService storageService = Get.find();
  @override
  Widget build(BuildContext context) {
    print(storageService.currentFireStoreUser.toString());
    print(storageService.user.uid.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Home"),
        backgroundColor: Utils.mainColor,
      ),
      drawer: CustomDrawer(),
    );
  }
}
