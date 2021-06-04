import 'package:bot_toast/bot_toast.dart';
import 'package:dappointment/controllers/Utils.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:dappointment/model/doctorListItem.dart';
import 'package:dappointment/widget/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:velocity_x/velocity_x.dart';

class ScheduleScreen extends StatefulWidget {
  final DoctorListItemModel doctor;
  ScheduleScreen({Key key, this.doctor}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime dateTime;
  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
  }

  StorageService storageService = Get.find();
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(widget.doctor.docId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utils.mainColor,
        title: Text("Schedule Appointment"),
      ),
      body: ListView(
        children: [
          _doctorListItem(widget.doctor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Date",
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
                  "Select Time",
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
          VxTextField(
            controller: _controller,
            borderType: VxTextFieldBorderType.roundLine,
            borderRadius: 12,
            fillColor: Colors.white,
            borderColor: Utils.mainColor,
            hint: "Reason For the appointment",
            style: subtitle1.copyWith(fontSize: 16),
            maxLine: 5,
          ).px(16),
          30.heightBox,
          Container(
            height: 50,
            color: Utils.mainColor,
            child: Center(
              child: Text(
                "Request for appointment",
                style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ).cornerRadius(12).px(16).onTap(() async {
            if (_controller.text.isNotEmpty &&
                dateTime.isAfter(DateTime.now())) {
              BotToast.showLoading();
              await storageService
                  .addAppointment(widget.doctor, dateTime, _controller.text)
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
    );
  }
}
