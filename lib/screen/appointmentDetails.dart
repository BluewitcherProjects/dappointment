import 'package:dappointment/screen/doctor/doctorDetails.dart';
import 'package:dappointment/screen/patient/patientDetails.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/model/appointmentModel.dart';
import 'package:dappointment/widget/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:date_time_format/date_time_format.dart';

class AppointmentDetails extends StatefulWidget {
  final AppointmentModel appointment;
  AppointmentDetails({Key key, this.appointment}) : super(key: key);

  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  AppointmentModel appointment;
  @override
  void initState() {
    super.initState();

    appointment = widget.appointment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utils.mainColor,
        title: Text("Appointment Details"),
      ),
      body: ListView(
        children: [
          8.heightBox,
          Text(
            "    Doctor",
            style:
                subtitle1.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          _doctorListItem(appointment),
          Text(
            "    Patient",
            style:
                subtitle1.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          _patientListItem(appointment),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date",
                  style: subtitle1.copyWith(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Utils.mainColor.withOpacity(0.07),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        appointment.dateTime.format("d-M-Y  "),
                        style: GoogleFonts.arimo(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Utils.mainColor),
                      ),
                      Icon(
                        EvaIcons.calendar,
                        size: 20,
                        color: Utils.mainColor,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Time",
                  style: subtitle1.copyWith(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Utils.mainColor.withOpacity(0.1),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        appointment.dateTime.format("h:i A  "),
                        style: GoogleFonts.arimo(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Utils.mainColor),
                      ),
                      Icon(
                        EvaIcons.clock,
                        size: 20,
                        color: Utils.mainColor,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status",
                  style: subtitle1.copyWith(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Utils.getColorFromStatus(appointment.status)
                        .withOpacity(0.1),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        appointment.status + '  ',
                        style: GoogleFonts.arimo(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                Utils.getColorFromStatus(appointment.status)),
                      ),
                      Icon(
                        Icons.insights,
                        size: 20,
                        color: Utils.getColorFromStatus(appointment.status),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          10.heightBox,
          "Reason"
              .text
              .textStyle(
                  subtitle1.copyWith(fontWeight: FontWeight.w500, fontSize: 18))
              .make()
              .px(16),
          10.heightBox,
          Text(
            appointment.reason,
            style: subtitle1.copyWith(fontSize: 16),
          ).px(16),
        ],
      ),
    );
  }

  _patientListItem(AppointmentModel appointment) {
    return ListTile(
      title: Text(
        appointment.patientName,
        style: headline.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appointment.patientMedicalHistory),
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
          context.push((context) => PatientDetails(
                uid: appointment.patientId,
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Utils.mainColor.withOpacity(0.15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            'View details',
            style: GoogleFonts.ubuntu(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Utils.mainColor),
          ),
        ),
      ),
    );
  }

  _doctorListItem(AppointmentModel appointment) {
    return ListTile(
      title: Text(
        appointment.doctorName,
        style: headline.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appointment.doctorQualification),
          Text(appointment.doctorSpecialization)
        ],
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Utils.mainColor.withOpacity(0.1),
        foregroundImage: appointment.doctorPhoto != null &&
                appointment.doctorPhoto.isNotEmpty
            ? NetworkImage(appointment.doctorPhoto)
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
          context.push((context) => DoctorDetails(
                uid: appointment.doctorId,
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Utils.mainColor.withOpacity(0.15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            'View details',
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
