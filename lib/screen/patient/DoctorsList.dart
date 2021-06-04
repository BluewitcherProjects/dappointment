import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/authService.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/model/doctorListItem.dart';
import 'package:dappointment/screen/patient/scheduleScreen.dart';
import 'package:dappointment/widget/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({Key key}) : super(key: key);

  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<DoctorListItemModel>>(
        future: StorageService.getDoctorsList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return ListView.separated(
              itemCount: data.length,
              itemBuilder: (context, index) => _doctorListItem(data[index]),
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

  _doctorListItem(DoctorListItemModel item) {
    return ListTile(
      title: Text(
        item.fullName,
        style: headline.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(item.specialization), Text(item.qualification ?? "")],
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Utils.mainColor.withOpacity(0.1),
        foregroundImage:
            item.profilePhoto != null ? NetworkImage(item.profilePhoto) : null,
        child: Icon(
          EvaIcons.personOutline,
          color: Utils.mainColor,
          size: 30,
        ),
      ),
      isThreeLine: true,
      trailing: GestureDetector(
        onTap: () {
          context.push((context) => ScheduleScreen(
                doctor: item,
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Utils.mainColor.withOpacity(0.1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            "schedule",
            style: GoogleFonts.ubuntu(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Utils.mainColor),
          ),
        ),
      ),
    );
    // Card(
    //   child: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             CircleAvatar(
    //               radius: 30,
    //               child: Icon(EvaIcons.person),
    //             ),
    //             SizedBox(
    //               width: 10,
    //             ),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   item.fullName,
    //                   style: headline.copyWith(fontSize: 15),
    //                 ),
    //                 Text(
    //                   "Spacility : XYZ",
    //                   style: TextStyle(color: Colors.grey),
    //                 ),
    //               ],
    //             )
    //           ],
    //         ),
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.end,
    //           children: [
    //             Text("PHD"),
    //             ElevatedButton(
    //                 onPressed: () {
    //                   StorageService.getDoctorsList();
    //                 },
    //                 child: Text("Book Appointment"))
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  _getDoctors() {
    StorageService.getDoctorsList();
  }
}
