import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/model/appointmentModel.dart';
import 'package:dappointment/screen/doctor/approveScreen.dart';
import 'package:dappointment/widget/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:velocity_x/velocity_x.dart';

class PendingAppointment extends StatefulWidget {
  PendingAppointment({Key key}) : super(key: key);

  @override
  _PendingAppointmentState createState() => _PendingAppointmentState();
}

class _PendingAppointmentState extends State<PendingAppointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AppointmentModel>>(
        future: StorageService.getAppointmentsList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<AppointmentModel> d = snapshot.data;
            List<AppointmentModel> data = [];
            var userId = FirebaseAuth.instance.currentUser.uid;

            d.forEach((element) {
              if (element.doctorId == userId && element.status == 'pending') {
                data.add(element);
              }
            });

            if (data.isEmpty)
              return Center(
                child: Text("No Appointments found"),
              );
            // print(data.first);
            return ListView.separated(
              itemCount: data.length,
              itemBuilder: (context, index) =>
                  _appointmentListItem(data[index]),
              separatorBuilder: (c, i) => Divider(
                height: 1,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Text("No data"),
          );
        },
      ),
    );
  }

  _appointmentListItem(AppointmentModel appointment) {
    return ListTile(
      title: Text(
        appointment.patientName,
        style: headline.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appointment.patientMedicalHistory),
          Text(appointment.dateTime.format('d-M-Y h:i A'))
        ],
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Utils.mainColor.withOpacity(0.1),
        foregroundImage: appointment.patientPhoto != null &&
                appointment.patientPhoto.isNotEmpty
            ? NetworkImage(appointment.patientPhoto)
            : null,
        child: Icon(
          EvaIcons.personOutline,
          color: Utils.mainColor,
          size: 30,
        ),
      ),
      isThreeLine: true,
      trailing: GestureDetector(
        onTap: () {
          context.push((context) => ApproveScreen(
                appointment: appointment,
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Utils.mainColor.withOpacity(0.15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            "Details",
            style: GoogleFonts.ubuntu(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Utils.mainColor),
          ),
        ),
      ),
    );
  }
}
