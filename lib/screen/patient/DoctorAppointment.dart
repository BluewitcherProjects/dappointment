import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/model/appointmentModel.dart';
import 'package:dappointment/widget/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorAppointment extends StatefulWidget {
  const DoctorAppointment({Key key}) : super(key: key);

  @override
  _DoctorAppointmentState createState() => _DoctorAppointmentState();
}

class _DoctorAppointmentState extends State<DoctorAppointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AppointmentModel>>(
        future: StorageService.getAppointmentsList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;

            if (data.isEmpty)
              return Center(
                child: Text("No Appointments found"),
              );
            print(data.first);
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
            child: Text("No doctors found"),
          );
        },
      ),
    );
  }

  _appointmentListItem(AppointmentModel appointment) {
    return ListTile(
      title: Text(
        appointment.doctorName,
        style: headline.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appointment.doctorSpecialization),
          Text(appointment.dateTime.format('d-M-Y h:i A'))
        ],
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Utils.mainColor.withOpacity(0.1),
        foregroundImage: appointment.doctorPhoto != null
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
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                Utils.getColorFromStatus(appointment.status).withOpacity(0.15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            appointment.status,
            style: GoogleFonts.ubuntu(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Utils.getColorFromStatus(appointment.status)),
          ),
        ),
      ),
    );
  }
}
