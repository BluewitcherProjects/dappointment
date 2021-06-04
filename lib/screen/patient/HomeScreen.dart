import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/screen/patient/DoctorAppointment.dart';
import 'package:dappointment/screen/patient/DoctorsList.dart';
import 'package:dappointment/widget/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientHomeScreen extends StatefulWidget {
  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  StorageService storageService = Get.find();
  @override
  Widget build(BuildContext context) {
    print(storageService.currentFireStoreUser.toString());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(
              storageService.currentFireStoreUser['fullName'] ?? "Patient")),
          backgroundColor: Utils.mainColor,
          bottom: TabBar(
            indicator: BoxDecoration(
              border: Border(bottom: BorderSide(width: 3, color: Colors.white)),
            ),
            tabs: [
              Tab(
                child: Text(
                  "Doctors",
                  style: GoogleFonts.ubuntu(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  "Appointments",
                  style: GoogleFonts.ubuntu(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [DoctorList(), DoctorAppointment()]),
        drawer: CustomDrawer(),
      ),
    );
  }
}
