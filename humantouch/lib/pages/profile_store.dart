import 'package:flutter/material.dart';

class ProfileStore extends ChangeNotifier {
  ProfileStore._internal();

  static final ProfileStore instance = ProfileStore._internal();

  String profileImage =
      'https://images.unsplash.com/photo-1592520113018-180c8bc831c9?auto=format&fit=crop&w=900&q=60';

  String name = 'Andrea Davis';
  String email = 'andrea@domainname.com';
  String phoneNumber = '+97330000000';
  String password = '123456';
  bool isActive = true;

  // patient / companion / volunteer
  String userRole = 'patient';

  // patient QR code
  String patientLinkCode = 'PATIENT-HT-1001';

  // for companion after scanning
  String linkedPatientCode = '';

  void updateName(String value) {
    name = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updatePhoneNumber(String value) {
    phoneNumber = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  void updateProfileImage(String value) {
    profileImage = value;
    notifyListeners();
  }

  void updateIsActive(bool value) {
    isActive = value;
    notifyListeners();
  }

  void updateUserRole(String value) {
    userRole = value;
    notifyListeners();
  }

  void updatePatientLinkCode(String value) {
    patientLinkCode = value;
    notifyListeners();
  }

  void linkPatientCode(String code) {
    linkedPatientCode = code;
    notifyListeners();
  }

  void deleteAccount() {
    profileImage =
        'https://images.unsplash.com/photo-1592520113018-180c8bc831c9?auto=format&fit=crop&w=900&q=60';
    name = '';
    email = '';
    phoneNumber = '';
    password = '';
    isActive = false;
    linkedPatientCode = '';
    notifyListeners();
  }
}
