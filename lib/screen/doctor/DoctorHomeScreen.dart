import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/screen/doctor/DoctorAppointment.dart';
import 'package:dappointment/screen/doctor/DoctorsList.dart';
import 'package:dappointment/model/patientModel.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Doctors"),
          backgroundColor: Utils.mainColor,
          bottom: TabBar(
            indicator: BoxDecoration(
              border: Border(bottom: BorderSide(width: 3, color: Colors.white)),
            ),
            tabs: [
              Tab(
                child: Text("Doctors"),
              ),
              Tab(
                child: Text("Appointment"),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [DoctorList(), DoctorAppointment()]),
        drawer: CustomDrawer(),
      ),
    );
  }

  Future<PatientModel> _getPatientList() {}
}
