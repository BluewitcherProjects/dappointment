import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxController {
  final db = FirebaseFirestore.instance;
  User user;
  var _fireStoreUser = <String, dynamic>{}.obs;

  StorageService() {
    _fireStoreUser = <String, dynamic>{}.obs;
    this.user = FirebaseAuth.instance.currentUser;
    getUserdata(user);
  }

  Map<String, dynamic> get currentFireStoreUser => _fireStoreUser.value;

  User get authUserData => user;

  Future<bool> checkUserExists(User user) async {
    bool exists = false;
    try {
      var doc = await db.doc("Users/${user.uid}").get();
      return doc.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> createNewPatient(
      {String fullName,
      String gender,
      DateTime dob,
      String mobile,
      String medicalHistory}) async {
    Object object = {
      "type": "patient",
      "fullName": fullName,
      "gender": gender,
      "dob": dob.toIso8601String(),
      "mobile": mobile,
      "medicalHistory": medicalHistory
    };
    await createUser(object);
  }

  Future<void> createNewDoctor(
      {String fullName,
      String gender,
      DateTime dob,
      String mobile,
      String specialization}) async {
    Object object = {
      "type": "doctor",
      "fullName": fullName,
      "gender": gender,
      "dob": dob.toIso8601String(),
      "mobile": mobile,
      "specialization": specialization
    };
    await createUser(object);
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
        'profilePhotos/${user.uid}.${profilePic.path.split('.').last}';
    final docPath = 'documents/${user.uid}.${document.path.split('.').last}';
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
    await updateUser(object);
  }

  Future<void> createUser(
    Map<String, dynamic> object,
  ) async {
    CollectionReference userRef = db.collection('Users');
    await userRef.doc(user.uid).set(object);
    await getUserdata(user);
  }

  Future<void> getUserdata(User u) async {
    user = u;
    CollectionReference userRef = db.collection('Users');
    var snap = await userRef.doc(user.uid).get();
    _fireStoreUser.value = snap.data();
  }

  Future<void> updateUser(
    Map<String, dynamic> object,
  ) async {
    CollectionReference userRef = db.collection('Users');

    await userRef.doc(user.uid).update(object);
    await getUserdata(user);
  }

  Future<void> updatePhoto(File profilePic) async {
    var profileUrl = '';

    final storage = FirebaseStorage.instance;
    final picPath =
        'profilePhotos/${user.uid}.${profilePic.path.split('.').last}';
    await storage.ref(picPath).putFile(profilePic).then((snapshot) async {
      if (snapshot.state == TaskState.success) {
        profileUrl = await snapshot.ref.getDownloadURL();
      }
    });
    Object object = {
      "profilePhoto": profileUrl,
    };
    await updateUser(object);
  }
}
