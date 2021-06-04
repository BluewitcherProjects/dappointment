// To parse this JSON data, do
//
//     final patientModel = patientModelFromJson(jsonString);

import 'dart:convert';

PatientModel patientModelFromJson(String str) =>
    PatientModel.fromJson(json.decode(str));

String patientModelToJson(PatientModel data) => json.encode(data.toJson());

class PatientModel {
  PatientModel({
    this.uid,
    this.fullName,
    this.image,
    this.appointmentTime,
    this.reason,
    this.status,
  });

  String uid;
  String fullName;
  String image;
  DateTime appointmentTime;
  String reason;
  String status;

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        uid: json["uid"],
        fullName: json["fullName"],
        image: json["image"],
        appointmentTime: DateTime.parse(json["appointmentTime"]),
        reason: json["reason"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullName": fullName,
        "image": image,
        "appointmentTime": appointmentTime.toIso8601String(),
        "reason": reason,
        "status": status,
      };
}
