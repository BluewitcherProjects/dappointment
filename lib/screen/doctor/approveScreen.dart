import 'package:bot_toast/bot_toast.dart';
import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/model/appointmentModel.dart';
import 'package:dappointment/screen/patient/patientDetails.dart';
import 'package:dappointment/widget/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:date_time_format/date_time_format.dart';

class ApproveScreen extends StatefulWidget {
  final AppointmentModel appointment;
  ApproveScreen({Key key, this.appointment}) : super(key: key);

  @override
  _ApproveScreenState createState() => _ApproveScreenState();
}

class _ApproveScreenState extends State<ApproveScreen> {
  DateTime dateTime;
  AppointmentModel appointment;
  @override
  void initState() {
    super.initState();
    dateTime = widget.appointment.dateTime;
    appointment = widget.appointment;
  }

  StorageService storageService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utils.mainColor,
        title: Text("Appointment Details"),
      ),
      body: ListView(
        children: [
          _appointmentListItem(widget.appointment),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Change Date",
                  style: subtitle1.copyWith(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
                GestureDetector(
                  onTap: () async {
                    var d = await showDatePicker(
                        context: context,
                        initialDate: dateTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1));
                    if (d != null) {
                      setState(() {
                        dateTime = d;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Utils.mainColor.withOpacity(0.1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          dateTime.format("d-M-Y  "),
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
                  "Change Time",
                  style: subtitle1.copyWith(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
                GestureDetector(
                  onTap: () async {
                    var d = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(dateTime));
                    if (d != null) {
                      setState(() {
                        dateTime = dateTime.setTimeOfDay(d);
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Utils.mainColor.withOpacity(0.1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          dateTime.format("h:i A  "),
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
          30.heightBox,
          Container(
            height: 50,
            color: Utils.mainColor,
            child: Center(
              child: Text(
                "Approve Appointment",
                style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ).cornerRadius(12).px(16).onTap(() async {
            if (dateTime.isAfter(DateTime.now())) {
              appointment.dateTime = dateTime;
              appointment.status = "approved";
              BotToast.showLoading();
              await storageService
                  .updateAppointment(appointment)
                  .whenComplete(() {
                BotToast.closeAllLoading();
                context.pop();
              });
            } else {
              BotToast.showText(text: "Check all the fields.");
            }
          }),
          18.heightBox,
          Container(
            height: 50,
            color: Colors.red[400],
            child: Center(
              child: Text(
                "Cancel Appointment",
                style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ).cornerRadius(12).px(16).onTap(() async {
            if (dateTime.isAfter(DateTime.now())) {
              appointment.dateTime = dateTime;
              appointment.status = "cancelled";
              BotToast.showLoading();
              await storageService
                  .updateAppointment(appointment)
                  .whenComplete(() {
                BotToast.closeAllLoading();
                context.pop();
              });
            } else {
              BotToast.showText(text: "Check all the fields.");
            }
          })
        ],
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
}
