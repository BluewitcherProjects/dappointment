// To parse this JSON data, do
//
//     final appointmentModel = appointmentModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<AppointmentModel> appointmentModelFromJson(String str) =>
    List<AppointmentModel>.from(
        json.decode(str).map((x) => AppointmentModel.fromJson(x)));

String appointmentModelToJson(List<AppointmentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppointmentModel {
  AppointmentModel({
    this.id,
    this.doctorId,
    this.patientId,
    this.dateTime,
    this.reason,
    this.status,
    this.doctorName,
    this.doctorPhoto,
    this.doctorQualification,
    this.doctorSpecialization,
    this.doctorVerified,
    this.patientVerified,
    this.patientName,
    this.patientPhoto,
    this.patientMedicalHistory,
  });
  String id;
  String doctorId;
  String patientId;
  DateTime dateTime;
  String reason;
  String status;
  String doctorName;
  String doctorPhoto;
  String doctorQualification;
  String doctorSpecialization;
  int doctorVerified;
  int patientVerified;
  String patientName;
  String patientPhoto;
  String patientMedicalHistory;

  factory AppointmentModel.fromJson(Map<String, dynamic> json,
          {String uid = ''}) =>
      AppointmentModel(
        id: uid,
        doctorId: json["doctorId"],
        patientId: json["patientId"],
        dateTime: json["dateTime"].toDate(),
        reason: json["reason"],
        status: json["status"],
        doctorName: json["doctorName"],
        doctorPhoto: json["doctorPhoto"],
        doctorQualification: json["doctorQualification"],
        doctorSpecialization: json["doctorSpecialization"],
        doctorVerified: json["doctorVerified"],
        patientVerified: json["patientVerified"],
        patientName: json["patientName"],
        patientPhoto: json["patientPhoto"],
        patientMedicalHistory: json["patientMedicalHistory"],
      );

  Map<String, dynamic> toJson() => {
        "doctorId": doctorId,
        "patientId": patientId,
        "dateTime": Timestamp.fromDate(dateTime),
        "reason": reason,
        "status": status,
        "doctorName": doctorName,
        "doctorPhoto": doctorPhoto,
        "doctorQualification": doctorQualification,
        "doctorSpecialization": doctorSpecialization,
        "doctorVerified": doctorVerified,
        "patientVerified": patientVerified,
        "patientName": patientName,
        "patientPhoto": patientPhoto,
        "patientMedicalHistory": patientMedicalHistory,
      };
}
