import 'package:dappointment/widget/detailsRow.dart';
import 'package:flutter/material.dart';
import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:date_time_format/date_time_format.dart';

import 'package:dappointment/widget/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';

import 'package:velocity_x/velocity_x.dart';

class DoctorDetails extends StatefulWidget {
  final String uid;
  DoctorDetails({Key key, this.uid}) : super(key: key);

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  Map<String, dynamic> user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder<Object>(
        future: StorageService.getUserDetails(widget.uid, 'Doctors'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data;
            return Column(
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
                    "Doctor Details",
                    style: headline,
                  )
                ].hStack(crossAlignment: CrossAxisAlignment.center),
                18.heightBox,
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: Utils.mainColor.withOpacity(0.1),
                    radius: 60,
                    foregroundImage: user['profilePhoto'].toString().isNotEmpty
                        ? NetworkImage(user['profilePhoto'])
                        : null,
                    child: Icon(
                      EvaIcons.personOutline,
                      color: blue,
                      size: 80,
                    ),
                  ),
                ),
                14.heightBox,
                DetailsRow(title: "Full Name", value: user['fullName']),
                DetailsRow(
                    title: "D.O.B",
                    value: DateTime.parse(user['dob']).format('d-M-Y')),
                DetailsRow(title: "Gender", value: user['gender']),
                DetailsRow(title: "Mobile", value: user['mobile']),
                DetailsRow(
                    title: "Qualification", value: user['qualification']),
                DetailsRow(
                    title: "Specialization", value: user['specialization']),
                DetailsRow(title: "About", value: user['about']),
              ],
            ).px(16);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    ));
  }
}
