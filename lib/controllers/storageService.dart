import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dappointment/model/appointmentModel.dart';
import 'package:dappointment/model/doctorListItem.dart';
import 'package:dappointment/screen/AuthChoiceScreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxController {
  final db = FirebaseFirestore.instance;
  User _user;
  var _fireStoreUser = <String, dynamic>{}.obs;

  ///[AuthType] to determine the collectionName
  StorageService() {
    _fireStoreUser = <String, dynamic>{}.obs;
    this._user = FirebaseAuth.instance.currentUser;
    //getUserdata(_user, authType == AuthType.DOCTOR ? "Doctors" : "Patients");
  }

  Map<String, dynamic> get currentFireStoreUser => _fireStoreUser.value;

  User get authUserData => _user;

//PATIENT-----------------------------------------------------------------------
  Future<void> createNewPatient(
      {String fullName,
      String gender,
      DateTime dob,
      String mobile,
      String medicalHistory}) async {
    Object object = {
      "fullName": fullName,
      "gender": gender,
      "dob": dob.toIso8601String(),
      "mobile": mobile,
      "medicalHistory": medicalHistory,
      "verified": 0,
      "profilePhoto": ""
    };
    await createUser(object, "Patients");
  }

//Doctor------------------------------------------------------------------------
  Future<void> createNewDoctor(
      {String fullName,
      String gender,
      DateTime dob,
      String mobile,
      String specialization}) async {
    Object object = {
      "fullName": fullName,
      "gender": gender,
      "dob": dob.toIso8601String(),
      "mobile": mobile,
      "specialization": specialization,
      "qualification": "",
      "about": "",
      "profilePhoto": "",
      "documentPhoto": "",
      "verified": 0
    };
    await createUser(object, "Doctors");
  }

  Future<void> addAdditionalDetailsForDoctor(
      {File profilePic,
      File document,
      String qualification,
      String about}) async {
    var profileUrl = '';
    var docUrl = '';
    final storage = FirebaseStorage.instance;
    final picPath =
        'profilePhotos/${_user.uid}.${profilePic.path.split('.').last}';
    final docPath = 'documents/${_user.uid}.${document.path.split('.').last}';
    print(picPath);
    print(docPath);
    await storage.ref(picPath).putFile(profilePic).then((snapshot) async {
      if (snapshot.state == TaskState.success) {
        profileUrl = await snapshot.ref.getDownloadURL();
      }
    });
    await storage.ref(docPath).putFile(document).then((snapshot) async {
      if (snapshot.state == TaskState.success) {
        docUrl = await snapshot.ref.getDownloadURL();
      }
    });

    Object object = {
      "qualification": qualification,
      "about": about,
      "profilePhoto": profileUrl,
      "documentPhoto": docUrl
    };
    await updateUser(object, "Doctors");
  }

//------------------------------------------------------------------------------

  Future<void> createUser(
      Map<String, dynamic> object, String collectionName) async {
    CollectionReference _userRef = db.collection(collectionName);
    await _userRef.doc(_user.uid).set(object);
    await getUserdata(_user, collectionName);
  }

  Future<String> getUserdata(User u, String collectionName) async {
    _user = u;
    CollectionReference _userRef = db.collection(collectionName);
    var snap = await _userRef.doc(_user.uid).get();
    _fireStoreUser.value = snap.data();
    return "done";
  }

  Future<void> updateUser(
      Map<String, dynamic> object, String collectionName) async {
    CollectionReference _userRef = db.collection(collectionName);

    await _userRef.doc(_user.uid).update(object);
    await getUserdata(_user, collectionName);
  }

  Future<void> updatePhoto(File profilePic, String collectionName) async {
    var profileUrl = '';

    final storage = FirebaseStorage.instance;
    final picPath =
        'profilePhotos/${_user.uid}.${profilePic.path.split('.').last}';
    await storage.ref(picPath).putFile(profilePic).then((snapshot) async {
      if (snapshot.state == TaskState.success) {
        profileUrl = await snapshot.ref.getDownloadURL();
      }
    });
    Object object = {
      "profilePhoto": profileUrl,
    };
    await updateUser(object, collectionName);
  }

  Future<bool> checkUserExists(User _user) async {
    bool exists = false;
    try {
      var doc = await db.doc("Users/${_user.uid}").get();
      return doc.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<DoctorListItemModel>> getDoctorsList() async {
    final db = FirebaseFirestore.instance;
    var snap = await db.collection('Doctors').get();

    var l = List<DoctorListItemModel>.from(
        snap.docs.map((x) => DoctorListItemModel.fromJson(x.data(), x.id)));
    return l;
  }

  static Future<List<AppointmentModel>> getAppointmentsList() async {
    final db = FirebaseFirestore.instance;
    var snap = await db.collection('Appointments').get();
    print(snap.docs.first.data());
    var l = List<AppointmentModel>.from(
        snap.docs.map((x) => AppointmentModel.fromJson(x.data())));
    l.sort((b, a) => a.dateTime.compareTo(b.dateTime));
    return l;
  }

  Future<void> addAppointment(
      DoctorListItemModel doctor, DateTime dateTime, String reason) async {
    final db = FirebaseFirestore.instance;
    Object data = {
      'doctorId': doctor.docId,
      'patientId': _user.uid,
      'dateTime': dateTime,
      'reason': reason,
      'status': 'pending',
      'doctorName': doctor.fullName,
      'doctorPhoto': doctor.profilePhoto,
      'doctorQualification': doctor.qualification,
      'doctorSpecialization': doctor.specialization,
      'doctorVerified': 0,
      'patientVerified': _fireStoreUser['verified'],
      'patientName': _fireStoreUser['fullName'],
      'patientPhoto': _fireStoreUser['profilePhoto'],
      'patientMedicalHistory': _fireStoreUser['medicalHistory']
    };
    var doc = await db.collection("Appointments").add(data);
    var a = await doc.get();
    print(a.data());
  }
}
