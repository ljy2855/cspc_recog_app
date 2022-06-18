import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:flutter/material.dart';

import 'package:cspc_recog/auth/models/user.dart';

class MyLoginUser with ChangeNotifier {
  User myUser;
  ProfileModel myProfile;

  MyLoginUser({
    this.myUser,
    this.myProfile,
  });

  User getUser() => this.myUser;
  ProfileModel getProfile() => this.myProfile;

  void setUser(User data) {
    myUser = data;
    notifyListeners();
  }

  void setProfile(final ProfileModel profile) {
    myProfile = profile;
    notifyListeners();
  }
}
