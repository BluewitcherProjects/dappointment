// To parse this JSON data, do
//
//     final doctorListItemModel = doctorListItemModelFromJson(jsonString);

// import 'dart:convert';

// List<DoctorListItemModel> doctorListItemModelFromJson(String str) =>
//     List<DoctorListItemModel>.from(
//         json.decode(str).map((x) => DoctorListItemModel.fromJson(x)));

// String doctorListItemModelToJson(List<DoctorListItemModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DoctorListItemModel {
  DoctorListItemModel({
    this.qualification,
    this.profilePhoto,
    this.gender,
    this.about,
    this.mobile,
    this.specialization,
    this.fullName,
    this.docId,
  });

  String qualification;
  String profilePhoto;
  String gender;
  String about;
  String mobile;
  String specialization;
  String fullName;
  String docId;

  factory DoctorListItemModel.fromJson(Map<String, dynamic> json, String uid) =>
      DoctorListItemModel(
          qualification: json["qualification"],
          profilePhoto: json["profilePhoto"],
          gender: json["gender"],
          about: json["about"],
          mobile: json["mobile"],
          specialization: json["specialization"],
          fullName: json["fullName"],
          docId: uid);

  Map<String, dynamic> toJson() => {
        "qualification": qualification,
        "profilePhoto": profilePhoto,
        "gender": gender,
        "about": about,
        "mobile": mobile,
        "specialization": specialization,
        "fullName": fullName,
      };
}
