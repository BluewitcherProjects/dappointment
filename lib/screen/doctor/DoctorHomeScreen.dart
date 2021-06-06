import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/authService.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/screen/doctor/HistoryAppointment.dart';
import 'package:dappointment/screen/doctor/pendingAppointments.dart';
import 'package:dappointment/screen/patient/DoctorAppointment.dart';
import 'package:dappointment/screen/patient/DoctorsList.dart';
import 'package:dappointment/model/patientModel.dart';
import 'package:dappointment/widget/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(
              storageService.currentFireStoreUser['fullName'] ?? "Doctor")),
          backgroundColor: Utils.mainColor,
          bottom: TabBar(
            indicator: BoxDecoration(
              border: Border(bottom: BorderSide(width: 3, color: Colors.white)),
            ),
            tabs: [
              Tab(
                child: Text("Pending", style: GoogleFonts.ubuntu(fontSize: 16)),
              ),
              Tab(
                child: Text("History", style: GoogleFonts.ubuntu(fontSize: 16)),
              ),
            ],
          ),
        ),
        body:
            TabBarView(children: [PendingAppointment(), HistoryAppointment()]),
        drawer: CustomDrawer(),
      ),
    );
  }
}
